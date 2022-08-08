//
//  PW_HoldNFTHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_HoldNFTHeaderView.h"

@interface PW_HoldNFTHeaderView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *amountsTipLb;
@property (nonatomic, strong) UILabel *amountsLb;
@property (nonatomic, strong) UILabel *onOfferTipLb;
@property (nonatomic, strong) UILabel *onOfferLb;

@end

@implementation PW_HoldNFTHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_NFTCollectionModel *)model {
    _model = model;
    [self.logoIv sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = model.slug;
    self.amountsLb.text = @(model.totalSupply).stringValue;
    self.onOfferLb.text = @(model.totalSales).stringValue;
}
- (void)makeViews {
    [self addSubview:self.iconIv];
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.logoIv];
    [self.contentView addSubview:self.nameLb];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(286);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(-20);
        make.left.right.bottom.offset(0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(242);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
        make.height.mas_equalTo(88);
    }];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.top.offset(10);
        make.width.height.mas_equalTo(36);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(14);
        make.centerY.equalTo(self.logoIv);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    UIView *amountsView = [[UIView alloc] init];
    [self.contentView addSubview:amountsView];
    [amountsView addSubview:self.amountsTipLb];
    [amountsView addSubview:self.amountsLb];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.12];
    [self.contentView addSubview:lineView];
    UIView *onOfferView = [[UIView alloc] init];
    [self.contentView addSubview:onOfferView];
    [onOfferView addSubview:self.onOfferTipLb];
    [onOfferView addSubview:self.onOfferLb];
    [amountsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32);
        make.bottom.offset(-10);
        make.height.mas_equalTo(20);
    }];
    [self.amountsTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    [self.amountsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.equalTo(amountsView);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(1);
    }];
    [onOfferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountsView.mas_right).offset(45);
        make.right.offset(-32);
        make.width.bottom.height.equalTo(amountsView);
    }];
    [self.onOfferTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    [self.onOfferLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight) size:self.bgView.bounds.size];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
        _iconIv.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconIv;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor g_bgColor];
    }
    return _bgView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setCornerRadius:21];
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(PW_SCREEN_WIDTH-30, 88) gradientColors:@[[UIColor g_hex:@"#29342D"],[UIColor g_hex:@"#1A4B41"]] gradientType:PW_GradientLeftTopToRightBottom];
        UIImageView *bgIv = [[UIImageView alloc] initWithImage:image];
        [_contentView addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _contentView;
}
- (UIImageView *)logoIv {
    if (!_logoIv) {
        _logoIv = [[UIImageView alloc] init];
        [_logoIv setCornerRadius:18];
    }
    return _logoIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:18 textColor:[UIColor whiteColor]];
    }
    return _nameLb;
}
- (UILabel *)amountsTipLb {
    if (!_amountsTipLb) {
        _amountsTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_amounts") fontSize:14 textColor:[UIColor whiteColor]];
    }
    return _amountsTipLb;
}
- (UILabel *)amountsLb {
    if (!_amountsLb) {
        _amountsLb = [PW_ViewTool labelBoldText:@"--" fontSize:14 textColor:[UIColor whiteColor]];
    }
    return _amountsLb;
}
- (UILabel *)onOfferTipLb {
    if (!_onOfferTipLb) {
        _onOfferTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_onOffer") fontSize:14 textColor:[UIColor whiteColor]];
    }
    return _onOfferTipLb;
}
- (UILabel *)onOfferLb {
    if (!_onOfferLb) {
        _onOfferLb = [PW_ViewTool labelBoldText:@"--" fontSize:14 textColor:[UIColor whiteColor]];
    }
    return _onOfferLb;
}

@end
