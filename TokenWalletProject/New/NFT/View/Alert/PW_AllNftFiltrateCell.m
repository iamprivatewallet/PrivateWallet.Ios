//
//  PW_AllNftFiltrateCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AllNftFiltrateCell.h"
#import "PW_AllNftFiltrateItemCell.h"

@interface PW_AllNftFiltrateCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_AllNftFiltrateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.collectionView];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(30);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.left.right.bottom.offset(0);
    }];
}
- (void)setModel:(PW_AllNftFiltrateGroupModel *)model {
    _model = model;
    self.titleLb.text = model.title;
    [self.collectionView reloadData];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_AllNftFiltrateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_AllNftFiltrateItemCell.class) forIndexPath:indexPath];
    cell.itemWidth = self.flowLayout.itemSize.width;
    cell.model = self.model.items[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickBlock) {
        self.clickBlock(self.model, self.model.items[indexPath.item]);
    }
}
#pragma mark - lazy
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 15;
        _flowLayout.minimumLineSpacing = 15;
        NSInteger column = 3;
        CGFloat itemW = (PW_SCREEN_WIDTH-24*2-(column-1)*_flowLayout.minimumInteritemSpacing)/column;
        _flowLayout.itemSize = CGSizeMake(itemW, 40);
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 24, 30, 24);
    }
    return _flowLayout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.clipsToBounds = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:PW_AllNftFiltrateItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PW_AllNftFiltrateItemCell.class)];
    }
    return _collectionView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _titleLb;
}

@end
