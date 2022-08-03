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
#import "PW_WalletNFTCell.h"
#import "PW_ContractTool.h"
#import "PW_TokenDetailViewController.h"
#import "PW_CollectionViewController.h"
#import "PW_TransferViewController.h"
#import "PW_WalletView.h"
#import "PW_SelectWalletTypeViewController.h"
#import "PW_SearchDappViewController.h"
#import "PW_SearchCurrencyViewController.h"
#import "PW_CurrencyManageViewController.h"
#import "PW_SearchNFTViewController.h"
#import "PW_PersonNFTViewController.h"
#import "PW_HoldNFTViewController.h"

@interface PW_WalletViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *headerView;

@property (nonatomic, weak) UIView *currencyHeaderView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) UIButton *menuBtn;
@property (nonatomic, weak) UIButton *searchBtn;
@property (nonatomic, weak) UIButton *hiddenSmallBtn;

@property (nonatomic, weak) UILabel *walletNameLb;
@property (nonatomic, weak) UIButton *showHiddenBtn;
@property (nonatomic, weak) UILabel *walletAddressLb;
@property (nonatomic, weak) UILabel *totalAssetsLb;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIView *addCurrencyView;
@property (nonatomic, weak) UIView *backupTipView;

@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *coinList;
@property (nonatomic, strong) Wallet *currentWallet;

@end

@implementation PW_WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"" leftImg:nil leftAction:nil rightImg:@"icon_scan" rightAction:@selector(scanAction) isNoLine:YES];
    [self makeViews];
    [self getWallets];
    self.hiddenSmallBtn.selected = [GetUserDefaultsForKey(kHiddenWalletSmallAmount) boolValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceRefreshCacheCoinList) name:kRefreshCoinListNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodeUpdate) name:kChainNodeUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWallets) name:kChangeWalletNotification object:nil];
