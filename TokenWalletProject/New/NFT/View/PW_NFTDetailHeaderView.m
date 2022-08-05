//
//  PW_NFTDetailHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/4.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailHeaderView.h"

@interface PW_NFTDetailHeaderView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *ownerTipLb;
@property (nonatomic, strong) UILabel *ownerLb;
@property (nonatomic, strong) UILabel *sourceTipLb;
@property (nonatomic, strong) UILabel *sourceLb;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UILabel *uPriceLb;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation PW_NFTDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)collectAction {
    
}
- (void)shareAction {
    
}
- (void)makeViews {
    [self addSubview:self.iconIv];
    [self addSubview:self.contentView];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-PW_NavStatusHeight);
        make.left.right.offset(0);
        make.height.mas_equalTo(310);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(-40);
        make.left.right.bottom.offset(0);
        make.height.mas_greaterThanOrEqualTo(160);
    }];
    [self.contentView addSubview:self.ownerTipLb];
    [self.contentView addSubview:self.ownerLb];
    [self.contentView addSubview:self.sourceTipLb];
    [self.contentView addSubview:self.sourceLb];
    [self.contentView addSubview:self.titleLb];
    UIView *rightView = [[UIView alloc] init];
    [self.contentView addSubview:rightView];
    [rightView addSubview:self.coinTypeIv];
    [rightView addSubview:self.priceLb];
    [rightView addSubview:self.uPriceLb];
    [self.contentView addSubview:self.logoIv];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.collectBtn];
    [self.contentView addSubview:self.shareBtn];
    [self.contentView addSubview:self.lineView];
    [self.ownerTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.left.offset(30);
    }];
    [self.ownerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ownerTipLb.mas_right).offset(8);
        make.centerY.equalTo(self.ownerTipLb);
    }];
    [self.sourceTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sourceLb.mas_left).offset(-8);
        make.centerY.equalTo(self.ownerTipLb);
    }];
    [self.sourceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(self.ownerTipLb);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightView);
        make.left.offset(30);
        make.right.mas_lessThanOrEqualTo(rightView.mas_left).offset(-30);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.right.offset(-30);
        make.height.mas_equalTo(38);
    }];
    [self.coinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.centerY.equalTo(self.priceLb);
        make.right.equalTo(self.priceLb.mas_left).offset(-3);
        make.left.mas_greaterThanOrEqualTo(0);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
    }];
    [self.uPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.left.mas_greaterThanOrEqualTo(0);
    }];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.equalTo(rightView.mas_bottom).offset(18);
        make.width.height.mas_equalTo(28);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(10);
        make.centerY.equalTo(self.logoIv);
        make.right.mas_lessThanOrEqualTo(self.collectBtn.mas_left).offset(-10);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-12);
        make.centerY.equalTo(self.logoIv);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(self.logoIv);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight) size:self.contentView.bounds.size];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
        _iconIv.backgroundColor = [UIColor g_bgCardColor];
    }
    return _iconIv;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
    }
    return _contentView;
}
- (UILabel *)ownerTipLb {
    if (!_ownerTipLb) {
        _ownerTipLb = [PW_ViewTool labelSemiboldText:@"Owner by" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _ownerTipLb;
}
- (UILabel *)ownerLb {
    if (!_ownerLb) {
        _ownerLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_primaryNFTColor]];
    }
    return _ownerLb;
}
- (UILabel *)sourceTipLb {
    if (!_sourceTipLb) {
        _sourceTipLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"%@:",LocalizedStr(@"text_source")) fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _sourceTipLb;
}
- (UILabel *)sourceLb {
    if (!_sourceLb) {
        _sourceLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_primaryNFTColor]];
    }
    return _sourceLb;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelBoldText:@"--" fontSize:17 textColor:[UIColor g_textColor]];
    }
    return _titleLb;
}
- (UIImageView *)coinTypeIv {
    if (!_coinTypeIv) {
        _coinTypeIv = [[UIImageView alloc] init];
    }
    return _coinTypeIv;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelBoldText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
        [_priceLb setRequiredHorizontal];
    }
    return _priceLb;
}
- (UILabel *)uPriceLb {
    if (!_uPriceLb) {
        _uPriceLb = [PW_ViewTool labelText:@"--" fontSize:12 textColor:[UIColor g_textColor]];
        [_uPriceLb setRequiredHorizontal];
    }
    return _uPriceLb;
}
- (UIImageView *)logoIv {
    if (!_logoIv) {
        _logoIv = [[UIImageView alloc] init];
    }
    return _logoIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_primaryNFTColor]];
    }
    return _nameLb;
}
- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [PW_ViewTool buttonTitle:@"--" fontSize:12 titleColor:[UIColor g_grayTextColor] imageName:@"icon_collect" target:self action:@selector(collectAction)];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_collect_selected"] forState:UIControlStateSelected];
        [_collectBtn setRequiredHorizontal];
    }
    return _collectBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [PW_ViewTool buttonImageName:@"icon_share_ico" target:self action:@selector(shareAction)];
        _shareBtn.backgroundColor = [UIColor g_hex:@"#C7D4DF" alpha:0.3];
        [_shareBtn setCornerRadius:12];
        [_shareBtn setRequiredHorizontal];
    }
    return _shareBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}

@end
