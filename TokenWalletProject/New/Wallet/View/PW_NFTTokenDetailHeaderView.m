//
//  PW_NFTTokenDetailHeaderView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTTokenDetailHeaderView.h"

@interface PW_NFTTokenDetailHeaderView ()

@property (nonatomic, strong) UIImageView *bgIv;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView *logoIv;
@property (nonatomic, strong) UILabel *failarmyNameLb;
@property (nonatomic, strong) UILabel *failarmyTokenIdLb;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UIButton *addRemoveBtn;
@property (nonatomic, strong) UILabel *addRemoveTipLb;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIImageView *coinTypeIv;
@property (nonatomic, strong) UILabel *lastTransactionPriceLb;
@property (nonatomic, strong) UILabel *lastTransactionPriceTipLb;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *tokenStandardLb;
@property (nonatomic, strong) UILabel *networkLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIButton *copyAddressBtn;
@property (nonatomic, strong) UILabel *tokenIdLb;
@property (nonatomic, strong) UIButton *copyTokenIdBtn;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation PW_NFTTokenDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)transferAction {
    if (self.transferBlock) {
        self.transferBlock();
    }
}
- (void)addRemoveAction {
    if (self.addRemoveMarketBlock) {
        self.addRemoveMarketBlock();
    }
}
- (void)copyAction {
    [self.model.asset.tokenId pasteboardToast:YES];
}
- (void)copyAddressAction {
    [self.model.asset.assetContract pasteboardToast:YES];
}
- (void)copyTokenIdAction {
    [self.model.asset.tokenId pasteboardToast:YES];
}
- (void)setModel:(PW_NFTDetailModel *)model {
    _model = model;
    [self.bgIv sd_setImageWithURL:[NSURL URLWithString:model.asset.imageUrl]];
    [self.logoIv sd_setImageWithURL:[NSURL URLWithString:model.collection.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_default"]];
    self.failarmyNameLb.text = model.collection.name;
    self.failarmyTokenIdLb.text = model.asset.tokenId;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.asset.imageUrl]];
//    self.addRemoveBtn.selected = ;
    self.addRemoveTipLb.text = @"";
    self.titleLb.text = model.asset.name;
    self.coinTypeIv.image = [UIImage imageNamed:PW_StrFormat(@"icon_small_chain_%@",model.asset.chainId)];
    self.lastTransactionPriceLb.text = model.asset.ethPrice;
    self.nameLb.text = model.collection.name;
    self.tokenStandardLb.text = model.assetContract.schemaName;
    self.networkLb.text = [[SettingManager sharedInstance] getNetworkNameWithChainId:model.asset.chainId];
    self.addressLb.text = model.asset.assetContract;
    self.tokenIdLb.text = model.asset.tokenId;
}
- (void)makeViews {
    [self addSubview:self.bgIv];
    [self addSubview:self.effectView];
    [self addSubview:self.contentView];
    [self makeEffectView];
    [self makeContentView];
    [self.bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(262);
    }];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgIv);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIv.mas_bottom).offset(-42);
        make.left.right.bottom.offset(0);
    }];
}
- (void)makeEffectView {
    [self.effectView.contentView addSubview:self.logoIv];
    [self.effectView.contentView addSubview:self.failarmyNameLb];
    [self.effectView.contentView addSubview:self.failarmyTokenIdLb];
    [self.effectView.contentView addSubview:self.copyBtn];
    [self.effectView.contentView addSubview:self.transferBtn];
    [self.effectView.contentView addSubview:self.addRemoveBtn];
    [self.logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.left.offset(20);
        make.bottom.equalTo(self.transferBtn.mas_top).offset(-22);
    }];
    [self.failarmyNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(10);
        make.top.equalTo(self.logoIv).offset(-2);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    [self.failarmyTokenIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoIv.mas_right).offset(10);
        make.bottom.equalTo(self.logoIv).offset(2);
        make.right.mas_lessThanOrEqualTo(-40);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.failarmyTokenIdLb.mas_right).offset(8);
        make.centerY.equalTo(self.failarmyTokenIdLb);
    }];
    [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-70);
        make.left.offset(20);
        make.height.mas_equalTo(38);
    }];
    [self.addRemoveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.equalTo(self.transferBtn);
        make.left.equalTo(self.transferBtn.mas_right).offset(10);
    }];
}
- (void)makeContentView {
    [self.contentView addSubview:self.iconIv];
    [self.contentView addSubview:self.titleLb];
    UIView *rightView = [[UIView alloc] init];
    [self.contentView addSubview:rightView];
    [rightView addSubview:self.coinTypeIv];
    [rightView addSubview:self.lastTransactionPriceLb];
    [rightView addSubview:self.lastTransactionPriceTipLb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.infoView];
    [self.contentView addSubview:self.bottomView];
    [self makeInfoView];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.mas_equalTo(255);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.mas_lessThanOrEqualTo(rightView.mas_left).offset(-30);
        make.centerY.equalTo(rightView);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.top.equalTo(self.iconIv.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    [self.coinTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.centerY.equalTo(self.lastTransactionPriceLb);
        make.right.equalTo(self.lastTransactionPriceLb.mas_left).offset(-3);
        make.left.mas_greaterThanOrEqualTo(0);
    }];
    [self.lastTransactionPriceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
    }];
    [self.lastTransactionPriceTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.offset(0);
        make.left.mas_greaterThanOrEqualTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView.mas_bottom).offset(20);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.mas_equalTo(1);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(125);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(5);
    }];
}
- (void)makeInfoView {
    [self.infoView addSubview:self.nameLb];
    [self.infoView addSubview:self.tokenStandardLb];
    [self.infoView addSubview:self.networkLb];
    [self.infoView addSubview:self.addressLb];
    [self.infoView addSubview:self.copyAddressBtn];
    [self.infoView addSubview:self.tokenIdLb];
    [self.infoView addSubview:self.copyTokenIdBtn];
    UILabel *nameTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_collectionSeries") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.infoView addSubview:nameTipLb];
    UILabel *tokenStandardTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_tokenStandard") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.infoView addSubview:tokenStandardTipLb];
    UILabel *networkTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_network") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.infoView addSubview:networkTipLb];
    UILabel *addressTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_contractAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.infoView addSubview:addressTipLb];
    UILabel *tokenIdTipLb = [PW_ViewTool labelSemiboldText:@"Token ID" fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.infoView addSubview:tokenIdTipLb];
    [nameTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(nameTipLb);
        make.width.mas_lessThanOrEqualTo(self.infoView.mas_width).multipliedBy(0.5);
    }];
    [tokenStandardTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTipLb.mas_bottom).offset(10);
        make.left.offset(0);
    }];
    [self.tokenStandardLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(tokenStandardTipLb);
    }];
    [networkTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tokenStandardTipLb.mas_bottom).offset(10);
        make.left.offset(0);
    }];
    [self.networkLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(networkTipLb);
    }];
    [addressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(networkTipLb.mas_bottom).offset(10);
        make.left.offset(0);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.copyAddressBtn.mas_left).offset(-4);
        make.centerY.equalTo(addressTipLb);
        make.width.mas_lessThanOrEqualTo(self.infoView.mas_width).multipliedBy(0.5);
    }];
    [self.copyAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(addressTipLb);
    }];
    [tokenIdTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTipLb.mas_bottom).offset(10);
        make.left.offset(0);
    }];
    [self.tokenIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.copyTokenIdBtn.mas_left).offset(-4);
        make.centerY.equalTo(tokenIdTipLb);
        make.width.mas_lessThanOrEqualTo(self.infoView.mas_width).multipliedBy(0.5);
    }];
    [self.copyTokenIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(tokenIdTipLb);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}
