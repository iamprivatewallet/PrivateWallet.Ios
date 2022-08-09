//
//  PW_SearchHoldNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchHoldNFTViewController.h"
#import "PW_HoldNFTItemCell.h"
#import "PW_SegmentedControl.h"
#import "PW_NFTTokenDetailViewController.h"

@interface PW_SearchHoldNFTViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PW_SegmentedControl *segmentedControl;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray<PW_NFTTokenModel *> *dataArr;

@property (nonatomic, assign) NSInteger marketStatus;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation PW_SearchHoldNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
    self.noDataView.imageName = @"icon_noData_NFT";
    self.noDataView.text = LocalizedStr(@"text_searchNoDataNFT");
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self forceRefreshData];
}
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)forceRefreshData {
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
    self.noDataView.hidden = self.dataArr.count>0;
    self.pageNumber = 0;
    [self requestData];
}
- (void)requestData {
    User *user = User_manager.currentUser;
    NSString *chainId = user.current_chainId;
    [self showLoading];
    [self pw_requestNFTApi:NFTAssetOwnerPageURL params:@{@"chainId":chainId,@"address":user.chooseWallet_address,@"slug":self.model.slug,@"search":self.searchTF.text,@"marketStatus":@(self.segmentIndex),@"pageNumber":@(self.pageNumber)} completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        NSNumber *totalPages = data[@"totalPages"];
        NSArray *array = [PW_NFTTokenModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
        if (array&&array.count>0) {
            self.pageNumber++;
        }
        if (self.pageNumber>=totalPages.integerValue) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:array];
        [self.collectionView reloadData];
        self.noDataView.hidden = self.dataArr.count>0;
    } errBlock:^(NSString * _Nonnull msg) {
        [self dismissLoading];
        [self showError:msg];
        [self.collectionView.mj_footer endRefreshing];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self forceRefreshData];
    return YES;
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
- (void)makeViews {
    [self makeSearchView];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(PW_NavStatusHeight+15);
        make.left.bottom.right.offset(0);
    }];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [self.contentView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(26);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(35);
    }];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(10);
        make.left.right.bottom.offset(0);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(PW_StatusHeight+2);
        make.left.offset(16);
        make.right.offset(-66);
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
    UITextField *searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:16] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchNFTTokenID")];
    [searchTF pw_setPlaceholder:LocalizedStr(@"text_searchNFTTokenID") color:[UIColor g_placeholderWhiteColor]];
    searchTF.delegate = self;
    searchTF.borderStyle = UITextBorderStyleNone;
    searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:searchTF];
    self.searchTF = searchTF;
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close_bg" target:self action:@selector(closeAction)];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView);
        make.right.offset(-8);
    }];
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
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
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 34, 20+PW_SafeBottomInset, 34);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        CGFloat width = (PW_SCREEN_WIDTH-34*2-self.flowLayout.minimumInteritemSpacing)/2;
        _flowLayout.itemSize = CGSizeMake(width, 174);
    }
    return _flowLayout;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
    }
    return _contentView;
}
- (PW_SegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[PW_SegmentedControl alloc] init];
        _segmentedControl.dataArr = @[LocalizedStr(@"text_all"),LocalizedStr(@"text_putaway"),LocalizedStr(@"text_unshelve")];
        _segmentedControl.selectedIndex = self.segmentIndex;
        __weak typeof(self) weakSelf = self;
        _segmentedControl.didClick = ^(NSInteger index) {
            weakSelf.segmentIndex = index;
            [weakSelf forceRefreshData];
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
