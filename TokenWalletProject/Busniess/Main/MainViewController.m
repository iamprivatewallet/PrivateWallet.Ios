//
//  MainViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MainViewController.h"
#import "BackupAlertMainView.h"
#import "MainTopWalletView.h"
#import "MainNavTitleView.h"
#import "MainTableViewCell.h"
#import "ChooseWalletView.h"
#import "MangeWalletsVC.h"
#import "AssetManagementVC.h"
#import "AllAssetsViewController.h"
#import "NodeChangeView.h"
#import "NodeSettingVC.h"
#import "TransferViewController.h"
#import "AddNewAddressVC.h"
#import "MangeIDWalletVC.h"
#import "FchainTool.h"
#import "PW_WalletContractTool.h"

@interface MainViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
ChooseWalletViewDelegate,
MainTopWalletViewDelegate,
WBQRCodeDelegate,
NodeChangeViewDelegate,
BackupAlertMainViewDelegate
>
@property (nonatomic, strong) BackupAlertMainView *backupAlert;
@property (nonatomic, strong) MainTopWalletView *topView;
@property (nonatomic, strong) MainNavTitleView *titleView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Wallet *ethWallet;
@property (nonatomic, strong) NSMutableArray *coinList;
@property (nonatomic, strong) NSMutableDictionary *priceMutDic_ETH;

@property(nonatomic, assign) BOOL isHiddenAmount;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self setNavTitle:@"" leftImg:@"walletSwitch" leftAction:@selector(navLeftItemWalletAction) rightImg:@"scan" rightAction:@selector(navRightItemScanAction) isNoLine:NO];
    [self makeViews];
    [self getWallets];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCoinList) name:@"RefreshCoinList_Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeUpdate:) name:kChainNodeUpdateNotification object:nil];
    [self showBackupViewStatus];
//    [self makeCoinList];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshDataList];
}
- (void)nodeUpdate:(NSNotification *)noti {
    [self chooseNodeWithModel:noti.object];
}
- (void)refreshDataList{
    [self refreshBalance];
}
//默认首次展示ETH
- (void)getWallets{
    NSArray *list = [[WalletManager shareWalletManager] getWallets];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Wallet *w = obj;
        NSString *choose_addr = User_manager.currentUser.chooseWallet_address;
        NSString *choose_type = User_manager.currentUser.chooseWallet_type;
        if ([w.address isEqualToString:choose_addr] && [w.type isEqualToString:choose_type]) {
            self.ethWallet = w;
        }
    }];
    [self makeCoinList];
}
//获取冷钱包 代币list
- (void)makeCoinList {
    if (self.coinList.count > 0) {
        [self.coinList removeAllObjects];
    }
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSString *chainType = [[SettingManager sharedInstance] getChainType];
    NSString *coinName = [[SettingManager sharedInstance] getChainCoinName];
    WalletCoinModel *model = [[WalletCoinModel alloc] init];
    model.tokenName = coinName;
//    model.icon = NSStringWithFormat(@"icon_%@",chainType);
    model.icon = AppWalletTokenIconURL(chainType,coinName);
    model.chainId = chainId;
    model.tokenAddress = self.ethWallet.address;
    model.usableAmount = @"0";
    model.usdtPrice = @"0";
    model.rmbAmount = @"0";
    model.decimals = 18;
    model.gas_price = @"0";
    model.nonce = @"0";
    model.isDefault = YES;
    model.currentWallet = self.ethWallet;
    [self.coinList addObject:model];
    [self.topView setTopViewWithData:model];
    [self.tableView reloadData];
    NSDictionary *paramsDict = @{
        @"tokenChain":chainId,
    };
    [self.view showLoadingIndicator];
    [self requestApi:WalletTokenIconURL params:paramsDict completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        NSArray *list = data;
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WalletCoinModel *model = [[WalletCoinModel alloc] init];
            model.tokenName = obj[@"tokenSymbol"];
            model.icon = obj[@"tokenLogo"];
            model.chainId = obj[@"tokenChain"];
            model.tokenAddress = obj[@"tokenContract"];
            model.usableAmount = @"0";
            model.usdtPrice = @"0";
            model.rmbAmount = @"0";
            model.decimals = [obj[@"tokenDecimals"] intValue];
            model.gas_price = @"0";
            model.nonce = @"0";
            model.isDefault = YES;
            model.currentWallet = self.ethWallet;
            [self.coinList addObject:model];
        }];
        [self loadCacheCoinList];
    } errBlock:^(NSString *msg) {
        [self.view hideLoadingIndicator];
        [self showFailMessage:msg];
    }];