//    [RACObserve(self, backupTipView) subscribeNext:^(UIView * _Nullable x) {
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.currencyHeaderView.mas_bottom).offset(16);
//            make.left.right.offset(0);
//            if(x==nil){
//                make.bottom.offset(0);
//            }else{
//                make.bottom.equalTo(x.mas_top).offset(-10);
//            }
//        }];
//    }];
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
    }else{
        self.backupTipView.hidden = NO;
    }
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        if ([result isContract]||[PW_TronContractTool isAddress:result]) {
            PW_TransferViewController *vc = [[PW_TransferViewController alloc] init];
            vc.toAddress = result;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        PW_SearchDappViewController *vc = [[PW_SearchDappViewController alloc] init];
        vc.searchStr = result;
        [self.navigationController pushViewController:vc animated:YES];
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
    PW_TransferViewController *vc = [PW_TransferViewController new];
    vc.model = self.coinList.firstObject;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)collectionAction {
    PW_CollectionViewController *vc = [PW_CollectionViewController new];
    vc.model = self.coinList.firstObject;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)hiddenSmallAction:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    SetUserDefaultsForKey(btn.selected?@"1":@"0", kHiddenWalletSmallAmount);
    [UserDefaults synchronize];
    [self forceRefreshCacheCoinList];
}
- (void)searchAction {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:{
            PW_SearchCurrencyViewController *vc = [[PW_SearchCurrencyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            PW_SearchNFTViewController *vc = [[PW_SearchNFTViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)menuChangeAction {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:{
            self.hiddenSmallBtn.hidden = NO;
            [self.hiddenSmallBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.searchBtn.mas_left).offset(-12);
                make.centerY.offset(0);
            }];
        }
            break;
        case 1:{
            self.hiddenSmallBtn.hidden = YES;
            [self.hiddenSmallBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.searchBtn.mas_right);
                make.centerY.offset(0);
            }];
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
- (void)menuAction {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:{
            PW_CurrencyManageViewController *vc = [[PW_CurrencyManageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            PW_PersonNFTViewController *vc = [[PW_PersonNFTViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)addCurrencyAction {
    PW_SearchCurrencyViewController *vc = [[PW_SearchCurrencyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)requestData {
    [self refreshHeader];
    [self.coinList removeAllObjects];
    User *user = User_manager.currentUser;
    NSString *chainId = user.current_chainId;
    NSString *chainType = [[SettingManager sharedInstance] getChainType];
    NSString *coinName = [[SettingManager sharedInstance] getChainCoinName];
    PW_TokenModel *model = [[PW_TokenModel alloc] init];
    model.tokenName = coinName;
    model.tokenSymbol = coinName;
    model.tokenLogo = AppWalletTokenIconURL(chainType,coinName);
    model.tokenChain = chainId.integerValue;
    model.tokenContract = self.currentWallet.address;
    model.tokenAmount = @"0";
    model.price = @"0";
    if ([user.chooseWallet_type isEqualToString:kWalletTypeTron]) {
        model.tokenDecimals = 6;
    }else{
        model.tokenDecimals = 18;
    }
    model.isDefault = YES;
    PW_TokenModel *exitModel = [[PW_TokenManager shared] isExist:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
    if (exitModel==nil) {
        model.sortIndex = [[PW_TokenManager shared] getMaxIndex]+1;
        model.walletType = user.chooseWallet_type;
        model.walletAddress = user.chooseWallet_address;
        model.createTime = @([NSDate new].timeIntervalSince1970).stringValue;
        [[PW_TokenManager shared] saveCoin:model];
    }
    [self forceRefreshCacheCoinList];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenIconURL params:@{@"tokenChain":chainId} completeBlock:^(id  _Nonnull data) {
        dispatch_semaphore_signal(semaphore);
        [self.view hideLoadingIndicator];
        NSArray *array = [PW_TokenModel mj_objectArrayWithKeyValuesArray:data];
        for (PW_TokenModel *model in array) {
            PW_TokenModel *exitModel = [[PW_TokenManager shared] isExist:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
            if (exitModel==nil) {
                model.sortIndex = [[PW_TokenManager shared] getMaxIndex]+1;
                model.walletType = user.chooseWallet_type;
                model.walletAddress = user.chooseWallet_address;
                model.createTime = @([NSDate new].timeIntervalSince1970).stringValue;
                [[PW_TokenManager shared] saveCoin:model];
            }
        }
        [self forceRefreshCacheCoinList];
    } errBlock:^(NSString * _Nonnull msg) {
        dispatch_semaphore_signal(semaphore);
        [self loadCacheCoinList];
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)forceRefreshCacheCoinList {
//    NSMutableArray *tempArr = [NSMutableArray array];
//    for (PW_TokenModel *model in self.coinList) {
//        if (!model.isDefault) {
//            [tempArr addObject:model];
//        }
//    }
    [self.coinList removeAllObjects];
    [self loadCacheCoinList];
}
- (void)loadCacheCoinList {
    //获取缓存里 是否有代币列表
    NSArray *coinList = [[PW_TokenManager shared] getListWithWalletAddress:self.currentWallet.address type:self.currentWallet.type chainId:User_manager.currentUser.current_chainId.integerValue];
    BOOL isHiddenSmall = [GetUserDefaultsForKey(kHiddenWalletSmallAmount) boolValue];
    [coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![self isExitsCoinWithAddress:model.tokenContract]){
            if(!(isHiddenSmall&&model.tokenAmount.doubleValue<g_smallAmount&&!model.isDefault)){
                [self.coinList addObject:model];
            }
        }
    }];
    [[PW_GlobalData shared] updateCoinList:self.coinList];
    [self.tableView reloadData];
    [self refreshBalance];
}
- (BOOL)isExitsCoinWithAddress:(NSString *)address {
    if(![address isNoEmpty]){
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
    [self loadAllBalance];
    [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self pw_requestApi:WalletTokenPriceURL params:@{@"tokenSymbol":obj.tokenName} completeBlock:^(id data) {
            obj.price = NSStringWithFormat(@"%@",data);
            [[PW_TokenManager shared] updateCoin:obj];
            [self.tableView reloadData];
            [self refreshTotal];
        } errBlock:nil];
    }];
}
- (void)refreshHeader {
    self.walletNameLb.text = self.currentWallet.walletName;
    BOOL isHidden = [GetUserDefaultsForKey(kHiddenWalletAmount) boolValue];
    self.showHiddenBtn.selected = isHidden;
    if (isHidden) {
        self.walletAddressLb.text = NSStringWithFormat(@"%@****",[self.currentWallet.address contractPrefix]);
        self.totalAssetsLb.text = @"****";
    }else{
        self.walletAddressLb.text = [self.currentWallet.address showShortAddress];
        self.totalAssetsLb.text = NSStringWithFormat(@"$%@",[@(self.currentWallet.totalBalance).stringValue stringDownDecimal:8]);
    }
}
- (void)nodeUpdate {
    [self refreshHeader];
    [self requestData];
}
- (void)getWallets{
    NSArray *list = [[PW_WalletManager shared] getWallets];
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
#pragma mark balance
- (void)loadAllBalance{
    [self refreshTotal];
    if ([self.currentWallet.type isEqualToString:kWalletTypeCVN]) {
        [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
            [PW_ContractTool loadCVNBalance:coin completion:^(NSString * _Nonnull amount) {
                coin.tokenAmount = [amount stringDownDecimal:6];
                [[PW_TokenManager shared] updateCoin:coin];
                [self refreshTotal];
            }];
        }];
    }else if([self.currentWallet.type isEqualToString:kWalletTypeTron]){
        [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
            [PW_ContractTool loadTronBalance:coin completion:^(NSString *amount) {
                coin.tokenAmount = [amount stringDownDecimal:6];
                [[PW_TokenManager shared] updateCoin:coin];
                [self refreshTotal];
            }];
        }];
    }else{
        [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
            [PW_ContractTool loadETHBalance:coin completion:^(NSString *amount) {
                coin.tokenAmount = amount;
                [[PW_TokenManager shared] updateCoin:coin];
                [self refreshTotal];
            }];
        }];
    }
}
- (void)refreshTotal {
    self.currentWallet.totalBalance = 0;
    __block CGFloat totalBalance = 0;
    [self.coinList enumerateObjectsUsingBlock:^(PW_TokenModel * _Nonnull coin, NSUInteger idx, BOOL * _Nonnull stop) {
        if([coin.tokenAmount isNoEmpty]&&[coin.price isNoEmpty]){
            NSString *coinUsdt = [coin.tokenAmount stringDownMultiplyingBy:coin.price decimal:8];
            totalBalance = [[@(totalBalance).stringValue stringDownAdding:coinUsdt decimal:8] doubleValue];
        }
    }];
    self.currentWallet.totalBalance = totalBalance;
    [self refreshHeader];
    [[PW_WalletManager shared] updateWallet:self.currentWallet];
    [self.tableView reloadData];
}
#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index==0) {
        return self.coinList.count;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index==0) {
        PW_WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_WalletCell"];
        NSAssert(cell, @"cell is nil");
        cell.model = self.coinList[indexPath.row];
        return cell;
    }
    PW_WalletNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_WalletNFTCell"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index==0) {
        PW_TokenDetailViewController *vc = [PW_TokenDetailViewController new];
        vc.model = self.coinList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PW_HoldNFTViewController *vc = [[PW_HoldNFTViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index==0) {
        return 75;
    }
    return 68;
}
#pragma mark - View
- (void)makeViews {
    UIView *walletNameView = [[UIView alloc] init];
    [walletNameView setBorderColor:[UIColor g_primaryColor] width:1 radius:8];
    [self.naviBar addSubview:walletNameView];
    [walletNameView addTapTarget:self action:@selector(changeWalletAction)];
    [walletNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(28);
        make.left.equalTo(self.naviBar).offset(CGFloatScale(18));
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
    UILabel *nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    [walletNameView addSubview:nameLb];
    self.walletNameLb = nameLb;
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.centerY.offset(0);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH*0.5);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_triangle_down"]];
    [walletNameView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLb.mas_right).offset(2);
        make.centerY.offset(0);
        make.right.offset(-8);
    }];
//    UIButton *searchBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_searchDappCurrency") fontSize:12 titleColor:[UIColor g_grayTextColor] imageName:@"icon_search" target:self action:@selector(searchAction)];
//    searchBtn.layer.cornerRadius = 17.5;
//    searchBtn.backgroundColor = [UIColor g_bgColor];
//    [self.naviBar addSubview:searchBtn];
//    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(78);
//        make.right.offset(-78);
//        make.height.offset(35);
//        make.bottom.offset(-5);
//    }];
    [self createWalletHeader];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(-28);
        make.left.right.bottom.offset(0);
    }];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
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
    [self.view addSubview:headerView];
    self.headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kNavBarAndStatusBarHeight);
        make.height.offset(120);
    }];
    UILabel *walletAddressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_whiteTextColor]];
    [headerView addSubview:walletAddressLb];
    self.walletAddressLb = walletAddressLb;
    [walletAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(18);
    }];
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"icon_copy"] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:copyBtn];
    [headerView addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(walletAddressLb.mas_right).offset(8);
        make.centerY.equalTo(walletAddressLb);
    }];
    UILabel *assetsLb = [PW_ViewTool labelText:LocalizedStr(@"text_assets") fontSize:18 textColor:[UIColor g_whiteTextColor]];
    [headerView addSubview:assetsLb];
    [assetsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(-20);
        make.left.offset(18);
    }];
    UIButton *showHiddenBtn = [[UIButton alloc] init];
    [showHiddenBtn setImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
    [showHiddenBtn setImage:[UIImage imageNamed:@"icon_hidden"] forState:UIControlStateSelected];
    [showHiddenBtn addTarget:self action:@selector(showHiddenAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:showHiddenBtn];
    self.showHiddenBtn = showHiddenBtn;
    [showHiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(assetsLb.mas_right).offset(10);
        make.centerY.equalTo(assetsLb);
    }];
    UILabel *totalAssetsLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:22 textColor:[UIColor g_grayTextColor]];
    [headerView addSubview:totalAssetsLb];
    self.totalAssetsLb = totalAssetsLb;
    [totalAssetsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-38);
        make.left.offset(18);
    }];
    UIButton *transferBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_transfer") fontSize:14 titleColor:[UIColor whiteColor] imageName:@"icon_transfer" target:self action:@selector(transferAction)];
    [headerView addSubview:transferBtn];
    UIButton *collectionBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_collection") fontSize:14 titleColor:[UIColor whiteColor] imageName:@"icon_collection" target:self action:@selector(collectionAction)];
    [headerView addSubview:collectionBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(collectionBtn.mas_top).offset(-15);
        make.right.offset(-18);
    }];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-18);
        make.centerY.equalTo(totalAssetsLb);
    }];
}
- (void)createCurrencyHeader {
    UIView *headerView = [[UIView alloc] init];
    [self.contentView addSubview:headerView];
    self.currencyHeaderView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(32);
    }];
    [headerView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
    }];
    UIButton *menuBtn = [PW_ViewTool buttonImageName:@"icon_menu_light" target:self action:@selector(menuAction)];
    [headerView addSubview:menuBtn];
    self.menuBtn = menuBtn;
    UIButton *searchBtn = [PW_ViewTool buttonImageName:@"icon_search" target:self action:@selector(searchAction)];
    [headerView addSubview:searchBtn];
    self.searchBtn = searchBtn;
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.offset(0);
    }];
    UIButton *hiddenSmallBtn = [PW_ViewTool buttonImageName:@"icon_switch_off" selectedImage:@"icon_switch_on" target:self action:@selector(hiddenSmallAction:)];
    [headerView addSubview:hiddenSmallBtn];
    self.hiddenSmallBtn = hiddenSmallBtn;
    [hiddenSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchBtn.mas_left).offset(-12);
        make.centerY.offset(0);
    }];
    [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hiddenSmallBtn.mas_left).offset(-12);
        make.centerY.offset(0);
    }];
}
- (void)createBackupTip {
    UIView *backupTipView = [[UIView alloc] init];
    backupTipView.layer.cornerRadius = 12;
    backupTipView.backgroundColor = [UIColor g_warnBgColor];
    backupTipView.hidden = YES;
    [self.view addSubview:backupTipView];
    self.backupTipView = backupTipView;
    [backupTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(-20);
    }];
    UILabel *tipLb = [PW_ViewTool labelText:LocalizedStr(@"text_backupTip") fontSize:14 textColor:[UIColor g_textColor]];
    tipLb.textAlignment = NSTextAlignmentCenter;
    [backupTipView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.offset(18);
        make.bottom.offset(-15);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_danger"] forState:UIControlStateNormal];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [sender.superview removeFromSuperview];
    }];
    [backupTipView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8);
        make.right.offset(-8);
    }];
}
#pragma mark - Getter
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_WalletCell class] forCellReuseIdentifier:@"PW_WalletCell"];
        [_tableView registerClass:[PW_WalletNFTCell class] forCellReuseIdentifier:@"PW_WalletNFTCell"];
        _tableView.rowHeight = 75;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, SafeBottomInset, 0);
//        _tableView.tableFooterView = self.addCurrencyView;
    }
    return _tableView;
}
//- (UIView *)addCurrencyView {
//    if (!_addCurrencyView) {
//        _addCurrencyView = [[UIView alloc] init];
//        _addCurrencyView.frame = CGRectMake(0, 0, 0, 54);
//        UIButton *addCurrencyBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addCurrency") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addCurrencyAction)];
//        addCurrencyBtn.frame = CGRectMake(20, 10, SCREEN_WIDTH-72, 44);
//        [addCurrencyBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
//        [_addCurrencyView addSubview:addCurrencyBtn];
//        [addCurrencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(10);
//            make.left.offset(36);
//            make.right.offset(-36);
//            make.height.offset(44);
//        }];
//    }
//    return _addCurrencyView;
//}
- (NSMutableArray<PW_TokenModel *> *)coinList {
    if (!_coinList) {
        _coinList = [NSMutableArray array];
    }
    return _coinList;
}
- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        NSArray *titles = @[LocalizedStr(@"text_assets"),@"NFT"];
        _segmentedControl = [PW_ViewTool segmentedControlWithTitles:titles];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(menuChangeAction) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
