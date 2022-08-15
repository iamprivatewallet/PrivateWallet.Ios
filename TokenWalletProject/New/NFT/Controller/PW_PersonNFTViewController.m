//
//  PW_PersonNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PersonNFTViewController.h"
#import "PW_SeriesNFTItemCell.h"
#import "PW_FollowSeriesNFTItemCell.h"
#import "PW_PersonNFTHeaderView.h"
#import "PW_SeriesNFTToolView.h"
#import "PW_AllNftFiltrateViewController.h"
#import "PW_MoreAlertViewController.h"
#import "PW_SearchSeriesNFTViewController.h"
#import "PW_SetDataViewController.h"
#import "PW_ShareAppTool.h"
#import "PW_NFTDetailViewController.h"

static NSInteger MarketMenuIndex = 0;
static NSInteger CollectMenuIndex = 1;
static NSInteger FollowMenuIndex = 2;

@interface PW_PersonNFTViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) PW_PersonNFTHeaderView *headerView;
@property (nonatomic, strong) PW_SeriesNFTToolView *toolView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, assign) NSInteger typesettingIndex;

@property (nonatomic, strong) PW_NFTProfileModel *model;
@property (nonatomic, strong) NSMutableArray<PW_NFTTokenModel *> *marketArr;
@property (nonatomic, assign) NSInteger marketPageNumber;
@property (nonatomic, strong) NSMutableArray<PW_NFTTokenModel *> *collectArr;
@property (nonatomic, assign) NSInteger collectPageNumber;
@property (nonatomic, strong) NSMutableArray<PW_NFTCollectionModel *> *followArr;
@property (nonatomic, assign) NSInteger followPageNumber;

@end