//    NSArray *list;
//    if ([self.ethWallet.type isEqualToString:@"ETH"]) {
//        NSString *chainId = User_manager.currentUser.current_chainId;
//        if([chainId isEqualToString:kETHChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kETHChainId]) {
//            list= @[
//                @{
//                    @"title":@"ETH",
//                    @"address":self.ethWallet.address,
//                    @"decimals":@"18",
//                    @"chainId":kETHChainId,
//                    @"icon":@"icon_ETH"
//                },
//                @{
//                    @"title":@"USDT",
//                    @"address":@"0xdac17f958d2ee523a2206206994597c13d831ec7",
//                    @"chainId":kETHChainId,
//                    @"icon":@"icon_ETH"
//                },
//            ];
//        }else if([chainId isEqualToString:kBSCChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kBSCChainId]) {
//            list= @[
//                @{
//                    @"title":@"BNB",
//                    @"address":self.ethWallet.address,
//                    @"decimals":@"18",
//                    @"chainId":kBSCChainId,
//                    @"icon":@"icon_BSC"
//                },
//                @{
//                    @"title":@"USDT",
//                    @"address":@"0x55d398326f99059fF775485246999027B3197955",
//                    @"chainId":kBSCChainId,
//                    @"icon":@"icon_BSC"
//                },
//            ];
//        }else if([chainId isEqualToString:kHECOChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kHECOChainId]) {
//            list= @[
//                @{
//                    @"title":@"HT",
//                    @"address":self.ethWallet.address,
//                    @"decimals":@"18",
//                    @"chainId":kHECOChainId,
//                    @"icon":@"icon_HECO"
//                },
//                @{
//                    @"title":@"USDT",
//                    @"address":@"0xa71edc38d189767582c38a3145b5873052c3e47a",
//                    @"chainId":kHECOChainId,
//                    @"icon":@"icon_HECO"
//                },
//            ];
//        }else{
//            list= @[
//                @{
//                    @"title":@"ETH",
//                    @"address":self.ethWallet.address,
//                    @"decimals":@"18",
//                    @"chainId":chainId,
//                    @"icon":@"icon_ETH"
//                },
//            ];
//        }
//    }else if ([self.ethWallet.type isEqualToString:@"CVN"]) {
//        list= @[
//            @{
//                @"title":@"CVN",
//                @"address":self.ethWallet.address,
//                @"decimals":@"18",
//                @"chainId":kCVNChainId,
//                @"icon":@"icon_CVN"
//            },
//            @{
//                @"title":@"USDT",
//                @"address":@"0x940729720e2a83e20ac9cd7c97be46d3c3af4e6a",
//                @"chainId":kCVNChainId,
//                @"icon":@"icon_CVN"
//            },
//        ];
//    }else{
//        list= @[
//            @{
//                @"title":self.ethWallet.type,
//                @"address":self.ethWallet.address,
//                @"decimals":@"18",
//                @"chainId":@"1",
//                @"icon":@"icon_ETH"
//            },
//        ];
//    }
//    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        WalletCoinModel *model = [[WalletCoinModel alloc] init];
//        model.tokenName = obj[@"title"];
//        model.icon = obj[@"icon"];
//        model.chainId = obj[@"chainId"];
//        model.tokenAddress = obj[@"address"];
//        model.usableAmount = @"0";
//        model.rmbAmount = @"0";
//        model.decimals = [obj[@"decimals"] intValue];
//        model.gas_price = @"0";
//        model.nonce = @"0";
//        model.isDefault = YES;
//        model.currentWallet = self.ethWallet;
//        [self.coinList addObject:model];
//        if (idx == 0) {
//            [self.topView setTopViewWithData:model];
//        }
//    }];
//    [self loadCacheCoinList];
}
- (void)loadCacheCoinList {
    //获取缓存里 是否有代币列表
    NSArray *coinList = [[WalletCoinListManager shareManager] getListWithWalletAddress:self.ethWallet.address type:self.ethWallet.type chainId:User_manager.currentUser.current_chainId];
    [coinList enumerateObjectsUsingBlock:^(AssetCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![self isExitCoinWithAddress:obj.tokenContract]){
            WalletCoinModel *model = [WalletCoinModel new];
            model.tokenName = obj.tokenSymbol;
            model.icon = obj.tokenLogo;
            model.tokenAddress = obj.tokenContract;
            model.chainId = obj.tokenChain;
            model.usableAmount = @"0";
            model.usdtPrice = @"0";
            model.rmbAmount = @"0";
            model.decimals = obj.tokenDecimals.integerValue;
            model.gas_price = @"0";
            model.nonce = @"0";
            model.currentWallet = self.ethWallet;
            [self.coinList addObject:model];
        }
    }];
    [self.tableView reloadData];
    [self refreshBalance];
}
- (BOOL)isExitCoinWithAddress:(NSString *)address {
    if(![address isNoEmpty]){
        return NO;
    }
    __block BOOL isExit = NO;
    [self.coinList enumerateObjectsUsingBlock:^(WalletCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.tokenAddress isEqualToString:address]){
            isExit = YES;
            *stop = YES;
        }
    }];
    return isExit;
}
- (void)refreshBalance {
    if ([self.ethWallet.type isEqualToString:@"CVN"]) {
        [self loadCVNAllCoin];
        [self.coinList enumerateObjectsUsingBlock:^(WalletCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self requestApi:WalletTokenPriceURL params:@{@"tokenSymbol":obj.tokenName} completeBlock:^(id data) {
                obj.usdtPrice = NSStringWithFormat(@"%@",data);
                [self.tableView reloadData];
                [self refreshCVNTotal];
            } errBlock:nil];
        }];
    }else{
        [self loadETHAllBalance];
        [self.coinList enumerateObjectsUsingBlock:^(WalletCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self requestApi:WalletTokenPriceURL params:@{@"tokenSymbol":obj.tokenName} completeBlock:^(id data) {
                obj.usdtPrice = NSStringWithFormat(@"%@",data);
                [self.tableView reloadData];
                [self refreshTotal];
            } errBlock:nil];
        }];
    }
}
#pragma mark ETH 余额获取
- (void)loadETHAllBalance{
    [self refreshTotal];
    [self.coinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block WalletCoinModel *coin = obj;
        [self loadETHBalanceWithCoin:coin completion:^(id results) {
            coin.usableAmount = results;
            [self refreshTotal];
        }];
    }];
}
- (void)refreshTotal {
    self.ethWallet.totalBalance = 0;
    __block CGFloat totalBalance = 0;
    [self.coinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WalletCoinModel *coin = obj;
        if([coin.usableAmount isNoEmpty]&&[coin.usdtPrice isNoEmpty]){
            NSString *coinUsdt = [coin.usableAmount stringDownMultiplyingBy:coin.usdtPrice decimal:8];
            totalBalance = [[@(totalBalance).stringValue stringDownAdding:coinUsdt decimal:8] doubleValue];
        }
    }];
    self.ethWallet.totalBalance = totalBalance;
    [self.topView setTopViewWithData:self.coinList[0]];
    [[WalletManager shareWalletManager] updataWallet:self.ethWallet];
    [self.tableView reloadData];
}
//获取余额
- (void)loadETHBalanceWithCoin:(WalletCoinModel *)coin completion:(void (^)(id results))completion {
    NSDictionary *parmDic;
    if ([[coin.tokenAddress lowercaseString] isEqualToString:[self.ethWallet.address lowercaseString]]) {//主币
        parmDic = @{
            @"id":@"67",
            @"jsonrpc":@"2.0",
            @"method":@"eth_getBalance",
            @"params":@[self.ethWallet.address,@"latest"],
        };
        //eth余额查询
        [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
            if(error==nil){
                NSString *amount = [UITools bigStringWith16String:data[@"result"]];
                amount = [amount stringDownDividingBy10Power:18];
                completion(amount);
            }
        }];
    }else{ //代币
//        NSString *addr_str = [self.ethWallet.address substringFromIndex:2];//截取掉下标3之后的字符串
//        parmDic = @{
//            @"id":@"67",
//            @"jsonrpc":@"2.0",
//            @"method":@"eth_call",
//            @"params":@[@{
//                        @"data":NSStringWithFormat(@"0x70a08231000000000000000000000000%@",addr_str),
//                        @"from":self.ethWallet.address,
//                        @"to":coin.tokenAddress,
//                        },@"latest"],
//        };
//        [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
//            if(error==nil){
//                NSString *amount = [UITools bigStringWith16String:data[@"result"]];
//                amount = [amount stringDownDividingBy10Power:18];
//                completion(amount);
//            }
//        }];
        [PW_WalletContractTool balanceOfAddress:self.ethWallet.address contractAddress:coin.tokenAddress completionHandler:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
            if(coin.decimals>0){
                NSString *newAmount = [amount stringDownDividingBy10Power:coin.decimals];
                completion(newAmount);
            }else{
                [PW_WalletContractTool decimalsContractAddress:coin.tokenAddress completionHandler:^(NSInteger decimals, NSString * _Nullable errMsg) {
                    if(errMsg==nil){
                        coin.decimals = decimals;
                        NSString *newAmount = [amount stringDownDividingBy10Power:decimals];
                        completion(newAmount);
                    }
                }];
            }
        }];
    }
}

