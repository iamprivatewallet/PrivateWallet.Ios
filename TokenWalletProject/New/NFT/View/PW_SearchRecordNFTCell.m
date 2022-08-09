//
//  PW_SearchRecordNFTCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchRecordNFTCell.h"
#import "PW_SearchRecordNFTItemCell.h"

@interface PW_SearchRecordNFTCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PW_SearchRecordNFTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.height.mas_equalTo(0);
    }];
}
- (void)setDataArr:(NSArray<PW_NFTSearchDBModel *> *)dataArr {
    _dataArr = dataArr;
    [self refreshData];
}
- (void)refreshData {
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    if (self.heightBlock) {
        self.heightBlock(height+10);
    }
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_SearchRecordNFTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PW_SearchRecordNFTItemCell.class) forIndexPath:indexPath];
    cell.title = self.dataArr[indexPath.item].text;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didClick) {
        self.didClick(self.dataArr[indexPath.item]);
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        PW_SearchRecordNFTFlowLayout *layout = [[PW_SearchRecordNFTFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.estimatedItemSize = CGSizeMake(70, 40);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(5, 26, 5, 26);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:PW_SearchRecordNFTItemCell.class forCellWithReuseIdentifier:NSStringFromClass(PW_SearchRecordNFTItemCell.class)];
    }
    return _collectionView;
}

@end


@interface PW_SearchRecordNFTFlowLayout ()

@property (nonatomic, assign) CGRect lastFrame;//上一个item的布局
@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation PW_SearchRecordNFTFlowLayout

//重写其布局方法
- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    //获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
        }
        [layoutInfoArr addObject:[subArr copy]];
    }
    
    self.attributesArray = [layoutInfoArr copy];
}
//指出了与指定区域有交接的UICollectionViewLayoutAttributes对象放到一个数组中，然后返回
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributesArr = [NSMutableArray array];
    
    [self.attributesArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectIntersectsRect(obj.frame, rect)) { //如果item在rect内
                [layoutAttributesArr addObject:obj];
            }
        }];
    }];
    return layoutAttributesArr;
}
//计算每一个item的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //indexPath对应的系统为我们计算的布局
    UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    //创建一个我们期望的布局
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemX = self.sectionInset.left;//默认X值
    CGFloat itemY = oldAttributes.frame.origin.y;//Y值直接用系统算的
    CGSize itemSize = oldAttributes.size; //大小代理直接返回的
    
    //同一行
    BOOL line = oldAttributes.frame.origin.y == self.lastFrame.origin.y;
    
    //无需换行&&indexpath.row != 0调整X值，(indexPath.row = 0)时self.lastFrame还未赋值
    if (oldAttributes.frame.origin.x != itemX && indexPath.row != 0 && line) {
        itemX = self.lastFrame.origin.x + self.lastFrame.size.width + self.minimumLineSpacing;
    }
    
    attributes.frame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);
    
    //更新上一个item的位置
    self.lastFrame = CGRectMake(itemX, itemY, itemSize.width, itemSize.height);
    
    return  attributes;
}

@end
