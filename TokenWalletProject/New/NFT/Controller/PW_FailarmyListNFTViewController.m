//
//  PW_FailarmyListNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_FailarmyListNFTViewController.h"
#import "PW_NFTCardCell.h"
#import "PW_AllNftFiltrateViewController.h"
#import "PW_SeriesNFTViewController.h"
#import "PW_NFTDetailViewController.h"

@interface PW_FailarmyListNFTViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *chainNameLb;
@property (nonatomic, weak) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *filtrateArr;

@property (nonatomic, strong) NSMutableArray<PW_NFTTokenModel *> *dataArr;
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation PW_FailarmyListNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:self.model.name];
    [self makeViews];
}
- (void)filtrateAction {
    PW_AllNftFiltrateViewController *vc = [[PW_AllNftFiltrateViewController alloc] init];
    vc.filtrateArr = self.filtrateArr;
    vc.sureBlock = ^(NSArray<PW_AllNftFiltrateGroupModel *> * _Nonnull filtrateArr) {
        self.filtrateArr = filtrateArr;
        [self requestData];
    };
    [self presentViewController:vc animated:NO completion:nil];
}
- (void)requestData {
    self.pageNumber = 0;
    [self.dataArr removeAllObjects];
    [self.collectionView reloadData];
    self.noDataView.hidden = self.dataArr.count>0;
    [self footerRefresh];
}
- (void)footerRefresh {
    [self.searchTF resignFirstResponder];
    NSString *searchStr = self.searchTF.text.trim;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"chainId"] = self.model.chainId;
    params[@"search"] = searchStr;
    params[@"pageNumber"] = @(self.pageNumber).stringValue;
    params[@"slug"] = self.model.slug;
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
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:array];
        [self.collectionView reloadData];
        self.noDataView.hidden = self.dataArr.count>0;
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
        [self.collectionView.mj_footer endRefreshing];
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
        [self.collectionView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
    }];
}
#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self requestData];
    return YES;
}
#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_NFTCardCell.class) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.seriesBlock = ^(PW_NFTTokenModel * _Nonnull model) {
        PW_SeriesNFTViewController *vc = [[PW_SeriesNFTViewController alloc] init];
        vc.slug = model.slug;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.collectBlock = ^(PW_NFTTokenModel * _Nonnull model) {
        [weakSelf nftFollowWithModel:model];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTDetailViewController *vc = [[PW_NFTDetailViewController alloc] init];
    vc.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - view
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
    [contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(26);
        make.left.right.bottom.offset(0);
    }];
}
- (void)makeSearchView {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(10);
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
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 34, 0, 34);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-34*2-layout.minimumInteritemSpacing)/2, 190);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 20, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_NFTCardCell class] forCellWithReuseIdentifier:NSStringFromClass(PW_NFTCardCell.class)];
    }
    return _collectionView;
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
- (NSMutableArray<PW_NFTTokenModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
