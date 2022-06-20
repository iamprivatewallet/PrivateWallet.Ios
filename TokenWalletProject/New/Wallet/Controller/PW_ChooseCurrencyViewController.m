//
//  PW_ChooseCurrencyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChooseCurrencyViewController.h"
#import "PW_SearchHeaderView.h"
#import "PW_ChooseCurrencyCell.h"

@interface PW_ChooseCurrencyViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *currencyList;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *searchList;

@property (nonatomic, assign) BOOL isSearch;

@end

@implementation PW_ChooseCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
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
    UITextField *searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchCurrencyContract")];
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
- (void)filterCurrencyWithValue:(NSString *)value {
    if(!self.isSearch){return;}
    [self.searchList removeAllObjects];
    for (PW_TokenModel *model in self.currencyList) {
        if ([model.tokenName.lowercaseString containsString:value.lowercaseString]||[model.tokenContract.lowercaseString containsString:value.lowercaseString]) {
            [self.searchList addObject:model];
        }
    }
    [self.tableView reloadData];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.isSearch = YES;
    [self filterCurrencyWithValue:[textField.text trim]];
    [textField endEditing:YES];
    return [[textField.text trim] isNoEmpty];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch){
        return self.searchList.count;
    }
    return self.currencyList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_ChooseCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_ChooseCurrencyCell"];
    if (self.isSearch){
        cell.model = self.searchList[indexPath.row];
    }else{
        cell.model = self.currencyList[indexPath.row];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_SearchHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PW_SearchHeaderView"];
    headerView.title = LocalizedStr(@"text_chooseCurrency");
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_TokenModel *model = nil;
    if (self.isSearch){
        model = self.searchList[indexPath.row];
    }else{
        model = self.currencyList[indexPath.row];
    }
    [self resetChooseState];
    model.isChoose = YES;
    [self.navigationController popViewControllerAnimated:YES];
    if (self.chooseBlock) {
        self.chooseBlock(model);
    }
}
- (void)resetChooseState {
    for (PW_TokenModel *obj in self.currencyList) {
        obj.isChoose = NO;
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 74;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[PW_ChooseCurrencyCell class] forCellReuseIdentifier:@"PW_ChooseCurrencyCell"];
        [_tableView registerClass:[PW_SearchHeaderView class] forHeaderFooterViewReuseIdentifier:@"PW_SearchHeaderView"];
    }
    return _tableView;
}
- (NSMutableArray<PW_TokenModel *> *)searchList {
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}
- (NSMutableArray<PW_TokenModel *> *)currencyList {
    if (!_currencyList) {
        _currencyList = [NSMutableArray arrayWithArray:[PW_GlobalData shared].coinList];
        if([self.selectedTokenContract isNoEmpty]){
            for (PW_TokenModel *model in _currencyList) {
                if ([self.selectedTokenContract.lowercaseString isEqualToString:model.tokenContract.lowercaseString]) {
                    model.isChoose = YES;
                }else{
                    model.isChoose = NO;
                }
            }
        }
    }
    return _currencyList;
}

@end
