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
    UIImageView *bgIv = [[UIImageView alloc] init];
    bgIv.image = [UIImage imageNamed:@"first_bg"];
    [self.view addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    UITextField *searchTF = [[UITextField alloc] init];
    UIImageView *searchIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    CGSize size = searchIv.bounds.size;
    searchIv.frame = CGRectMake(16, (35-size.height)*0.5, size.width, size.height);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftView addSubview:searchIv];
    searchTF.leftView = leftView;
    searchTF.delegate = self;
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.textColor = [UIColor g_textColor];
    searchTF.font = [UIFont systemFontOfSize:12];
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTF.borderStyle = UITextBorderStyleNone;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.enablesReturnKeyAutomatically = YES;
    searchTF.layer.cornerRadius = 17.5;
    searchTF.backgroundColor = [UIColor g_bgColor];
    [searchTF pw_setPlaceholder:LocalizedStr(@"text_searchCurrencyContract")];
    [self.view addSubview:searchTF];
    self.searchTF = searchTF;
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusHeight+5);
        make.left.offset(25);
        make.right.offset(-65);
        make.height.offset(35);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_dark"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.centerY.equalTo(searchTF);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchTF.mas_bottom).offset(10);
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
    [self requestApi:WalletTokenIconURL params:paramsDict completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        NSArray *array = [PW_TokenModel mj_objectArrayWithKeyValuesArray:data];
        User *user = User_manager.currentUser;
        for (PW_TokenModel *model in array) {
            PW_TokenModel *exitModel = [[PW_TokenManager shareManager] isExist:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
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
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
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
        __strong typeof(weakSelf) strongSelf = weakSelf;
        User *user = User_manager.currentUser;
        if(model.isExist){
            model.isExist = NO;
            [[PW_TokenManager shareManager] deleteCoinWalletAddress:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        model.sortIndex = [[PW_TokenManager shareManager] getMaxIndex]+1;
        model.walletType = user.chooseWallet_type;
        model.walletAddress = user.chooseWallet_address;
        model.createTime = @([NSDate new].timeIntervalSince1970).stringValue;
        model.isExist = YES;
        [[PW_TokenManager shareManager] saveCoin:model];
        [strongSelf showSuccess:LocalizedStr(@"text_addSuccess")];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCoinListNotification object:nil];
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        return 35;
    }
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0){
        if(self.isSearch){
            return nil;
        }
        PW_SearchHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchHeaderView"];
        headerView.title = LocalizedStr(@"text_recommendCurrency");
        return headerView;
    }
    PW_SearchDeleteHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchDeleteHeaderView"];
    headerView.title = self.isSearch?LocalizedStr(@"text_searchResult"):LocalizedStr(@"text_searchRecord");
    headerView.hideDelete = self.isSearch;
    headerView.deleteBlock = ^{
        
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
