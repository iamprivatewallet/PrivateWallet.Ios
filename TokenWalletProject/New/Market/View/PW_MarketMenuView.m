//
//  PW_MarketMenuView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketMenuView.h"
#import "PW_MarketMenuItemCell.h"

@interface PW_MarketMenuView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PW_MarketMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}
- (void)setDataArr:(NSArray<PW_MarketMenuModel *> *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_MarketMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PW_MarketMenuItemCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (PW_MarketMenuModel *model in self.dataArr) {
        model.selected = NO;
    }
    self.dataArr[indexPath.item].selected = YES;
    [collectionView reloadData];
    if (self.clickBlock) {
        self.clickBlock(indexPath.item, self.dataArr[indexPath.item]);
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.estimatedItemSize = CGSizeMake(38, 38);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_MarketMenuItemCell class] forCellWithReuseIdentifier:@"PW_MarketMenuItemCell"];
    }
    return _collectionView;
}

@end
