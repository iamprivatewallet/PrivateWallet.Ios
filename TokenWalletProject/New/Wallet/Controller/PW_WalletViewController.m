//
//  PW_WalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletViewController.h"
#import "PW_ScanTool.h"
#import "PW_WalletCell.h"
#import "PW_ContractTool.h"
#import "PW_TokenDetailViewController.h"
#import "PW_CollectionViewController.h"
#import "PW_WalletView.h"
#import "PW_SelectWalletTypeViewController.h"

@interface PW_WalletViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *headerView;

@property (nonatomic, weak) UIView *currencyHeaderView;
@property (nonatomic, weak) UIButton *hiddenSmallBtn;

@property (nonatomic, weak) UILabel *walletNameLb;
@property (nonatomic, weak) UIButton *showHiddenBtn;
@property (nonatomic, weak) UILabel *walletAddressLb;
@property (nonatomic, weak) UILabel *totalAssetsLb;

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *addCurrencyView;
@property (nonatomic, weak) UIView *backupTipView;

@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *coinList;
@property (nonatomic, strong) Wallet *currentWallet;

@end

@implementation PW_WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"" leftImg:@"icon_wallet" leftAction:@selector(createWalletAction) rightImg:@"icon_scan" rightAction:@selector(scanAction) isNoLine:YES isWhiteBg:NO];
    [self makeViews];
    [self getWallets];
    self.hiddenSmallBtn.selected = [GetUserDefaultsForKey(kHiddenWalletSmallAmount) boolValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"RefreshCoinList_Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeUpdate) name:kChainNodeUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWallets) name:kChangeWalletNotification object:nil];
    [RACObserve(self, backupTipView) subscribeNext:^(UIView * _Nullable x) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.currencyHeaderView.mas_bottom).offset(16);
            make.left.right.offset(0);
            if(x==nil){
                make.bottom.offset(0);
            }else{
                make.bottom.equalTo(x.mas_top).offset(-10);
            }
        }];
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshBalance];
    [self showBackupView];
}
- (void)showBackupView {
    if ([User_manager isBackup]) {
        if (self.backupTipView) {
            [self.backupTipView removeFromSuperview];
        }
    }
}
- (void)searchAction {
    
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        
    }];
}
- (void)createWalletAction {
    PW_SelectWalletTypeViewController *vc = [[PW_SelectWalletTypeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)changeWalletAction {
    [PW_WalletView show];
}
- (void)showHiddenAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    SetUserDefaultsForKey(btn.selected?@"1":@"0", kHiddenWalletAmount);
    [UserDefaults synchronize];
    [self refreshHeader];
    [self.tableView reloadData];
}
- (void)copyAction {
    [self.currentWallet.address pasteboardToast:YES];
    [self showSuccess:LocalizedStr(@"text_copySuccess")];
}
- (void)transferAction {
    
}
- (void)collectionAction {
    PW_CollectionViewController *vc = [PW_CollectionViewController new];
    vc.model = self.coinList.firstObject;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)editAction {
    
}
- (void)addCurrencyAction {
    
}
- (void)hiddenSmallAction:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    SetUserDefaultsForKey(btn.selected?@"1":@"0", kHiddenWalletSmallAmount);
    [UserDefaults synchronize];
    [self.tableView reloadData];
}
- (void)addAction {
    
}
- (void)requestData {
    [self refreshHeader];
    [self.coinList removeAllObjects];
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSString *chainType = [[SettingManager sharedInstance] getChainType];
    NSString *coinName = [[SettingManager sharedInstance] getChainCoinName];
    PW_TokenModel *model = [[PW_TokenModel alloc] init];
    model.tokenName = coinName;
    model.tokenLogo = AppWalletTokenIconURL(chainType,coinName);
    model.tokenChain = chainId.integerValue;
    model.tokenContract = self.currentWallet.address;
    model.tokenAmount = @"0";
    model.price = @"0";
    model.tokenDecimals = 18;
    model.isDefault = YES;
    [self.coinList addObject:model];
    [self.tableView reloadData];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenIconURL params:@{@"tokenChain":chainId} completeBlock:^(id  _Nonnull data) {
        dispatch_semaphore_signal(semaphore);
        [self.view hideLoadingIndicator];
        NSArray *array = [PW_TokenModel mj_objectArrayWithKeyValuesArray:data];
        [self.coinList addObjectsFromArray:array];
        [self loadCacheCoinList];
    } errBlock:^(NSString * _Nonnull msg) {
        dispatch_semaphore_signal(semaphore);
        [self loadCacheCoinList];
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)loadCacheCoinList {
    //获取缓存里 是否有代币列表
    NSArray *coinList = [[WalletCoinListManager shareManager] getListWithWalletAddress:self.currentWallet.address type:self.currentWallet.type chainId:User_manager.currentUser.current_chainId];
    [coinList enumerateObjectsUsingBlock:^(AssetCoinModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![self isExitCoinWithAddress:obj.tokenContract]){
            PW_TokenModel *model = [PW_TokenModel new];
            model.tokenName = obj.tokenSymbol;
            model.tokenLogo = obj.tokenLogo;
            model.tokenContract = obj.tokenContract;
            model.tokenChain = obj.tokenChain.integerValue;
            model.tokenAmount = @"0";
            model.price = @"0";
            model.tokenDecimals = obj.tokenDecimals.integerValue;
            [self.coinList addObject:model];
        }
    }];
    [self.tableView reloadData];
    [self refreshBalance];
}
- (BOOL)isExitCoinWithAddress:(NSString *)address {
    if([address isEmptyStr]){
        return NO;
    }
    __block BOOL isExit = NO;
    [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.tokenContract isEqualToString:address]){
            isExit = YES;
            *stop = YES;
        }
    }];
    return isExit;
}
- (void)refreshBalance {
    if ([self.currentWallet.type isEqualToString:@"CVN"]) {
        [self loadCVNAllCoin];
        [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self pw_requestApi:WalletTokenPriceURL params:@{@"tokenSymbol":obj.tokenName} completeBlock:^(id data) {
                obj.price = NSStringWithFormat(@"%@",data);
                [self.tableView reloadData];
                [self refreshCVNTotal];
            } errBlock:nil];
        }];
    }else{
        [self loadAllBalance];
        [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self pw_requestApi:WalletTokenPriceURL params:@{@"tokenSymbol":obj.tokenName} completeBlock:^(id data) {
                obj.price = NSStringWithFormat(@"%@",data);
                [self.tableView reloadData];
                [self refreshTotal];
            } errBlock:nil];
        }];
    }
}
- (void)refreshHeader {
    self.walletNameLb.text = User_manager.currentUser.current_name;
    BOOL isHidden = [GetUserDefaultsForKey(kHiddenWalletAmount) boolValue];
    self.showHiddenBtn.selected = isHidden;
    if (isHidden) {
        self.walletAddressLb.text = NSStringWithFormat(@"%@****",[self.currentWallet.address contractPrefix]);
    }else{
        self.walletAddressLb.text = [self.currentWallet.address showShortAddress];
    }
    self.totalAssetsLb.text = [@(self.currentWallet.totalBalance).stringValue stringDownDecimal:8];
}
- (void)nodeUpdate {
    [self refreshHeader];
    [self requestData];
}
- (void)getWallets{
    NSArray *list = [[WalletManager shareWalletManager] getWallets];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Wallet *w = obj;
        NSString *choose_addr = User_manager.currentUser.chooseWallet_address;
        NSString *choose_type = User_manager.currentUser.chooseWallet_type;
        if ([w.address isEqualToString:choose_addr] && [w.type isEqualToString:choose_type]) {
            self.currentWallet = w;
        }
    }];
    [self requestData];
}
#pragma mark ETH 余额获取
- (void)loadAllBalance{
    [self refreshTotal];
    [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
        [self loadETHBalanceWithCoin:coin completion:^(NSString *amount) {
            coin.tokenAmount = amount;
            [self refreshTotal];
        }];
    }];
}
- (void)refreshTotal {
    self.currentWallet.totalBalance = 0;
    __block CGFloat totalBalance = 0;
    [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![coin.tokenAmount isEmptyStr]&&![coin.price isEmptyStr]){
            NSString *coinUsdt = [coin.tokenAmount stringDownMultiplyingBy:coin.price decimal:8];
            totalBalance = [[@(totalBalance).stringValue stringDownAdding:coinUsdt decimal:8] doubleValue];
        }
    }];
    self.currentWallet.totalBalance = totalBalance;
    [self refreshHeader];
    [[WalletManager shareWalletManager] updataWallet:self.currentWallet];
    [self.tableView reloadData];
}
//获取余额
- (void)loadETHBalanceWithCoin:(PW_TokenModel *)coin completion:(void (^)(NSString *amount))completion {
    if ([[coin.tokenContract lowercaseString] isEqualToString:[self.currentWallet.address lowercaseString]]) {//主币
        [PW_ContractTool loadETHMainBalanceDecimals:coin.tokenDecimals completion:^(NSString * _Nonnull amount) {
            if(completion&&amount!=nil) {
                completion(amount);
            }
        }];
    }else{
        [MOSWalletContractTool getBalanceERC20WithContractAddress:coin.tokenContract completionBlock:^(NSString * _Nullable amount, NSString * _Nullable errMsg) {
            if(coin.tokenDecimals>0){
                NSString *newAmount = [amount stringDownDividingBy10Power:coin.tokenDecimals];
                completion(newAmount);
            }else{
                [MOSWalletContractTool getDecimalsERC20WithContractAddress:coin.tokenContract completionBlock:^(NSInteger decimals, NSString * _Nullable errMsg) {
                    if(errMsg==nil){
                        coin.tokenDecimals = decimals;
                        NSString *newAmount = [amount stringDownDividingBy10Power:decimals];
                        completion(newAmount);
                    }
                }];
            }
        }];
    }
}
#pragma mark CVN 余额获取
- (void)loadCVNAllCoin{
    [self refreshCVNTotal];
    [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
        [self loadCVNBalanceWithCoin:coin completion:^(NSString *amount) {
            coin.tokenAmount = [amount stringDownDecimal:6];
            [self refreshCVNTotal];
        }];
    }];
}
- (void)loadCVNBalanceWithCoin:(PW_TokenModel *)coin completion:(void (^)(NSString *amount))completion {
    if ([[coin.tokenContract lowercaseString] isEqualToString:[self.currentWallet.address lowercaseString]]) {//主币
        [PW_ContractTool loadCVNMainBalanceDecimals:coin.tokenDecimals completion:^(NSString * _Nonnull amount) {
            if(completion&&amount!=nil) {
                completion(amount);
            }
        }];
    }else{
        [PW_ContractTool loadCVNTokenBalance:coin.tokenContract decimals:coin.tokenDecimals completion:^(NSString * _Nonnull amount) {
            if(completion&&amount!=nil) {
                completion(amount);
            }
        }];
    }
}
- (void)refreshCVNTotal {
    self.currentWallet.totalBalance = 0;
    for (PW_TokenModel *coin in self.coinList) {
        if(![coin.tokenAmount isEmptyStr]){
            NSString *coinUsdt = [coin.tokenAmount stringDownMultiplyingBy:coin.price decimal:8];
            self.currentWallet.totalBalance += [coinUsdt doubleValue];
        }
    }
    [self refreshHeader];
    [[WalletManager shareWalletManager] updataWallet:self.currentWallet];
    [self.tableView reloadData];
}
#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coinList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_WalletCell"];
    NSAssert(cell, @"cell is nil");
    cell.model = self.coinList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_TokenDetailViewController *vc = [PW_TokenDetailViewController new];
    vc.model = self.coinList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - View
