//
//  PW_DappBrowserCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappBrowserCell.h"
#import "PW_DappBrowserItemCell.h"

@interface PW_DappBrowserCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PW_DappBrowserCell

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
    if (dataArr==nil) {
        return;
    }
    if (dataArr.count>5) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:[dataArr subarrayWithRange:NSMakeRange(0, 4)]];
        PW_DappModel *moreModel = [[PW_DappModel alloc] init];
        moreModel.appName = LocalizedStr(@"text_more");
        moreModel.iconUrl = @"icon_dapp_more";
        moreModel.isMore = YES;
        [array addObject:moreModel];
        _dataArr = [array copy];
    }else{
        _dataArr = dataArr;
    }
    [self.collectionView reloadData];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_DappBrowserItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PW_DappBrowserItemCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickBlock) {
        self.clickBlock(self.dataArr[indexPath.item],self.dataArr);
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        layout.minimumInteritemSpacing = 10;
        NSInteger column = 5;
        CGFloat itemW = (SCREEN_WIDTH-60-(column-1)*layout.minimumInteritemSpacing)/column;
        layout.itemSize = CGSizeMake(itemW, itemW+30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor g_bgColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_DappBrowserItemCell class] forCellWithReuseIdentifier:@"PW_DappBrowserItemCell"];
    }
    return _collectionView;
}

@end
