//
//  PW_NFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTViewController.h"
#import "PW_SearchNFTViewController.h"
#import "PW_filtrateNFTView.h"
#import "PW_NFTHeaderView.h"
#import "PW_NFTSectionTitleView.h"
#import "PW_NFTHotspotCell.h"
#import "PW_NFTCardCell.h"
#import "PW_NFTClassifyViewController.h"
#import "PW_AllNFTViewController.h"
#import "PW_RecommendNFTViewController.h"
#import "PW_FailarmyNFTViewController.h"
#import "PW_RankListNFTViewController.h"
#import "PW_SeriesNFTViewController.h"
#import "PW_PersonNFTViewController.h"
#import "PW_NFTDetailViewController.h"
#import "PW_NFTMarketModel.h"
#import "PW_WebViewController.h"

@interface PW_NFTViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PW_filtrateNFTView *filtrateView;
@property (nonatomic, strong) PW_NFTMarketModel *model;

@end

@implementation PW_NFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@"" rightImg:@"icon_scan_white" rightAction:@selector(personalAction)];
    [self setupNavBgPurple];
    [self makeViews];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)personalAction {
    PW_PersonNFTViewController *vc = [[PW_PersonNFTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchAction {
    PW_SearchNFTViewController *searchVc = [[PW_SearchNFTViewController alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}
- (void)requestData {
    User *user = User_manager.currentUser;
    [self pw_requestNFTApi:NFTSearchMarketURL params:@{@"chainId":user.current_chainId} completeBlock:^(id  _Nonnull data) {
        [self.collectionView.mj_header endRefreshing];
        self.model = [PW_NFTMarketModel mj_objectWithKeyValues:data];
        [self.collectionView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self.collectionView.mj_header endRefreshing];
    }];
}
- (void)makeViews {
    UIButton *searchBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_searchNFTContract") fontSize:12 titleColor:[UIColor g_whiteTextColor] imageName:@"icon_search_white" target:self action:@selector(searchAction)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search_bg"] forState:UIControlStateNormal];
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.naviBar addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-60);
        make.height.offset(35);
        make.bottom.offset(-5);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBtn.mas_bottom).offset(16);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.filtrateView];
    [contentView addSubview:self.collectionView];
    [self.filtrateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.mas_equalTo(35);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filtrateView.mas_bottom).offset(10);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==1) {
        return self.model.collections.count;
    }else if(section==2) {
        return self.model.assets.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        PW_NFTHotspotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_NFTHotspotCell.class) forIndexPath:indexPath];
        cell.model = self.model.collections[indexPath.item];
        return cell;
    }
    __weak typeof(self) weakSelf = self;
    PW_NFTCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_NFTCardCell.class) forIndexPath:indexPath];
    cell.model = self.model.assets[indexPath.item];
    cell.seriesBlock = ^(PW_NFTTokenModel * _Nonnull model) {
        PW_SeriesNFTViewController *vc = [[PW_SeriesNFTViewController alloc] init];
        vc.slug = model.slug;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGSizeMake(0, 115);
    }
    return CGSizeMake(0, 45);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section==0) {
            PW_NFTHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(PW_NFTHeaderView.class) forIndexPath:indexPath];
            view.dataArr = self.model.banners;
            __weak typeof(self) weakSelf = self;
            view.clickBlock = ^(PW_NFTBannerModel * _Nonnull model) {
                if ([model.clickUrl isNoEmpty]) {
                    PW_WebViewController *vc = [[PW_WebViewController alloc] init];
                    vc.titleStr = model.title;
                    vc.urlStr = model.clickUrl;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            return view;
        }
        PW_NFTSectionTitleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(PW_NFTSectionTitleView.class) forIndexPath:indexPath];
        if (indexPath.section==1) {
            view.title = LocalizedStr(@"text_hotFailarmy");
        }else if(indexPath.section==2) {
            view.title = LocalizedStr(@"text_fashionNFT");
        }
        return view;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==1) {
        PW_SeriesNFTViewController *vc = [[PW_SeriesNFTViewController alloc] init];
        vc.slug = self.model.collections[indexPath.item].slug;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==2) {
        PW_NFTDetailViewController *vc = [[PW_NFTDetailViewController alloc] init];
        vc.model = self.model.assets[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 34, 0, 34);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH-34*2, 145);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.contentInset = UIEdgeInsetsMake(5, 0, 20, 0);
        _collectionView.contentOffset = CGPointZero;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_NFTHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(PW_NFTHeaderView.class)];
        [_collectionView registerClass:[PW_NFTSectionTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(PW_NFTSectionTitleView.class)];
        [_collectionView registerClass:[PW_NFTHotspotCell class] forCellWithReuseIdentifier:NSStringFromClass(PW_NFTHotspotCell.class)];
        [_collectionView registerClass:[PW_NFTCardCell class] forCellWithReuseIdentifier:NSStringFromClass(PW_NFTCardCell.class)];
    }
    return _collectionView;
}
- (PW_filtrateNFTView *)filtrateView {
    if (!_filtrateView) {
        _filtrateView = [[PW_filtrateNFTView alloc] init];
        __weak typeof(self) weakSelf = self;
        _filtrateView.dataArr = @[
            [PW_filtrateNFTModel modelImageName:@"icon_nft_new" title:LocalizedStr(@"text_newNFT") clickBlock:^{
                PW_AllNFTViewController *vc = [PW_AllNFTViewController new];
                vc.type = PW_AllNFTNew;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }],
            [PW_filtrateNFTModel modelImageName:@"icon_nft_recommend" title:LocalizedStr(@"text_recommend") clickBlock:^{
                PW_RecommendNFTViewController *vc = [PW_RecommendNFTViewController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }],
            [PW_filtrateNFTModel modelImageName:@"icon_nft_failarmy" title:LocalizedStr(@"text_NFTFailarmy") clickBlock:^{
                PW_FailarmyNFTViewController *vc = [PW_FailarmyNFTViewController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }],
            [PW_filtrateNFTModel modelImageName:@"icon_nft_rank" title:LocalizedStr(@"text_rankList") clickBlock:^{
                PW_RankListNFTViewController *vc = [PW_RankListNFTViewController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }]
        ];
        _filtrateView.menuBlock = ^{
            PW_NFTClassifyViewController *vc = [PW_NFTClassifyViewController new];
            [weakSelf.tabBarController presentViewController:vc animated:YES completion:nil];
        };
    }
    return _filtrateView;
}

@end
