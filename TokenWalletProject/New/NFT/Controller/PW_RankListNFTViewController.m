//
//  PW_RankListNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_RankListNFTViewController.h"
#import "PW_AllNftFiltrateViewController.h"
#import "PW_RankListNFTCell.h"
#import "PW_NFTChainTypeView.h"
#import "PW_SeriesNFTViewController.h"

@interface PW_RankListNFTViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *chainNameLb;
@property (nonatomic, weak) UIView *searchView;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr;
@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) NSMutableArray<PW_NFTTokenModel *> *dataArr;
@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) PW_NFTChainTypeModel *chainTypeModel;
@property (nonatomic, copy) NSArray<PW_NFTChainTypeModel *> *chainTypeArr;

@end

@implementation PW_RankListNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_rankList")];
    [self makeViews];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.tableView resetMJFooterBottom];
    [self requestData];
}
- (void)filtrateAction {
    PW_AllNftFiltrateViewController *vc = [[PW_AllNftFiltrateViewController alloc] init];
    vc.filtrateArr = self.filtrateArr;
    vc.sureBlock = ^(NSArray<PW_AllNftFiltrateGroupModel *> * _Nonnull filtrateArr) {
        self.filtrateArr = filtrateArr;
    };
    [self presentViewController:vc animated:NO completion:nil];
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
    params[@"categorySlug"] = @"rank";
    for (PW_AllNftFiltrateGroupModel *gModel in self.filtrateArr) {
        for (PW_AllNftFiltrateItemModel *model in gModel.items) {
            if (model.selected) {
                params[gModel.key] = model.value;
                break;
            }
        }
    }
    [self showLoading];
    [self pw_requestNFTApi:NFTAssetPageURL params:params completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        NSNumber *totalPages = data[@"totalPages"];
        NSArray *array = [PW_NFTTokenModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
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
- (void)nftFollowWithModel:(PW_NFTTokenModel *)model {
    User *user = User_manager.currentUser;
    [self showLoading];
    [self pw_requestNFTApi:NFTAssetFollowURL params:@{
        @"tokenId":model.tokenId,
        @"assetContract":model.assetContract,
        @"address":user.chooseWallet_address,
        @"status":model.isFollow?@"0":@"1",
    } completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        model.isFollow = !model.isFollow;
        if (model.isFollow) {
            model.follows++;
        }else{
            model.follows--;
        }
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
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
    [self.naviBar addSubview:chainView];
    [chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-16);
        make.centerY.equalTo(self.leftBtn).offset(0);
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
        make.top.equalTo(self.naviBar.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-80);
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
    UIButton *filtrateBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_filtrate") fontSize:16 titleColor:[UIColor g_primaryColor] imageName:nil target:self action:@selector(filtrateAction)];
    [self.view addSubview:filtrateBtn];
    [filtrateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25);
        make.centerY.equalTo(searchView);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_RankListNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_RankListNFTCell.class)];
    cell.model = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.seriesBlock = ^(PW_NFTTokenModel * _Nonnull model) {
        PW_SeriesNFTViewController *vc = [[PW_SeriesNFTViewController alloc] init];
        vc.slug = model.slug;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 118;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _tableView.contentOffset = CGPointMake(0, -10);
        [_tableView registerClass:PW_RankListNFTCell.class forCellReuseIdentifier:NSStringFromClass(PW_RankListNFTCell.class)];
    }
    return _tableView;
}
- (NSArray<PW_AllNftFiltrateGroupModel *> *)filtrateArr {
    if (!_filtrateArr) {
        _filtrateArr = @[
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_time") key:@"orderTime" items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_latest") value:@"1"],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_oldest") value:@"2"]
            ]],
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_price") key:@"orderPrice" items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_highToLow") value:@"1"],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_lowToHigh") value:@"2"]
            ]],
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_state") key:@"saleStatus" items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_onOffer") value:@"1"],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_onBidding") value:@"2"],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_unsold") value:@"3"]
            ]]
        ];
    }
    return _filtrateArr;
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
- (NSMutableArray<PW_NFTTokenModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
