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
    return 45;
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
        _tableView.rowHeight = 72;
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