#pragma mark CVN 余额获取
-(void)loadCVNAllCoin{
    [self refreshCVNTotal];
    //CVN 主币
    WalletCoinModel *coin = self.coinList[0];
    [self loadGCSMainBalanceWith:coin completion:^(id results){
        if(results!=nil){
            coin.usableAmount = [results stringDownDecimal:6];
        }else{
            coin.usableAmount = @"0";
        }
        [self refreshCVNTotal];
    }];
    //USDT
    WalletCoinModel *coin1 = self.coinList[1];
    [self loadGCSBalanceWithAddr:coin1 completion:^(id results){
        if(results!=nil){
            coin1.usableAmount = [results stringDownDecimal:coin1.decimals];
        }else{
            coin1.usableAmount = @"0";
        }
        [self refreshCVNTotal];
    }];
}
- (void)refreshCVNTotal {
    self.ethWallet.totalBalance = 0;
    for (WalletCoinModel *coin in self.coinList) {
        if([coin.usableAmount isNoEmpty]){
            NSString *coinUsdt = [coin.usableAmount stringDownMultiplyingBy:coin.usdtPrice decimal:8];
            self.ethWallet.totalBalance += [coinUsdt doubleValue];
        }
    }
    [self.topView setTopViewWithData:self.coinList[0]];
    [[WalletManager shareWalletManager] updataWallet:self.ethWallet];
    [self.tableView reloadData];
}
//GCS主币余额查询
- (void)loadGCSMainBalanceWith:(WalletCoinModel *)coin completion:(void (^)(id results))completion {
    NSDictionary *param = @{
        @"address":[self.ethWallet.address formatDelCVN],
    };
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/fbs/act/pbgac.do",kCVNRPCUrl) withParameter:param withBlock:^(id data, NSError *error) {
        if (!error) {
            NSString *amount = [UITools bigStringWith16String:data[@"balance"]];
            amount = [amount stringDownDividingBy10Power:coin.decimals];
            //成功
            completion(amount);
        } else {
            //失败
            completion(nil);
        }
    }];
}
//GCS代币余额查询
- (void)loadGCSBalanceWithAddr:(WalletCoinModel *)coin completion:(void (^)(id results))completion {
    NSDictionary *param = @{
        @"to":coin.tokenAddress,
        @"data":NSStringWithFormat(@"0x70a08231000000000000000000000000%@",[self.ethWallet.address formatDelCVN])
    };
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/fbs/cvm/pbcal.do",kCVNRPCUrl) withParameter:param withBlock:^(id data, NSError *error) {
        if (!error) {
            NSString *value = data[@"result"];
            if (!value) {
                completion(@"0");
            }else{
                NSString *amount = [UITools bigStringWith16String:value];
                amount = [amount stringDownDividingBy10Power:coin.decimals];
                completion(amount);
            }
        } else {
            //失败
            completion(nil);
        }
    }];
}
#pragma mark UI
- (void)navLeftItemWalletAction{
    //钱包管理
    [self getChooseWalletView];
}
- (void)navRightItemScanAction{
    //扫描
    if (![CATCommon isHaveAuthorForCamer]) {
        return;
    }
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    WBVC.delegate = self;
    WBVC.zh_showCustomNav = YES;
    [UITools QRCodeFromVC:self scanVC:WBVC];
    
}
- (void)getChooseWalletView{
    ChooseWalletView *view = [ChooseWalletView getChooseWallet];
    view.delegate = self;
    
}
- (void)showBackupViewStatus{
    if (![User_manager isBackup]) {
        //显示未备份页
        [self showBackupAlertView];
    }else{
        if (self.backupAlert) {
            [self.backupAlert removeFromSuperview];
        }
    }
}
- (void)makeViews{
    [self addNavTitleView:self.titleView];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight+8);
        make.height.mas_equalTo(CGFloatScale(128));
    }];
    
    UILabel *detailTitleLbl = [ZZCustomView labelInitWithView:self.view text:@"代币" textColor:[UIColor blackColor] font:GCSFontRegular(17)];
    [detailTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(CGFloatScale(20));
        make.top.equalTo(self.topView.mas_bottom).offset(30);
    }];
    
    UIButton *addBtn = [ZZCustomView buttonInitWithView:self.view imageName:@"addContact"];
    [addBtn addTarget:self action:@selector(addAssetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.topView.mas_bottom).offset(31);
        make.width.height.mas_equalTo(CGFloatScale(23));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(detailTitleLbl.mas_bottom).offset(10);
        make.bottom.equalTo(self.view);
    }];
}