- (void)makeViews {
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"first_bg"]];
    [self.view insertSubview:bgIv atIndex:0];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    UIButton *searchBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_searchDappCurrency") fontSize:12 titleColor:[UIColor g_grayTextColor] imageName:@"icon_search" target:self action:@selector(searchAction)];
    searchBtn.layer.cornerRadius = 17.5;
    searchBtn.backgroundColor = [UIColor g_bgColor];
    [self.naviBar addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(78);
        make.right.offset(-78);
        make.height.offset(35);
        make.bottom.offset(-5);
    }];
    [self createWalletHeader];
    [self createCurrencyHeader];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currencyHeaderView.mas_bottom).offset(16);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    [self createBackupTip];
}
- (void)createWalletHeader {
    UIView *headerView = [[UIView alloc] init];
    headerView.layer.cornerRadius = 22;
    [headerView setShadowColor:[UIColor g_hex:@"#00A4B8" alpha:0.4] offset:CGSizeMake(0, 5) radius:21];
    [self.view addSubview:headerView];
    self.headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.top.offset(kNavBarAndStatusBarHeight+10);
        make.right.offset(-25);
        make.height.offset(188);
    }];
    UIImage *bgImage = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH-50, 188) gradientColors:@[[UIColor g_hex:@"#00D5E9"],[UIColor g_hex:@"#00A4B9"]] gradientType:PW_GradientLeftToRight cornerRadius:22];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:bgImage];
    [headerView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIView *walletNameView = [[UIView alloc] init];
    walletNameView.layer.borderColor = [UIColor g_hex:@"#F0F8F9" alpha:0.7].CGColor;
    walletNameView.layer.borderWidth = 1;
    walletNameView.layer.cornerRadius = 12;
    [headerView addSubview:walletNameView];
    [walletNameView addTapTarget:self action:@selector(changeWalletAction)];
    [walletNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(18);
        make.height.offset(24);
    }];
    UILabel *nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    [walletNameView addSubview:nameLb];
    self.walletNameLb = nameLb;
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.centerY.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down"]];
    [walletNameView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLb.mas_right).offset(2);
        make.centerY.offset(0);
        make.right.offset(-8);
    }];
    UIButton *showHiddenBtn = [[UIButton alloc] init];
    [showHiddenBtn setImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
    [showHiddenBtn setImage:[UIImage imageNamed:@"icon_hidden"] forState:UIControlStateSelected];
    [showHiddenBtn addTarget:self action:@selector(showHiddenAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:showHiddenBtn];
    self.showHiddenBtn = showHiddenBtn;
    [showHiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(walletNameView.mas_right).offset(12);
        make.centerY.equalTo(walletNameView);
    }];
    UILabel *walletAddressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    [headerView addSubview:walletAddressLb];
    self.walletAddressLb = walletAddressLb;
    [walletAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletNameView.mas_bottom).offset(10);
        make.left.offset(22);
    }];
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"icon_copy_big"] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:copyBtn];
    [headerView addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(walletAddressLb.mas_right).offset(8);
        make.centerY.equalTo(walletAddressLb);
    }];
    UILabel *totalAssetsLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:36 textColor:[UIColor whiteColor]];
    [headerView addSubview:totalAssetsLb];
    self.totalAssetsLb = totalAssetsLb;
    [totalAssetsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletAddressLb.mas_bottom).offset(10);
        make.left.offset(22);
    }];
    UILabel *assetsLb = [PW_ViewTool labelText:LocalizedStr(@"text_assets") fontSize:12 textColor:[UIColor whiteColor]];
    [headerView addSubview:assetsLb];
    [assetsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalAssetsLb.mas_bottom);
        make.left.offset(25);
    }];
    UIButton *transferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_transfer") fontSize:14 titleColor:[UIColor whiteColor] imageName:@"icon_transfer" target:self action:@selector(transferAction)];
    [headerView addSubview:transferBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-18);
        make.left.offset(26);
    }];
    UIButton *collectionBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_collection") fontSize:14 titleColor:[UIColor whiteColor] imageName:@"icon_collection" target:self action:@selector(collectionAction)];
    [headerView addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(transferBtn.mas_right).offset(38);
        make.centerY.equalTo(transferBtn);
    }];
}
- (void)createCurrencyHeader {
    UIView *headerView = [[UIView alloc] init];
    [self.view addSubview:headerView];
    self.currencyHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(22);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_currency") fontSize:15 textColor:[UIColor g_textColor]];
    [headerView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    UIButton *editBtn = [PW_ViewTool buttonImageName:@"icon_edit" target:self action:@selector(editAction)];
    [headerView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb.mas_right).offset(6);
        make.centerY.offset(0);
    }];
    UIButton *addBtn = [PW_ViewTool buttonImageName:@"icon_add_gray" target:self action:@selector(addAction)];
    [headerView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.offset(0);
    }];
    UIButton *hiddenSmallBtn = [PW_ViewTool buttonImageName:@"icon_switch_off" selectedImage:@"icon_switch_on" target:self action:@selector(hiddenSmallAction:)];
    [headerView addSubview:hiddenSmallBtn];
    self.hiddenSmallBtn = hiddenSmallBtn;
    [hiddenSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left).offset(-12);
        make.centerY.offset(0);
    }];
}
- (void)createBackupTip {
    UIView *backupTipView = [[UIView alloc] init];
    backupTipView.layer.cornerRadius = 12;
    backupTipView.backgroundColor = [UIColor g_warnBgColor];
    [self.view addSubview:backupTipView];
    self.backupTipView = backupTipView;
    [backupTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-20);
    }];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_warning"]];
    [backupTipView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_backupTip") fontSize:12 textColor:[UIColor g_warnColor]];
    [backupTipView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(4);
        make.right.offset(-5);
        make.top.offset(8);
        make.bottom.offset(-8);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_warn"] forState:UIControlStateNormal];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
        [button.superview removeFromSuperview];
    }];
    [backupTipView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(-2);
    }];
}
#pragma mark - Getter
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_WalletCell class] forCellReuseIdentifier:@"PW_WalletCell"];
        _tableView.rowHeight = 70;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.addCurrencyView;
    }
    return _tableView;
}
- (UIView *)addCurrencyView {
    if (!_addCurrencyView) {
        _addCurrencyView = [[UIView alloc] init];
        _addCurrencyView.frame = CGRectMake(0, 0, 0, 54);
        UIButton *addCurrencyBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addCurrency") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addCurrencyAction)];
        addCurrencyBtn.frame = CGRectMake(20, 10, SCREEN_WIDTH-40, 44);
        [addCurrencyBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
        [_addCurrencyView addSubview:addCurrencyBtn];
        [addCurrencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(20);
            make.right.offset(-20);
            make.height.offset(44);
        }];
    }
    return _addCurrencyView;
}
- (NSMutableArray<PW_TokenModel *> *)coinList {
    if (!_coinList) {
        _coinList = [NSMutableArray array];
    }
    return _coinList;
}

@end
