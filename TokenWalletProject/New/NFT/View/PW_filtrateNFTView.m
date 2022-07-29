//
//  PW_filtrateNFTView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_filtrateNFTView.h"
#import "PW_filtrateNFTItemCell.h"

@interface PW_filtrateNFTView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *menuBtn;

@end

@implementation PW_filtrateNFTView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)menuAction {
    if (self.menuBlock) {
        self.menuBlock();
    }
}
- (void)setDataArr:(NSArray<PW_filtrateNFTModel *> *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
- (void)makeViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.menuBtn];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.right.equalTo(self.menuBtn.mas_left).offset(0);
    }];
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.width.equalTo(self.menuBtn.mas_height);
    }];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_filtrateNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_filtrateNFTItemCell.class) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_filtrateNFTModel *model = self.dataArr[indexPath.item];
    if (model.clickBlock) {
        model.clickBlock();
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.estimatedItemSize = CGSizeMake(80, 35);
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:PW_filtrateNFTItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PW_filtrateNFTItemCell.class)];
    }
    return _collectionView;
}
- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [PW_ViewTool buttonImageName:@"icon_classify" target:self action:@selector(menuAction)];
    }
    return _menuBtn;
}

@end
