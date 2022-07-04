//
//  PW_SearchDappCurrencyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchDappCurrencyViewController.h"
#import "PW_SearchRecommendCell.h"
#import "PW_SearchDappCell.h"
#import "PW_SearchCurrencyCell.h"
#import "PW_SearchHeaderView.h"
#import "PW_SearchDeleteHeaderView.h"
#import "PW_Web3ViewController.h"

@interface PW_SearchDappCurrencyViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray<PW_DappModel *> *recommandDappList;
@property (nonatomic, strong) NSMutableArray<PW_DappModel *> *dappList;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *currencyList;

@property (nonatomic, assign) BOOL isSearch;

@end

@implementation PW_SearchDappCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBgPurple];
    [self makeViews];
    [self requestDappData];
    self.searchTF.text = self.searchStr;
}
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusHeight+5);
        make.left.offset(18);
        make.right.offset(-55);
        make.height.offset(46);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_bg"]];
    [searchView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *searchIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_white"]];
    [searchView addSubview:searchIv];
    [searchIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    UITextField *searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:16] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchDappCurrency")];
    [searchTF pw_setPlaceholder:LocalizedStr(@"text_searchDappCurrency") color:[UIColor g_placeholderWhiteColor]];
    searchTF.delegate = self;
    searchTF.borderStyle = UITextBorderStyleNone;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.enablesReturnKeyAutomatically = YES;
    [searchView addSubview:searchTF];
    self.searchTF = searchTF;
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(searchView).offset(0);
        make.width.height.mas_equalTo(25);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.bottom.offset(0);
    }];
}
- (void)requestDappData {
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSDictionary *paramsDict = @{
        @"chainId":chainId,
        @"isTop":@"1"
    };
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletDappListURL params:paramsDict completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        self.recommandDappList = [PW_DappModel mj_objectArrayWithKeyValuesArray:data];
        [self reloadTableSection:0];
        if (self.isSearch) {
            [self refreshDappDataWithValue:self.searchStr];
        }
    } errBlock:^(NSString *msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)requestCurrencyWithValue:(NSString *)value {
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSDictionary *paramsDict = @{
        @"tokenChain":chainId,
        @"tokenContract":value,
        @"isTop":@"1"
    };
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenIconURL params:paramsDict completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        self.currencyList = [PW_TokenModel mj_objectArrayWithKeyValuesArray:data];
        User *user = User_manager.currentUser;
        for (PW_TokenModel *model in self.currencyList) {
            PW_TokenModel *exitModel = [[PW_TokenManager shared] isExist:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
            model.isExist = exitModel!=nil;
        }
        [self reloadTableSection:1];
    } errBlock:^(NSString *msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)refreshDappDataWithValue:(NSString *)value {
    [self.dappList removeAllObjects];
    for (PW_DappModel *model in self.recommandDappList) {
        if([model.appName.lowercaseString containsString:value.lowercaseString]){
            [self.dappList addObject:model];
        }
    }
    if(self.dappList.count==0){
        PW_DappModel *model = [[PW_DappModel alloc] init];
        model.appName = value;
        model.appUrl = value;
        [self.dappList addObject:model];
    }
    [self reloadTableSection:0];
}
- (void)reloadTableSection:(NSInteger)section {
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)searchWithValue:(NSString *)value {
    self.isSearch = YES;
    [self refreshDappDataWithValue:[value trim]];
    [self requestCurrencyWithValue:[value trim]];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchWithValue:textField.text];
    [textField endEditing:YES];
    return [[textField.text trim] isNoEmpty];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0){
        if (self.isSearch){
            return self.dappList.count;
        }
        return 1;
    }
    if (self.isSearch){
        return self.currencyList.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        if (self.isSearch){
            PW_SearchDappCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SearchDappCell"];
            cell.model = self.dappList[indexPath.row];
            return cell;
        }
        PW_SearchRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SearchRecommendCell"];
        cell.dappArr = self.recommandDappList;
        __weak typeof(self) weakSelf = self;
        cell.dappBlock = ^(PW_DappModel * _Nonnull model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [PW_TipTool showDappDisclaimerUrlStr:model.appUrl sureBlock:^{
                PW_Web3ViewController *webVc = [[PW_Web3ViewController alloc] init];
                webVc.model = model;
                [strongSelf.navigationController pushViewController:webVc animated:YES];
            }];
        };
        return cell;
    }
    PW_SearchCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SearchCurrencyCell"];
    if (self.isSearch) {
        cell.model = self.currencyList[indexPath.row];
    }else{
        
    }
    __weak typeof(self) weakSelf = self;
    cell.addBlock = ^(PW_TokenModel * _Nonnull model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        User *user = User_manager.currentUser;
        if(model.isExist){
            model.isExist = NO;
            [[PW_TokenManager shared] deleteCoinWalletAddress:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        model.sortIndex = [[PW_TokenManager shared] getMaxIndex]+1;
        model.walletType = user.chooseWallet_type;
        model.walletAddress = user.chooseWallet_address;
        model.createTime = @([NSDate new].timeIntervalSince1970).stringValue;
        model.isExist = YES;
        [[PW_TokenManager shared] saveCoin:model];
        [strongSelf showSuccess:LocalizedStr(@"text_addSuccess")];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        if (self.isSearch){
            return 40;
        }
        return 44;
    }
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0){
        PW_SearchHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchHeaderView"];
        if (self.isSearch){
            headerView.title = @"DAPP";
            if (self.dappList.count==0) {
                return nil;
            }
        }else{
            headerView.title = LocalizedStr(@"text_hot");
            headerView.showHot = YES;
        }
        return headerView;
    }
    PW_SearchDeleteHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchDeleteHeaderView"];
    headerView.title = self.isSearch?LocalizedStr(@"text_currency"):LocalizedStr(@"text_searchRecord");
    headerView.hideDelete = self.isSearch;
    headerView.deleteBlock = ^{
        [PW_AlertTool showSystemAlertTitle:LocalizedStr(@"text_prompt") desc:LocalizedStr(@"text_clearAllRecords") actionTitle:LocalizedStr(@"text_confirm") actionStyle:UIAlertActionStyleDestructive handler:^{
            
        }];
    };
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0){
        if (self.isSearch&&self.dappList.count==0) {
            return 1;
        }
    }
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        if (self.isSearch){
            PW_DappModel *model = self.dappList[indexPath.item];
            [PW_TipTool showDappDisclaimerUrlStr:model.appUrl sureBlock:^{
                PW_Web3ViewController *webVc = [[PW_Web3ViewController alloc] init];
                webVc.model = model;
                [self.navigationController pushViewController:webVc animated:YES];
            }];
        }
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[PW_SearchRecommendCell class] forCellReuseIdentifier:@"PW_SearchRecommendCell"];
        [_tableView registerClass:[PW_SearchDappCell class] forCellReuseIdentifier:@"PW_SearchDappCell"];
        [_tableView registerClass:[PW_SearchCurrencyCell class] forCellReuseIdentifier:@"PW_SearchCurrencyCell"];
        [_tableView registerClass:[PW_SearchHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_SearchHeaderView"];
        [_tableView registerClass:[PW_SearchDeleteHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_SearchDeleteHeaderView"];
    }
    return _tableView;
}
- (NSMutableArray<PW_DappModel *> *)recommandDappList {
    if (!_recommandDappList) {
        _recommandDappList = [NSMutableArray array];
    }
    return _recommandDappList;
}
- (NSMutableArray<PW_DappModel *> *)dappList {
    if (!_dappList) {
        _dappList = [NSMutableArray array];
    }
    return _dappList;
}
- (NSMutableArray<PW_TokenModel *> *)currencyList {
    if (!_currencyList) {
        _currencyList = [NSMutableArray array];
    }
    return _currencyList;
}

@end