- (void)showBackupAlertView{
    if (!self.backupAlert) {
        self.backupAlert = [[BackupAlertMainView alloc] init];
        self.backupAlert.delegate = self;
        [self.view addSubview:self.backupAlert];
        [self.backupAlert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
        }];
    }
}
- (void)addAssetButtonAction{
    //跳转搜索资产
    AllAssetsViewController *vc = [[AllAssetsViewController alloc] init];
    vc.coinList = self.coinList;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.coinList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"currencyCell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewWithData:self.coinList[indexPath.row]];
    [cell changeAmountStatus];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetManagementVC *vc = [[AssetManagementVC alloc] init];
    vc.coinModel = self.coinList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:ChooseWalletViewDelegate
- (void)chooseWallet:(id)wallet{
    if (wallet && [wallet isKindOfClass:[Wallet class]]) {
        self.ethWallet = wallet;
        if([self.ethWallet.type isEqualToString:@"ETH"]){
            NSString *name = [[SettingManager sharedInstance] getNodeNameWithChainId:kETHChainId];
            NSString *node = [[SettingManager sharedInstance] getNodeWithChainId:kETHChainId];
            [User_manager updateCurrentNode:node chainId:kETHChainId name:name];
            [self.titleView setViewWithData:name];
        }else if([self.ethWallet.type isEqualToString:@"CVN"]){
            NSString *name = [[SettingManager sharedInstance] getNodeNameWithChainId:kCVNChainId];
            NSString *node = [[SettingManager sharedInstance] getNodeWithChainId:kCVNChainId];
            [User_manager updateCurrentNode:node chainId:kCVNChainId name:name];
            [self.titleView setViewWithData:name];
        }
        [self makeCoinList];
    }
}
- (void)jumpToManageVC{
    MangeWalletsVC *vc = [[MangeWalletsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK: MainTopWalletViewDelegate
- (void)clickAmountTextWithHidden{
    
    [self.tableView reloadData];
}

//MARK: WBQRCodeDelegate
- (void)scanNoPopWithResult:(NSString*)result{
    NSString *ethKey = @"ethereum:";
    NSString *contractKey = @"contractAddress=";
    NSString *valueKey = @"value=";
    ScanCodeInfoModel *infoMdl = [[ScanCodeInfoModel alloc] init];
    //转账
    TransferViewController *vc = [[TransferViewController alloc] init];
    if ([result containsString:ethKey]) {
        NSString *address = [UITools subRangeStr:result fromStart:ethKey toEnd:@"?"];
        [self checkTypeAddress:address withBlock:^{
            __block BOOL hasAddr = NO;
            NSRange range = [result rangeOfString:valueKey];
            NSString *amount = [result substringFromIndex:range.location+valueKey.length];
            infoMdl.addr = address;
            infoMdl.amount = amount;
            [self.coinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WalletCoinModel *mdl = obj;
                if ([result containsString:contractKey]) {
                    infoMdl.contractAddr = [UITools subRangeStr:result fromStart:contractKey toEnd:@"&"];
                    if ([mdl.tokenAddress isEqualToString:infoMdl.contractAddr]) {
                        hasAddr = YES;
                        vc.coinModel = mdl;
                    }else{
                        return [self showAlertViewWithTitle:@"" text:@"暂不支持此类币种" actionText:@"好"];
                    }
                }else{
                    if ([mdl.tokenAddress isEqualToString:mdl.currentWallet.address]) {
                        vc.coinModel = mdl;
                    }
                }
            }];
            vc.codeInfoModel = infoMdl;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        [self checkTypeAddress:result withBlock:^{
            [WarningAlertSheetView showClickViewWithItems:@[@"转账",@"新建地址"] action:^(NSInteger index) {
                if (index == 1) {
                    //转账
//                    __block BOOL isStop;
//                    [self.coinList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        WalletCoinModel *mdl = obj;
//                        //查找有余额的币
//                        if ([mdl.usableAmount doubleValue]>0) {
//                            vc.coinModel = mdl;
//                            isStop = YES;
//                        }
//                    }];
//                    if (!isStop) {
//                        //如果都没有余额，赋值第一个主币
//                        vc.coinModel = self.coinList.firstObject;
//                    }
                    vc.coinModel = self.coinList.firstObject;
                    infoMdl.addr = result;
                    infoMdl.amount = @"0";
                    vc.codeInfoModel = infoMdl;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if(index == 2){
                    //新建地址
                    AddNewAddressVC *vc = [[AddNewAddressVC alloc] init];
                    ChooseCoinTypeModel *mdl = [[ChooseCoinTypeModel alloc] init];
                    mdl.address = result;
                    vc.chooseModel = mdl;
                    vc.isScanCodeAddr = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }];
    }
}
//判断地址类型
- (void)checkTypeAddress:(NSString *)address withBlock:(void(^)(void))compeleBlock {
    if([address hasPrefix:@"0x"]&&address.length==42){//eth
        if([self.ethWallet.type isEqualToString:@"ETH"]){
            compeleBlock();
        }else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:NSStringWithFormat(@"检测到是ETH链，是否切换到ETH钱包转账") preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self updateWallet:@"ETH"];
                compeleBlock();
            }];
            UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:alertA];
            [alertC addAction:cancelA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }else if([address hasPrefix:@"CVN"]&&address.length==43){//cvn
        if([self.ethWallet.type isEqualToString:@"CVN"]){
            compeleBlock();
        }else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:NSStringWithFormat(@"检测到是CVN链，是否切换到CVN钱包转账") preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self updateWallet:@"CVN"];
                compeleBlock();
            }];
            UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:alertA];
            [alertC addAction:cancelA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }else{
        return [MBProgressHUD SG_showMBProgressHUDOfErrorMessage:@"地址格式有误" toView:self.view];
    }
    
}
- (void)updateWallet:(NSString *)type{
    NSArray *orignList = [[WalletManager shareWalletManager] getOrignWallets];
    NSArray *importList = [[WalletManager shareWalletManager] getImportWallets];
    NSMutableArray *allList = [NSMutableArray arrayWithArray:orignList];
    [allList addObjectsFromArray:importList];
    for (NSInteger i=0; i<allList.count; i++) {
        Wallet *wallet = allList[i];
        if([wallet.type isEqualToString:type]){
            [self chooseWallet:wallet];
            [User_manager updateChooseWallet:wallet];
            break;
        }
    }
}
//MARK: NodeChangeViewDelegate
- (void)jumpToNodeSettingVC{
    //跳转Node设置页
    NodeSettingVC *vc = [[NodeSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseNodeWithModel:(id)model{
    if ([model isKindOfClass:[NodeModel class]]) {
        NodeModel *data = model;
        [self.titleView setViewWithData:data];
        [self makeCoinList];
        [self refreshDataList];
    }
}

//MARK: BackupAlertMainViewDelegate
- (void)backupAlertBtnAciton:(NSInteger)index{
    if (index == 0) {
        [self.backupAlert removeFromSuperview];
    }else{
        MangeIDWalletVC *vc = [[MangeIDWalletVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark getter
- (MainNavTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[MainNavTitleView alloc] init];
        __weak typeof(self) weakSelf = self;
        [_titleView clickNode:^{
            if ([weakSelf.ethWallet.type isEqualToString:@"ETH"]) {
                //点击顶部网络
                NodeChangeView *node = [NodeChangeView showNodeView];
                node.delegate = weakSelf;
            }
        }];
    }
    return _titleView;
}
- (MainTopWalletView *)topView{
    if (!_topView) {
        _topView = [[MainTopWalletView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = CGFloatScale(70);
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 70, 0, 0)];
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.separatorColor = [UIColor im_borderLineColor];
    if (@available(iOS 11.0, *)) {
    
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   }
    return _tableView;
}
- (NSMutableArray *)coinList{
    if (!_coinList) {
        _coinList = [[NSMutableArray alloc] init];
    }
    return _coinList;
}
- (NSMutableDictionary *)priceMutDic_ETH{
    if (!_priceMutDic_ETH) {
        _priceMutDic_ETH = [[NSMutableDictionary alloc] init];
    }
    return _priceMutDic_ETH;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
