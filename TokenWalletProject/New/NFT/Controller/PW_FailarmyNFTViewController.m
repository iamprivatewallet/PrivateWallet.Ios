//
//  PW_FailarmyNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_FailarmyNFTViewController.h"
#import "PW_AllNftFiltrateViewController.h"
#import "PW_RecommendNFTCell.h"
#import "PW_NFTChainTypeView.h"
#import "PW_FailarmyListNFTViewController.h"

@interface PW_FailarmyNFTViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *chainNameLb;
@property (nonatomic, weak) UIView *searchView;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) PW_NFTChainTypeModel *chainTypeModel;
@property (nonatomic, copy) NSArray<PW_NFTChainTypeModel *> *chainTypeArr;

@property (nonatomic, strong) NSMutableArray<PW_NFTCollectionModel *> *dataArr;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation PW_FailarmyNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_NFTFailarmy")];
    [self makeViews];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.tableView resetMJFooterBottom];
    [self requestData];
}
- (void)chainAction {
    PW_NFTChainTypeView *view = [[PW_NFTChainTypeView alloc] init];
    view.dataArr = self.chainTypeArr;
    __weak typeof(self) weakSelf = self;
    view.clickBlock = ^(PW_NFTChainTypeModel * _Nonnull model) {
        weakSelf.chainTypeModel = model;
        weakSelf.chainNameLb.text = model.title;
        [weakSelf requestData];
    };
    [view showInView:self.view];
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
    params[@"chainId"] = self.chainTypeModel.chainId;
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
    [self makeChainView];
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
- (void)makeChainView {
    UIView *chainView = [[UIView alloc] init];
    chainView.backgroundColor = [UIColor g_hex:@"#FFFFFF" alpha:0.2];
    [chainView setCornerRadius:13];
    [chainView addTapTarget:self action:@selector(chainAction)];
    [self.view addSubview:chainView];
    [self.navContentView addSubview:chainView];
    [chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.offset(0);
        make.height.mas_equalTo(26);
    }];
    self.chainNameLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_chainName") fontSize:13 textColor:[UIColor whiteColor]];
    [chainView addSubview:self.chainNameLb];
    [self.chainNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_triangle_down"]];
    [chainView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.centerY.offset(0);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(10);
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
    PW_FailarmyListNFTViewController *vc = [[PW_FailarmyListNFTViewController alloc] init];
    vc.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 186;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _tableView.contentOffset = CGPointMake(0, -10);
        [_tableView registerClass:PW_RecommendNFTCell.class forCellReuseIdentifier:NSStringFromClass(PW_RecommendNFTCell.class)];
    }
    return _tableView;
}
- (PW_NFTChainTypeModel *)chainTypeModel {
    if (!_chainTypeModel) {
        _chainTypeModel = self.chainTypeArr.firstObject;
    }
    return _chainTypeModel;
}
- (NSArray<PW_NFTChainTypeModel *> *)chainTypeArr {
    if (!_chainTypeArr) {
        PW_NFTChainTypeModel *allModel = [PW_NFTChainTypeModel modelWithTitle:LocalizedStr(@"text_all") imageName:@"icon_type_all" chainId:nil];
        PW_NFTChainTypeModel *ethModel = [PW_NFTChainTypeModel modelWithTitle:@"Ethereum" imageName:@"icon_type_1" chainId:@"1"];
        PW_NFTChainTypeModel *bscModel = [PW_NFTChainTypeModel modelWithTitle:@"BSC" imageName:@"icon_type_56" chainId:@"56"];
        _chainTypeArr = @[allModel,ethModel,bscModel];
    }
    return _chainTypeArr;
}
- (NSMutableArray<PW_NFTCollectionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
