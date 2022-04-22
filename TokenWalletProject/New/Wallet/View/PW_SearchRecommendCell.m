//
//  PW_SearchRecommendCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchRecommendCell.h"

@interface PW_SearchRecommendCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isDapp;

@end

@implementation PW_SearchRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
- (void)setDappArr:(NSArray<PW_DappModel *> *)dappArr {
    _dappArr = dappArr;
    self.isDapp = YES;
    [self.collectionView reloadData];
}
- (void)setTokenArr:(NSArray<PW_TokenModel *> *)tokenArr {
    _tokenArr = tokenArr;
    self.isDapp = NO;
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isDapp) {
        return self.dappArr.count;
    }
    return self.tokenArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PW_SearchRecommendItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PW_SearchRecommendItemCell" forIndexPath:indexPath];
    if (self.isDapp) {
        PW_DappModel *model = self.dappArr[indexPath.item];
        [cell.iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
        cell.nameLb.text = model.appName;
    }else{
        PW_TokenModel *model = self.tokenArr[indexPath.item];
        [cell.iconIv sd_setImageWithURL:[NSURL URLWithString:model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
        cell.nameLb.text = model.tokenName;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDapp) {
        if(self.dappBlock) {
            self.dappBlock(self.dappArr[indexPath.item]);
        }
    }else{
        if(self.tokenBlock) {
            self.tokenBlock(self.tokenArr[indexPath.item]);
        }
    }
}
#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.estimatedItemSize = CGSizeMake(80, 35);
        layout.minimumInteritemSpacing = 8;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PW_SearchRecommendItemCell class] forCellWithReuseIdentifier:@"PW_SearchRecommendItemCell"];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 26, 0, 26);
    }
    return _collectionView;
}

@end

@implementation PW_SearchRecommendItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    self.contentView.backgroundColor = [UIColor g_bgColor];
    self.contentView.layer.cornerRadius = 17.5;
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.nameLb];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
        make.width.height.offset(20);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(8);
        make.centerY.offset(0);
    }];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGSize size = layoutAttributes.size;
    size.width = [self.nameLb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont pw_semiBoldFontOfSize:16]} context:nil].size.width+10+20+8+10+10;
    layoutAttributes.size = size;
    return layoutAttributes;
}

@end