#pragma mark - lazy
- (UIImageView *)bgIv {
    if (!_bgIv) {
        _bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_big"]];
    }
    return _bgIv;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}
- (UIImageView *)logoIv {
    if (!_logoIv) {
        _logoIv = [[UIImageView alloc] init];
    }
    return _logoIv;
}
- (UILabel *)failarmyNameLb {
    if (!_failarmyNameLb) {
        _failarmyNameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:19 textColor:[UIColor whiteColor]];
    }
    return _failarmyNameLb;
}
- (UILabel *)failarmyTokenIdLb {
    if (!_failarmyTokenIdLb) {
        _failarmyTokenIdLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor colorWithWhite:1 alpha:0.6]];
    }
    return _failarmyTokenIdLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copy_new" target:self action:@selector(copyAction)];
    }
    return _copyBtn;
}
- (UIButton *)transferBtn {
    if (!_transferBtn) {
        _transferBtn = [[UIButton alloc] init];
        _transferBtn.backgroundColor = [[UIColor whiteColor] alpha:0.2];
        [_transferBtn setCornerRadius:19];
        [_transferBtn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nft_transfer"]];
        [_transferBtn addSubview:iconIv];
        UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_transfer") fontSize:15 textColor:[UIColor whiteColor]];
        [_transferBtn addSubview:titleLb];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.offset(0);
        }];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(10);
            make.centerY.offset(0);
            make.right.offset(-20);
        }];
    }
    return _transferBtn;
}
- (UIButton *)addRemoveBtn {
    if (!_addRemoveBtn) {
        _addRemoveBtn = [[UIButton alloc] init];
        _addRemoveBtn.backgroundColor = [[UIColor whiteColor] alpha:0.2];
        [_addRemoveBtn setCornerRadius:19];
        [_addRemoveBtn addTarget:self action:@selector(addRemoveAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nft_addRemove"]];
        [_addRemoveBtn addSubview:iconIv];
        [_addRemoveBtn addSubview:self.addRemoveTipLb];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.offset(0);
        }];
        [self.addRemoveTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(10);
            make.centerY.offset(0);
            make.right.offset(-20);
        }];
    }
    return _addRemoveBtn;
}
- (UILabel *)addRemoveTipLb {
    if (!_addRemoveTipLb) {
//        LocalizedStr(@"text_removedFromBazaar")
        _addRemoveTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_addToMarket") fontSize:15 textColor:[UIColor whiteColor]];
    }
    return _addRemoveTipLb;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
    }
    return _contentView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_big"]];
        [_iconIv setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 8) radius:10];
        _iconIv.layer.cornerRadius = 16;
    }
    return _iconIv;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelBoldText:@"--" fontSize:17 textColor:[UIColor g_textColor]];
        _titleLb.numberOfLines = 2;
    }
    return _titleLb;
}
- (UIImageView *)coinTypeIv {
    if (!_coinTypeIv) {
        _coinTypeIv = [[UIImageView alloc] init];
    }
    return _coinTypeIv;
}
- (UILabel *)lastTransactionPriceLb {
    if (!_lastTransactionPriceLb) {
        _lastTransactionPriceLb = [PW_ViewTool labelBoldText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
        [_lastTransactionPriceLb setRequiredHorizontal];
    }
    return _lastTransactionPriceLb;
}
- (UILabel *)lastTransactionPriceTipLb {
    if (!_lastTransactionPriceTipLb) {
        _lastTransactionPriceTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_lastTransactionPrice") fontSize:12 textColor:[[UIColor g_textColor] alpha:0.6]];
        [_lastTransactionPriceTipLb setRequiredHorizontal];
    }
    return _lastTransactionPriceTipLb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor g_lineColor];
    }
    return _lineView;
}
- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
    }
    return _infoView;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}
- (UILabel *)tokenStandardLb {
    if (!_tokenStandardLb) {
        _tokenStandardLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _tokenStandardLb;
}
- (UILabel *)networkLb {
    if (!_networkLb) {
        _networkLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _networkLb;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
        _addressLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _addressLb;
}
- (UIButton *)copyAddressBtn {
    if (!_copyAddressBtn) {
        _copyAddressBtn = [PW_ViewTool buttonImageName:@"icon_copy_new_small" target:self action:@selector(copyAddressAction)];
    }
    return _copyAddressBtn;
}
- (UILabel *)tokenIdLb {
    if (!_tokenIdLb) {
        _tokenIdLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
        _tokenIdLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _tokenIdLb;
}
- (UIButton *)copyTokenIdBtn {
    if (!_copyTokenIdBtn) {
        _copyTokenIdBtn = [PW_ViewTool buttonImageName:@"icon_copy_new_small" target:self action:@selector(copyTokenIdAction)];
    }
    return _copyTokenIdBtn;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor g_lineColor];
    }
    return _bottomView;
}

@end
