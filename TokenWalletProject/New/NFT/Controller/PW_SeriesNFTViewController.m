//
//  PW_SeriesNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SeriesNFTViewController.h"
#import "PW_SeriesNFTItemCell.h"
#import "PW_FollowSeriesNFTItemCell.h"
#import "PW_SeriesNFTHeaderView.h"
#import "PW_SeriesNFTToolView.h"
#import "PW_AllNftFiltrateViewController.h"
#import "PW_MoreAlertViewController.h"
#import "PW_SearchSeriesNFTViewController.h"

static NSInteger FollowMenuIndex = 2;

@interface PW_SeriesNFTViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) PW_SeriesNFTHeaderView *headerView;
@property (nonatomic, strong) PW_SeriesNFTToolView *toolView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, assign) NSInteger typesettingIndex;

@end

@implementation PW_SeriesNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@""];
    [self clearBackground];
    self.view.backgroundColor = [UIColor blackColor];
    [self makeViews];
    [self.view bringSubviewToFront:self.naviBar];
    [self refreshHeaderHeight];
}
- (void)searchAction {
    PW_SearchSeriesNFTViewController *vc = [[PW_SearchSeriesNFTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)moreAction {
    PW_MoreAlertModel *shareModel = [PW_MoreAlertModel modelIconName:@"icon_sheet_share" title:LocalizedStr(@"text_share") didClick:^(PW_MoreAlertModel * _Nonnull model) {
        
    }];
    BOOL isFollow = NO;
    PW_MoreAlertModel *followModel = [PW_MoreAlertModel modelIconName:isFollow?@"icon_sheet_favorite_full":@"icon_sheet_favorite" title:LocalizedStr(@"text_follow") didClick:^(PW_MoreAlertModel * _Nonnull model) {
        
    }];
    PW_MoreAlertModel *setupModel = [PW_MoreAlertModel modelIconName:@"icon_sheet_setup" title:LocalizedStr(@"text_setup") didClick:^(PW_MoreAlertModel * _Nonnull model) {
        
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
    };
    [self presentViewController:vc animated:YES completion:nil];
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
- (void)refreshHeaderHeight {
    CGPoint offset = self.collectionView.contentOffset;
    CGFloat oldHeaderHeight = self.headerHeight;
    [self.headerContentView layoutIfNeeded];
    self.headerHeight = self.headerContentView.size.height;
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top = self.headerHeight;
    self.collectionView.contentInset = insets;
    offset.y -= self.headerHeight-oldHeaderHeight;
    if (-offset.y>self.headerHeight) {
        offset.y = -self.headerHeight;
    }
    self.collectionView.contentOffset = offset;
    [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.equalTo(self.collectionView);
        make.top.offset(-self.headerHeight).priorityMedium();
    }];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentIndex==FollowMenuIndex) {
        PW_FollowSeriesNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_FollowSeriesNFTItemCell.class) forIndexPath:indexPath];
        
        return cell;
    }
    PW_SeriesNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_SeriesNFTItemCell.class) forIndexPath:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hiddenHeight = 64;
    CGFloat alpha = (self.headerHeight+scrollView.contentOffset.y)/hiddenHeight;
    alpha = MIN(1,MAX(0,alpha));
    self.naviBar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.gradientView.alpha = 1-alpha;
}
#pragma mark - view
- (void)makeViews {
    [self.naviBar insertSubview:self.gradientView atIndex:0];
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
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(35);
        make.top.greaterThanOrEqualTo(self.naviBar.mas_bottom).offset(5).priorityHigh();
        make.bottom.offset(-5);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [searchView addTapTarget:self action:@selector(searchAction)];
    [self.naviBar addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBtn);
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
    [self.naviBar addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.centerY.equalTo(searchView);
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
- (PW_SeriesNFTHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[PW_SeriesNFTHeaderView alloc] init];
        __weak typeof(self) weakSelf = self;
        _headerView.heightBlock = ^{
            [weakSelf refreshHeaderHeight];
        };
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
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_time") items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_latest") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_oldest") value:@""]
            ]],
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_price") items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_highToLow") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_lowToHigh") value:@""]
            ]],
            [PW_AllNftFiltrateGroupModel modelTitle:LocalizedStr(@"text_state") items:@[
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_onOffer") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_onBidding") value:@""],
                [PW_AllNftFiltrateItemModel modelTitle:LocalizedStr(@"text_unsold") value:@""]
            ]]
        ];
    }
    return _filtrateArr;
}

@end
