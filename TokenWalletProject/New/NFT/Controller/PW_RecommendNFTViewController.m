//
//  PW_RecommendNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_RecommendNFTViewController.h"
#import "PW_RecommendNFTCell.h"
#import "PW_SeriesNFTViewController.h"

@interface PW_RecommendNFTViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, weak) UIView *searchView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) NSMutableArray<PW_NFTCollectionModel *> *dataArr;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation PW_RecommendNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_recommend")];
    [self makeViews];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.tableView resetMJFooterBottom];
    [self requestData];
}
- (void)requestData {
    self.pageNumber = 0;
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
    self.noDataView.hidden = self.dataArr.count>0;
    [self footerRefresh];
}
- (void)footerRefresh {
    [self.searchTF resignFirstResponder];
    NSString *searchStr = self.searchTF.text.trim;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"chainId"] = User_manager.currentUser.current_chainId;
    params[@"search"] = searchStr;
    params[@"pageNumber"] = @(self.pageNumber).stringValue;
    params[@"categorySlug"] = @"top";
    [self showLoading];
    [self pw_requestNFTApi:NFTCollectionPageURL params:params completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        NSNumber *totalPages = data[@"totalPages"];
        NSArray *array = [PW_NFTCollectionModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
        if (array&&array.count>0) {
            self.pageNumber++;
        }
        if (self.pageNumber>=totalPages.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:array];
        [self.tableView reloadData];
        self.noDataView.hidden = self.dataArr.count>0;
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)makeViews {
    [self makeSearchView];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(16);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.right.bottom.offset(0);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(44);
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
    self.searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:16] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchNFTContract")];
    [self.searchTF pw_setPlaceholder:LocalizedStr(@"text_searchNFTContract") color:[UIColor g_placeholderWhiteColor]];
    self.searchTF.delegate = self;
    self.searchTF.borderStyle = UITextBorderStyleNone;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.enablesReturnKeyAutomatically = YES;
    [searchView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
}
#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self requestData];
    return YES;
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_RecommendNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_RecommendNFTCell.class)];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_SeriesNFTViewController *vc = [[PW_SeriesNFTViewController alloc] init];
    vc.slug = self.dataArr[indexPath.row].slug;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 186;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 20, 0);
        _tableView.contentOffset = CGPointMake(0, -5);
        [_tableView registerClass:PW_RecommendNFTCell.class forCellReuseIdentifier:NSStringFromClass(PW_RecommendNFTCell.class)];
    }
    return _tableView;
}
- (NSMutableArray<PW_NFTCollectionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
