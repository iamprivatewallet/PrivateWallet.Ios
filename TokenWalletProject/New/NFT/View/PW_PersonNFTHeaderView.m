//
//  PW_PersonNFTHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PersonNFTHeaderView.h"

@interface PW_PersonNFTHeaderView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIButton *copyBtn;

@end

@implementation PW_PersonNFTHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)copyAction {
    
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
        make.height.mas_equalTo(100);
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
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(PW_SCREEN_WIDTH-30, 100) gradientColors:@[[UIColor g_hex:@"#888787"],[UIColor g_hex:@"#402B2B"]] gradientType:PW_GradientLeftTopToRightBottom];
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

@end
