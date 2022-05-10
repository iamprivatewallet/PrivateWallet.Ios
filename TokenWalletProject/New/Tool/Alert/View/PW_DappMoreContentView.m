//
//  PW_DappMoreContentView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappMoreContentView.h"
#import "PW_DappMoreItemCell.h"

@interface PW_DappMoreContentView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PW_DappMoreContentView

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
- (void)setDataArr:(NSArray<PW_DappMoreModel *> *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_DappMoreItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PW_DappMoreItemCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickBlock) {
        self.clickBlock(self.dataArr[indexPath.item]);
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 26, 0, 26);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        NSInteger column = 5;
        CGFloat itemW = (SCREEN_WIDTH-52)/column;
        layout.itemSize = CGSizeMake(itemW, 90);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_DappMoreItemCell class] forCellWithReuseIdentifier:@"PW_DappMoreItemCell"];
    }
    return _collectionView;
}

@end
