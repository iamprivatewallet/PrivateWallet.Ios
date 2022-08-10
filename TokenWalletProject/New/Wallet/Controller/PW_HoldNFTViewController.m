//
//  PW_HoldNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_HoldNFTViewController.h"
#import "PW_PersonNFTViewController.h"
#import "PW_SegmentedControl.h"
#import "PW_HoldNFTHeaderView.h"
#import "PW_HoldNFTItemCell.h"
#import "PW_SearchHoldNFTViewController.h"
#import "PW_NFTTokenDetailViewController.h"

@interface PW_HoldNFTViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) PW_HoldNFTHeaderView *headerView;
@property (nonatomic, strong) PW_SegmentedControl *segmentedControl;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, strong) NSMutableArray<PW_NFTTokenModel *> *dataArr;

@property (nonatomic, assign) NSInteger marketStatus;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation PW_HoldNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerHeight = 395;
    [self setNavNoLineTitle:@""];
    [self makeViews];
    self.headerView.model = self.model;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = self.headerHeight;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)searchAction {
    PW_SearchHoldNFTViewController *vc = [[PW_SearchHoldNFTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)menuAction {
    PW_PersonNFTViewController *vc = [[PW_PersonNFTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)headerRefresh {
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
    self.pageNumber = 0;
    [self requestData];
}
- (void)footerRefresh {
    [self requestData];
}
- (void)requestData {
    User *user = User_manager.currentUser;
    NSString *chainId = user.current_chainId;
    [self showLoading];
    [self pw_requestNFTApi:NFTAssetOwnerPageURL params:@{@"chainId":chainId,@"address":user.chooseWallet_address,@"slug":self.model.slug,@"marketStatus":@(self.segmentIndex),@"pageNumber":@(self.pageNumber)} completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        NSNumber *totalPages = data[@"totalPages"];
        NSArray *array = [PW_NFTTokenModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
        if (array&&array.count>0) {
            self.pageNumber++;
        }
        [self.collectionView.mj_header endRefreshing];
        if (self.pageNumber>=totalPages.integerValue) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:array];
        [self.collectionView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self dismissLoading];
        [self showError:msg];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_HoldNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_HoldNFTItemCell.class) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTTokenDetailViewController *vc = [[PW_NFTTokenDetailViewController alloc] init];
    vc.model = self.dataArr[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hiddenHeight = 64;
    CGFloat alpha = (self.headerHeight+scrollView.contentOffset.y)/hiddenHeight;
    alpha = MIN(1,MAX(0,alpha));
    self.navBar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.gradientView.alpha = 1-alpha;
}
- (void)makeViews {
    [self.navBar insertSubview:self.gradientView atIndex:0];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self makeSearchView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
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
    [self.headerContentView addSubview:self.segmentedControl];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.equalTo(self.segmentedControl.mas_top).offset(-25);
        make.height.mas_equalTo(330);
    }];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
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
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_searchNFTTokenID") fontSize:16 textColor:[UIColor g_placeholderWhiteColor]];
    [searchView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
    UIButton *menuBtn = [PW_ViewTool buttonImageName:@"icon_menu_bg" target:self action:@selector(menuAction)];
    [self.navContentView addSubview:menuBtn];
    [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView);
        make.right.offset(-8);
    }];
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);
        _collectionView.contentOffset = CGPointZero;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:PW_HoldNFTItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PW_HoldNFTItemCell.class)];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.sectionInset = UIEdgeInsetsMake(20, 34, 20+PW_SafeBottomInset, 34);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        CGFloat width = (PW_SCREEN_WIDTH-34*2-self.flowLayout.minimumInteritemSpacing)/2;
        _flowLayout.itemSize = CGSizeMake(width, 174);
    }
    return _flowLayout;
}
- (UIView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[UIView alloc] init];
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(PW_SCREEN_WIDTH, PW_NavStatusHeight) gradientColors:@[[UIColor g_hex:@"#0C0C0C"],[UIColor clearColor]] gradientType:PW_GradientTopToBottom];
        UIImageView *bgIv = [[UIImageView alloc] initWithImage:image];
        bgIv.alpha = 0.5;
        [_gradientView addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(55);
        }];
    }
    return _gradientView;
}
- (UIView *)headerContentView {
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
    }
    return _headerContentView;
}
- (PW_HoldNFTHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PW_HoldNFTHeaderView alloc] init];
    }
    return _headerView;
}
- (PW_SegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[PW_SegmentedControl alloc] init];
        _segmentedControl.dataArr = @[LocalizedStr(@"text_all"),LocalizedStr(@"text_putaway"),LocalizedStr(@"text_unshelve")];
        _segmentedControl.selectedIndex = self.segmentIndex;
        __weak typeof(self) weakSelf = self;
        _segmentedControl.didClick = ^(NSInteger index) {
            weakSelf.segmentIndex = index;
            [weakSelf headerRefresh];
        };
    }
    return _segmentedControl;
}
- (NSMutableArray<PW_NFTTokenModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
