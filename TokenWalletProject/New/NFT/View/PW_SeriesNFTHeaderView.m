//
//  PW_SeriesNFTHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SeriesNFTHeaderView.h"

@interface PW_SeriesNFTHeaderView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIButton *copyBtn;
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
@property (nonatomic, strong) UILabel *descLb;
@property (nonatomic, strong) UIButton *unfoldBtn;

@end

@implementation PW_SeriesNFTHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)copyAction {
    
}
- (void)unfoldAction {
    self.unfoldBtn.selected = !self.unfoldBtn.isSelected;
    if (self.unfoldBtn.isSelected) {
        self.unfoldBtn.transform = CGAffineTransformMakeRotation(M_PI);
        self.descLb.numberOfLines = 0;
    }else{
        self.unfoldBtn.transform = CGAffineTransformIdentity;
        self.descLb.numberOfLines = 3;
    }
    if (self.heightBlock) {
        self.heightBlock();
    }
}
- (void)makeViews {
    [self addSubview:self.iconIv];
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.logoIv];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.coinTypeIv];
    [self.contentView addSubview:self.addressLb];
    [self.contentView addSubview:self.copyBtn];
    [self.contentView addSubview:self.descLb];
    [self.contentView addSubview:self.unfoldBtn];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(282);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(-46);
        make.left.right.bottom.offset(0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(200);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
    }];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.top.offset(16);
        make.width.height.mas_equalTo(36);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(14);
        make.centerY.equalTo(self.logoIv);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    [self.coinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoIv.mas_bottom).offset(10);
        make.left.offset(32);
        make.width.height.mas_equalTo(10);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinTypeIv.mas_right).offset(5);
        make.centerY.equalTo(self.coinTypeIv);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLb.mas_right).offset(6);
        make.centerY.equalTo(self.coinTypeIv);
    }];
    UIStackView *goodsCountView = [[UIStackView alloc] initWithArrangedSubviews:@[self.goodsCountTipLb,self.goodsCountLb]];
    goodsCountView.distribution = UIStackViewDistributionEqualSpacing;
    [self.contentView addSubview:goodsCountView];
    UIStackView *holderCountView = [[UIStackView alloc] initWithArrangedSubviews:@[self.holderCountTipLb,self.holderCountLb]];
    holderCountView.distribution = UIStackViewDistributionEqualSpacing;
    [self.contentView addSubview:holderCountView];
    UIView *priceRightView = [[UIView alloc] init];
    [priceRightView addSubview:self.priceFloorCoinTypeIv];
    [priceRightView addSubview:self.priceFloorLb];
    UIStackView *priceFloorView = [[UIStackView alloc] initWithArrangedSubviews:@[self.priceFloorTipLb,priceRightView]];
    priceFloorView.distribution = UIStackViewDistributionEqualSpacing;
    [self.contentView addSubview:priceFloorView];
    UIView *volumeRightView = [[UIView alloc] init];
    [volumeRightView addSubview:self.volumeCoinTypeIv];
    [volumeRightView addSubview:self.volumeLb];
    UIStackView *volumeView = [[UIStackView alloc] initWithArrangedSubviews:@[self.volumeTipLb,volumeRightView]];
    volumeView.distribution = UIStackViewDistributionEqualSpacing;
    [self.contentView addSubview:volumeView];
    [goodsCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinTypeIv.mas_bottom).offset(18);
        make.left.offset(35);
        make.height.mas_equalTo(18);
    }];
    [holderCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsCountView);
        make.left.equalTo(goodsCountView.mas_right).offset(30);
        make.right.offset(-50);
        make.width.height.equalTo(goodsCountView);
    }];
    [priceFloorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsCountView.mas_bottom).offset(6);
        make.left.equalTo(goodsCountView);
        make.width.height.equalTo(goodsCountView);
    }];
    [volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderCountView);
        make.top.equalTo(priceFloorView);
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
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(145);
        make.left.offset(34);
        make.right.offset(-35);
        make.bottom.mas_lessThanOrEqualTo(-32);
    }];
    [self.unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.centerX.offset(0);
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
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(PW_SCREEN_WIDTH-30, 192) gradientColors:@[[UIColor g_hex:@"#888787"],[UIColor g_hex:@"#402B2B"]] gradientType:PW_GradientLeftTopToRightBottom];
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
- (UIImageView *)coinTypeIv {
    if (!_coinTypeIv) {
        _coinTypeIv = [[UIImageView alloc] init];
    }
    return _coinTypeIv;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor colorWithWhite:1 alpha:0.6]];
    }
    return _addressLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copy_new" target:self action:@selector(copyAction)];
    }
    return _copyBtn;
}
- (UILabel *)goodsCountTipLb {
    if (!_goodsCountTipLb) {
        _goodsCountTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_goodsCount") fontSize:12 textColor:[UIColor g_hex:@"#FFFFFF" alpha:0.7]];
        [_goodsCountTipLb setRequiredHorizontal];
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
        [_holderCountTipLb setRequiredHorizontal];
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
        [_priceFloorTipLb setRequiredHorizontal];
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
        [_volumeTipLb setRequiredHorizontal];
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
- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor colorWithWhite:1 alpha:0.6]];
        _descLb.numberOfLines = 3;
    }
    return _descLb;
}
- (UIButton *)unfoldBtn {
    if (!_unfoldBtn) {
        _unfoldBtn = [PW_ViewTool buttonImageName:@"icon_arrow_down" target:self action:@selector(unfoldAction)];
    }
    return _unfoldBtn;
}

@end
