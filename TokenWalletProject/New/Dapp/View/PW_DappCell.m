//
//  PW_DappCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappCell.h"
#import "PW_DappItemCell.h"

@interface PW_DappCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PW_DappCell

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
- (void)setDataArr:(NSArray<PW_DappModel *> *)dataArr {
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
+ (CGFloat)getHeightWithItemCount:(NSInteger)count {
    if (count>0) {
        NSInteger column = 4;
        NSInteger row = ((NSInteger)count/column)+(count%column>0?1:0);
        return row*85+(row-1)*10;
    }
    return 1;
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_DappItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PW_DappItemCell" forIndexPath:indexPath];
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
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        NSInteger column = 4;
        CGFloat itemW = (SCREEN_WIDTH-32-(column-1)*layout.minimumInteritemSpacing)/column;
        layout.itemSize = CGSizeMake(itemW, 85);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_DappItemCell class] forCellWithReuseIdentifier:@"PW_DappItemCell"];
    }
    return _collectionView;
}

@end