@implementation PW_PersonNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerHeight = 370;
    [self setNavNoLineTitle:@""];
    [self clearBackground];
    self.view.backgroundColor = [UIColor blackColor];
    [self makeViews];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.collectionView resetMJFooterBottom];
    [self requestPersonalData];
    [self requestNFTDataWithIndex:MarketMenuIndex];
    [self requestNFTDataWithIndex:CollectMenuIndex];
}
- (void)searchAction {
    PW_SearchSeriesNFTViewController *vc = [[PW_SearchSeriesNFTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)moreAction {
    PW_MoreAlertModel *shareModel = [PW_MoreAlertModel modelIconName:@"icon_sheet_share" title:LocalizedStr(@"text_share") didClick:^(PW_MoreAlertModel * _Nonnull model) {
        [PW_ShareAppTool showShareApp];
    }];
    BOOL isFollow = NO;
    PW_MoreAlertModel *followModel = [PW_MoreAlertModel modelIconName:isFollow?@"icon_sheet_favorite_full":@"icon_sheet_favorite" title:LocalizedStr(@"text_follow") didClick:^(PW_MoreAlertModel * _Nonnull model) {
        
    }];
    PW_MoreAlertModel *setupModel = [PW_MoreAlertModel modelIconName:@"icon_sheet_setup" title:LocalizedStr(@"text_setup") didClick:^(PW_MoreAlertModel * _Nonnull model) {
        PW_SetDataViewController *vc = [[PW_SetDataViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    PW_MoreAlertViewController *vc = [[PW_MoreAlertViewController alloc] init];
    vc.dataArr = @[shareModel,followModel,setupModel];
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)filtrateAction {
    PW_AllNftFiltrateViewController *vc = [[PW_AllNftFiltrateViewController alloc] init];
    vc.filtrateArr = self.filtrateArr;
    vc.sureBlock = ^(NSArray<PW_AllNftFiltrateGroupModel *> * _Nonnull filtrateArr) {
        self.filtrateArr = filtrateArr;
        [self headerRefresh];
    };
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)refreshSegment {
    if (self.segmentIndex==FollowMenuIndex) {
        self.flowLayout.itemSize = CGSizeMake(PW_SCREEN_WIDTH-34*2, 55);
    }else{
        [self refreshTypesetting];
    }
    [self.collectionView reloadData];
}
- (void)refreshTypesetting {
    if (self.segmentIndex==FollowMenuIndex) {
        return;
    }
    CGSize size = CGSizeMake(0, 0);
    if (self.typesettingIndex==0) {
        size.width = (PW_SCREEN_WIDTH-34*2-self.flowLayout.minimumInteritemSpacing)/2;
        size.height = 190;
    }else{
        size.width = PW_SCREEN_WIDTH-34*2;
        size.height = 205;
    }
    self.flowLayout.itemSize = size;
}
#pragma mark - api
- (void)requestPersonalData {
    NSString *address = User_manager.currentUser.chooseWallet_address;
    [self showLoading];
    [self pw_requestNFTApi:NFTWalletInfoURL params:@{@"address":address} completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        self.model = [PW_NFTProfileModel mj_objectWithKeyValues:data];
        self.headerView.model = self.model;
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
    }];
}
- (void)headerRefresh {
    [self requestNFTDataWithIndex:self.segmentIndex isRefresh:YES];
}
- (void)footerRefresh {
    [self requestNFTDataWithIndex:self.segmentIndex];
}
- (void)requestNFTDataWithIndex:(NSInteger)index {
    [self requestNFTDataWithIndex:index isRefresh:NO];
}
- (void)requestNFTDataWithIndex:(NSInteger)index isRefresh:(BOOL)isRefresh {
    User *user = User_manager.currentUser;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"chainId"] = user.current_chainId;
    NSInteger pageNumber = 0;
    if (index==MarketMenuIndex) {
        if (isRefresh) {
            self.marketPageNumber = 0;
            [self.marketArr removeAllObjects];
            [self.collectionView reloadData];
            self.noDataView.hidden = self.marketArr.count>0;
        }
        pageNumber = self.marketPageNumber;
    }else if(index==CollectMenuIndex) {
        if (isRefresh) {
            self.collectPageNumber = 0;
            [self.collectArr removeAllObjects];
            [self.collectionView reloadData];
            self.noDataView.hidden = self.collectArr.count>0;
        }
        pageNumber = self.collectPageNumber;
        params[@"address"] = user.chooseWallet_address;
    }
    params[@"pageNumber"] = @(pageNumber).stringValue;
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
            if (index==MarketMenuIndex) {
                self.marketPageNumber++;
                [self.marketArr addObjectsFromArray:array];
                self.noDataView.hidden = self.marketArr.count>0;
            }else if(index==CollectMenuIndex) {
                self.collectPageNumber++;
                [self.collectArr addObjectsFromArray:array];
                self.noDataView.hidden = self.collectArr.count>0;
            }
        }
        if (pageNumber>=totalPages.integerValue) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.collectionView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.segmentIndex==MarketMenuIndex) {
        return self.marketArr.count;
    }
    if (self.segmentIndex==CollectMenuIndex) {
        return self.collectArr.count;
    }
    return self.followArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentIndex==FollowMenuIndex) {
        PW_FollowSeriesNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_FollowSeriesNFTItemCell.class) forIndexPath:indexPath];
        cell.model = self.followArr[indexPath.item];
        return cell;
    }
    PW_SeriesNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_SeriesNFTItemCell.class) forIndexPath:indexPath];
    if (self.segmentIndex==MarketMenuIndex) {
        cell.model = self.marketArr[indexPath.item];
    }else if (self.segmentIndex==CollectMenuIndex) {
        cell.model = self.collectArr[indexPath.item];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentIndex==MarketMenuIndex) {
        PW_NFTTokenModel *model = self.marketArr[indexPath.item];
        PW_NFTDetailViewController *vc = [[PW_NFTDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.segmentIndex==CollectMenuIndex) {
        PW_NFTTokenModel *model = self.collectArr[indexPath.item];
        PW_NFTDetailViewController *vc = [[PW_NFTDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hiddenHeight = 64;
    CGFloat alpha = (self.headerHeight+scrollView.contentOffset.y)/hiddenHeight;
    alpha = MIN(1,MAX(0,alpha));
    self.navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.gradientView.alpha = 1-alpha;
}
#pragma mark - view
- (void)makeViews {
    [self.navBar insertSubview:self.gradientView atIndex:0];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self makeSearchView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(PW_StatusHeight);
        make.left.right.bottom.offset(0);
    }];
    self.headerContentView = [[UIView alloc] init];
    self.headerContentView.backgroundColor = [UIColor g_bgColor];
    [self.collectionView addSubview:self.headerContentView];
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.equalTo(self.collectionView);
        make.top.offset(-self.headerHeight).priorityMedium();
    }];
    [self.headerContentView addSubview:self.headerView];
    [self.headerContentView addSubview:self.toolView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(self.toolView.mas_top).offset(-30);
        make.height.mas_equalTo(300);
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(35);
        make.top.greaterThanOrEqualTo(self.navBar.mas_bottom).offset(5).priorityHigh();
        make.bottom.offset(-5);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [searchView addTapTarget:self action:@selector(searchAction)];
    [self.navContentView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(55);
        make.right.offset(-72);
        make.height.offset(40);
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
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_searchNFTID") fontSize:16 textColor:[UIColor g_placeholderWhiteColor]];
    [searchView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
    UIButton *moreBtn = [PW_ViewTool buttonImageName:@"icon_more" target:self action:@selector(moreAction)];
    moreBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [moreBtn setCornerRadius:16];
    [self.navContentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.centerY.offset(0);
        make.right.offset(-20);
    }];
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 20, 0);
        _collectionView.contentOffset = CGPointZero;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:PW_SeriesNFTItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PW_SeriesNFTItemCell.class)];
        [_collectionView registerClass:PW_FollowSeriesNFTItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PW_FollowSeriesNFTItemCell.class)];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.sectionInset = UIEdgeInsetsMake(20, 34, 0, 34);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        CGFloat width = (PW_SCREEN_WIDTH-34*2-self.flowLayout.minimumInteritemSpacing)/2;
        _flowLayout.itemSize = CGSizeMake(width, 190);
    }
    return _flowLayout;
}
- (UIView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[UIView alloc] init];
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(PW_SCREEN_WIDTH, PW_NavStatusHeight) gradientColors:@[[UIColor g_hex:@"#0C0C0C"],[UIColor clearColor]] gradientType:PW_GradientTopToBottom];
        UIImageView *bgIv = [[UIImageView alloc] initWithImage:image];
        [_gradientView addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(20);
        }];
    }
    return _gradientView;
}
- (PW_PersonNFTHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PW_PersonNFTHeaderView alloc] init];
    }
    return _headerView;
}
- (PW_SeriesNFTToolView *)toolView {
    if (!_toolView) {
        _toolView = [[PW_SeriesNFTToolView alloc] init];
        __weak typeof(self) weakSelf = self;
        _toolView.segmentIndexBlock = ^(NSInteger index) {
            weakSelf.segmentIndex = index;
            [weakSelf refreshSegment];
        };
        _toolView.typesettingBlock = ^(NSInteger index) {
            weakSelf.typesettingIndex = index;
            [weakSelf refreshTypesetting];
        };
        _toolView.filtrateBlock = ^{
            [weakSelf filtrateAction];
        };
    }
    return _toolView;
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
- (NSMutableArray<PW_NFTTokenModel *> *)marketArr {
    if (!_marketArr) {
        _marketArr = [[NSMutableArray alloc] init];
    }
    return _marketArr;
}
- (NSMutableArray<PW_NFTTokenModel *> *)collectArr {
    if (!_collectArr) {
        _collectArr = [[NSMutableArray alloc] init];
    }
    return _collectArr;
}
- (NSMutableArray<PW_NFTCollectionModel *> *)followArr {
    if (!_followArr) {
        _followArr = [[NSMutableArray alloc] init];
    }
    return _followArr;
}

@end
