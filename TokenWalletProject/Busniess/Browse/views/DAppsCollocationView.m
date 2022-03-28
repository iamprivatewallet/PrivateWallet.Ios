//
//  DAppsCollocationView.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsCollocationView.h"
#import "DAppsCollectionViewCell.h"
#import "DAppsTopItemsView.h"
#import "AllDAppsViewController.h"
#import "WebViewController.h"

@interface DAppsCollocationView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy) void(^itemClickBlock)(NSInteger index);
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *collectionList;
@end

@implementation DAppsCollocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
        [self makeDataReload];
    }
    return self;
}
- (void)makeDataReload{
    [self makeDataReloadWithIndex:self.currentIndex];
}
- (void)makeDataReloadWithIndex:(NSInteger)index{
    if (self.collectionList.count>0) {
        [self.collectionList removeAllObjects];
    }
    NSArray *list;
    if (index == 0) {
        list = [[DAppsManager sharedInstance] getDAppsCollectionArray];
    }else{
        list = [[VisitDAppsRecordManager sharedInstance] getDAppsVisitArray];
    }
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BrowseRecordsModel *model = [BrowseRecordsModel mj_objectWithKeyValues:obj];
        [self.collectionList addObject:model];
    }];
    [self.collectionView reloadData];
}

- (void)makeViews{
    self.backgroundColor = [UIColor whiteColor];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@60);
    }];
    
    DAppsTopItemsView *itemView = [[DAppsTopItemsView alloc] init];
    [itemView makeViewsWithArr:@[@"收藏",@"最近"]];
    itemView.backgroundColor = [UIColor whiteColor];
    [self addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
    __weak typeof(self) weakSelf = self;
    itemView.changeItemBlock = ^(NSInteger index) {
        weakSelf.currentIndex = index;
        [weakSelf makeDataReloadWithIndex:index];
    };
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(itemView.mas_bottom);
    }];
    
}
- (UICollectionViewFlowLayout *)layout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(ScreenWidth/4, 110);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}
- (void)changeItemWithBlock:(void(^)(NSInteger index))block{
    self.itemClickBlock = block;
}

- (void)allBtnAction{
    //全部
    AllDAppsViewController *vc = [[AllDAppsViewController alloc] init];
    if (self.currentIndex == 0) {
        vc.allType = kAllDAppsTypeCollection;
    }else{
        vc.allType = kAllDAppsTypeLately;
    }
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DAppsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAppsReuseCell" forIndexPath:indexPath];
    [cell fillData:self.collectionList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrowseRecordsModel *model = self.collectionList[indexPath.row];
    WebViewController *vc = [WebViewController loadWebViewWithData:model];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [ZZCustomView buttonInitWithView:self title:@"全部" titleColor:[UIColor im_textColor_nine] titleFont:GCSFontRegular(13) bgColor:nil];
        [_allBtn addTarget:self action:@selector(allBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_allBtn setImage:ImageNamed(@"arrow") forState:UIControlStateNormal];
        _allBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 35, 5, -10);
        _allBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 10);
    }
    return _allBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [self layout];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[DAppsCollectionViewCell class] forCellWithReuseIdentifier:@"DAppsReuseCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
- (NSMutableArray *)collectionList{
    if (!_collectionList) {
        _collectionList = [[NSMutableArray alloc] init];
    }
    return _collectionList;
}
@end
