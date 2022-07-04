//
//  PW_SearchCurrencyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchCurrencyViewController.h"
#import "PW_SearchRecommendCell.h"
#import "PW_SearchCurrencyCell.h"
#import "PW_SearchHeaderView.h"
#import "PW_SearchDeleteHeaderView.h"

@interface PW_SearchCurrencyViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *recommandList;;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *currencyList;

@property (nonatomic, assign) BOOL isSearch;

@end

@implementation PW_SearchCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
    [self requestRecommendData];
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
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_bg_primary"]];
    [searchView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *searchIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_primary"]];
    [searchView addSubview:searchIv];
    [searchIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    UITextField *searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:16] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchCurrencyContract")];
    [searchTF pw_setPlaceholder:LocalizedStr(@"text_searchCurrencyContract") color:[UIColor g_placeholderWhiteColor]];
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
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_primary"] forState:UIControlStateNormal];
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
- (void)requestRecommendData {
    [self requestCurrencyWithValue:nil isRecommend:YES];
}
- (void)requestCurrencyWithValue:(nullable NSString *)value isRecommend:(BOOL)isRecommend {
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSDictionary *paramsDict = @{
        @"tokenChain":chainId,
        @"tokenContract":value,
        @"isTop":isRecommend?@"1":nil,
    };
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenIconURL params:paramsDict completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        NSArray *array = [PW_TokenModel mj_objectArrayWithKeyValuesArray:data];
        User *user = User_manager.currentUser;
        for (PW_TokenModel *model in array) {
            PW_TokenModel *exitModel = [[PW_TokenManager shared] isExist:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
            model.isExist = exitModel!=nil;
        }
        if (isRecommend) {
            [self.recommandList removeAllObjects];
            [self.recommandList addObjectsFromArray:array];
        }else{
            [self.currencyList removeAllObjects];
            [self.currencyList addObjectsFromArray:array];
        }
        [self.tableView reloadData];
    } errBlock:^(NSString *msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)addTokenWithModel:(PW_TokenModel *)model {
    User *user = User_manager.currentUser;
    if(model.isExist){
        model.isExist = NO;
        [[PW_TokenManager shared] deleteCoinWalletAddress:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    model.sortIndex = [[PW_TokenManager shared] getMaxIndex]+1;
    model.walletType = user.chooseWallet_type;
    model.walletAddress = user.chooseWallet_address;
    model.createTime = @([NSDate new].timeIntervalSince1970).stringValue;
    model.isExist = YES;
    [[PW_TokenManager shared] saveCoin:model];
    [self showSuccess:LocalizedStr(@"text_addSuccess")];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.isSearch = YES;
    [self requestCurrencyWithValue:[textField.text trim] isRecommend:NO];
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
            return 0;
        }
        return 1;
    }
    return self.currencyList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        if (self.isSearch){
            return nil;
        }
        PW_SearchRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SearchRecommendCell"];
        cell.tokenArr = self.recommandList;
        __weak typeof(self) weakSelf = self;
        cell.tokenBlock = ^(PW_TokenModel * _Nonnull model) {
//            [weakSelf addTokenWithModel:model];
        };
        return cell;
    }
    PW_SearchCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SearchCurrencyCell"];
    if(self.isSearch){
        cell.model = self.currencyList[indexPath.row];
    }else{
        cell.model = self.recommandList[indexPath.row];
    }
    __weak typeof(self) weakSelf = self;
    cell.addBlock = ^(PW_TokenModel * _Nonnull model) {
        [weakSelf addTokenWithModel:model];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        return 44;
    }
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0){
        if(self.isSearch){
            return nil;
        }
        PW_SearchHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchHeaderView"];
        headerView.title = LocalizedStr(@"text_hotCurrency");
        headerView.showHot = YES;
        return headerView;
    }
    PW_SearchDeleteHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchDeleteHeaderView"];
    headerView.title = self.isSearch?LocalizedStr(@"text_searchResult"):LocalizedStr(@"text_searchRecord");
    headerView.hideDelete = self.isSearch;
    headerView.deleteBlock = ^{
        [PW_AlertTool showSystemAlertTitle:LocalizedStr(@"text_prompt") desc:LocalizedStr(@"text_clearAllRecords") actionTitle:LocalizedStr(@"text_confirm") actionStyle:UIAlertActionStyleDestructive handler:^{
            
        }];
    };
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0){
        if(self.isSearch){
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
        [_tableView registerClass:[PW_SearchCurrencyCell class] forCellReuseIdentifier:@"PW_SearchCurrencyCell"];
        [_tableView registerClass:[PW_SearchHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_SearchHeaderView"];
        [_tableView registerClass:[PW_SearchDeleteHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_SearchDeleteHeaderView"];
    }
    return _tableView;
}
- (NSMutableArray<PW_TokenModel *> *)recommandList {
    if (!_recommandList) {
        _recommandList = [NSMutableArray array];
    }
    return _recommandList;
}
- (NSMutableArray<PW_TokenModel *> *)currencyList {
    if (!_currencyList) {
        _currencyList = [NSMutableArray array];
    }
    return _currencyList;
}

@end
