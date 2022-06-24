//
//  PW_DappChainBrowserCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappChainBrowserCell.h"
#import "PW_DappChainBrowserItemCell.h"

@interface PW_DappChainBrowserCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PW_DappChainBrowserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return self;
}
- (void)setDataArr:(NSArray<PW_DappChainBrowserModel *> *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
+ (CGSize)getItemSize {
    NSInteger column = 2;
    CGFloat width = (SCREEN_WIDTH-72-(column-1)*26)/column;
    return CGSizeMake(width, width*173.0/473.0);
}
+ (CGFloat)getHeightWithItemCount:(NSInteger)count {
    if (count>0) {
        NSInteger column = 2;
        NSInteger row = ((NSInteger)count/column)+(count%column>0?1:0);
        return row*[PW_DappChainBrowserCell getItemSize].height+(row-1)*5;
    }
    return 1;
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_DappChainBrowserItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PW_DappChainBrowserItemCell" forIndexPath:indexPath];
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
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 36, 0, 36);
        layout.minimumInteritemSpacing = 26;
        layout.minimumLineSpacing = 5;
        layout.itemSize = [PW_DappChainBrowserCell getItemSize];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_DappChainBrowserItemCell class] forCellWithReuseIdentifier:@"PW_DappChainBrowserItemCell"];
    }
    return _collectionView;
}

@end
