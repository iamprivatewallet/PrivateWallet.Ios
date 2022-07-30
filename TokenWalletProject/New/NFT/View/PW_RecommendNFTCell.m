//
//  PW_RecommendNFTCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_RecommendNFTCell.h"

@interface PW_RecommendNFTCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *otherView;
@property (nonatomic, strong) UILabel *goodsCountTipLb;
@property (nonatomic, strong) UILabel *goodsCountLb;
@property (nonatomic, strong) UILabel *holderCountTipLb;
@property (nonatomic, strong) UILabel *holderCountLb;
@property (nonatomic, strong) UILabel *priceFloorTipLb;
@property (nonatomic, strong) UIImageView *priceFloorCoinTypeIv;
@property (nonatomic, strong) UILabel *priceFloorLb;
@property (nonatomic, strong) UILabel *volumeTipLb;
@property (nonatomic, strong) UIImageView *volumeCoinTypeIv;
@property (nonatomic, strong) UILabel *volumeLb;

@end

@implementation PW_RecommendNFTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.logoIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.effectView];
    [self.bodyView addSubview:self.otherView];
    UIStackView *goodsCountView = [[UIStackView alloc] initWithArrangedSubviews:@[self.goodsCountTipLb,self.goodsCountLb]];
    goodsCountView.distribution = UIStackViewDistributionEqualSpacing;
    [self.otherView addSubview:goodsCountView];
    UIStackView *holderCountView = [[UIStackView alloc] initWithArrangedSubviews:@[self.holderCountTipLb,self.holderCountLb]];
    holderCountView.distribution = UIStackViewDistributionEqualSpacing;
    [self.otherView addSubview:holderCountView];
    UIView *priceRightView = [[UIView alloc] init];
    [priceRightView addSubview:self.priceFloorCoinTypeIv];
    [priceRightView addSubview:self.priceFloorLb];
    UIStackView *priceFloorView = [[UIStackView alloc] initWithArrangedSubviews:@[self.priceFloorTipLb,priceRightView]];
    priceFloorView.distribution = UIStackViewDistributionEqualSpacing;
    [self.otherView addSubview:priceFloorView];
    UIView *volumeRightView = [[UIView alloc] init];
    [volumeRightView addSubview:self.volumeCoinTypeIv];
    [volumeRightView addSubview:self.volumeLb];
    UIStackView *volumeView = [[UIStackView alloc] initWithArrangedSubviews:@[self.volumeTipLb,volumeRightView]];
    volumeView.distribution = UIStackViewDistributionEqualSpacing;
    [self.otherView addSubview:volumeView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(34);
        make.right.offset(-34);
        make.top.offset(0);
        make.bottom.offset(-10);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(3);
        make.right.bottom.offset(-3);
    }];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.offset(0);
        make.top.offset(20);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIv.mas_bottom).offset(10);
        make.centerX.offset(0);
        make.left.mas_greaterThanOrEqualTo(10);
    }];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.iconIv);
        make.height.mas_equalTo(58);
    }];
    [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(23);
        make.right.offset(-23);
        make.top.equalTo(self.effectView).offset(4);
        make.bottom.equalTo(self.effectView.mas_bottom).offset(-4);
    }];
    [goodsCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.height.mas_equalTo(18);
    }];
    [holderCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsCountView);
        make.left.equalTo(goodsCountView.mas_right).offset(30);
        make.right.offset(0);
        make.width.height.equalTo(goodsCountView);
    }];
    [priceFloorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsCountView.mas_bottom);
        make.left.bottom.offset(0);
        make.width.height.equalTo(goodsCountView);
    }];
    [volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderCountView);
        make.top.equalTo(priceFloorView);
        make.right.offset(0);
        make.width.height.equalTo(goodsCountView);
    }];
    [self.priceFloorCoinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.left.centerY.offset(0);
    }];
    [self.priceFloorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceFloorCoinTypeIv.mas_right).offset(3);
        make.centerY.right.offset(0);
    }];
    [self.volumeCoinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.left.centerY.offset(0);
    }];
    [self.volumeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volumeCoinTypeIv.mas_right).offset(3);
        make.centerY.right.offset(0);
    }];
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
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
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
        _nameLb = [PW_ViewTool labelBoldText:@"--" fontSize:14 textColor:[UIColor whiteColor]];
        [_nameLb setShadowColor:[UIColor g_hex:@"#000000" alpha:0.8] offset:CGSizeMake(0, 4) radius:8];
        _nameLb.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLb;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.alpha = 0.8;
    }
    return _effectView;
}
- (UIView *)otherView {
    if (!_otherView) {
        _otherView = [[UIView alloc] init];
    }
    return _otherView;
}
- (UILabel *)goodsCountTipLb {
    if (!_goodsCountTipLb) {
        _goodsCountTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_goodsCount") fontSize:12 textColor:[UIColor g_hex:@"#FFFFFF" alpha:0.7]];
    }
    return _goodsCountTipLb;
}
- (UILabel *)goodsCountLb {
    if (!_goodsCountLb) {
        _goodsCountLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    }
    return _goodsCountLb;
}
- (UILabel *)holderCountTipLb {
    if (!_holderCountTipLb) {
        _holderCountTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_holderCount") fontSize:12 textColor:[UIColor g_hex:@"#FFFFFF" alpha:0.7]];
    }
    return _holderCountTipLb;
}
- (UILabel *)holderCountLb {
    if (!_holderCountLb) {
        _holderCountLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    }
    return _holderCountLb;
}
- (UILabel *)priceFloorTipLb {
    if (!_priceFloorTipLb) {
        _priceFloorTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_priceFloor") fontSize:12 textColor:[UIColor g_hex:@"#FFFFFF" alpha:0.7]];
    }
    return _priceFloorTipLb;
}
- (UIImageView *)priceFloorCoinTypeIv {
    if (!_priceFloorCoinTypeIv) {
        _priceFloorCoinTypeIv = [[UIImageView alloc] init];
    }
    return _priceFloorCoinTypeIv;
}
- (UILabel *)priceFloorLb {
    if (!_priceFloorLb) {
        _priceFloorLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    }
    return _priceFloorLb;
}
- (UILabel *)volumeTipLb {
    if (!_volumeTipLb) {
        _volumeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_volume") fontSize:12 textColor:[UIColor g_hex:@"#FFFFFF" alpha:0.7]];
    }
    return _volumeTipLb;
}
- (UIImageView *)volumeCoinTypeIv {
    if (!_volumeCoinTypeIv) {
        _volumeCoinTypeIv = [[UIImageView alloc] init];
    }
    return _volumeCoinTypeIv;
}
- (UILabel *)volumeLb {
    if (!_volumeLb) {
        _volumeLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor whiteColor]];
    }
    return _volumeLb;
}

@end
