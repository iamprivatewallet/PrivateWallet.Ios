//
//  PW_NFTHotspotCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTHotspotCell.h"

@interface PW_NFTHotspotCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;

@end

@implementation PW_NFTHotspotCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.effectView];
    [self.bodyView addSubview:self.logoIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(3);
        make.right.bottom.offset(-3);
    }];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.iconIv);
        make.height.mas_equalTo(35);
    }];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.effectView).offset(0);
        make.left.equalTo(self.effectView).offset(15);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(10);
        make.centerY.equalTo(self.effectView).offset(0);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGSize size = layoutAttributes.size;
    size.height = 145;
    layoutAttributes.size = size;
    return layoutAttributes;
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 6) radius:8];
        _bodyView.layer.cornerRadius = 5;
    }
    return _bodyView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_big"]];
    }
    return _iconIv;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0.8;
    }
    return _effectView;
}
- (UIImageView *)logoIv {
    if (!_logoIv) {
        _logoIv = [[UIImageView alloc] init];
        [_logoIv setCornerRadius:10];
    }
    return _logoIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor whiteColor]];
    }
    return _nameLb;
}

@end
