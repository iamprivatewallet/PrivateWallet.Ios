//
//  PW_RankListNFTCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_RankListNFTCell.h"

@interface PW_RankListNFTCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIButton *seriesBtn;
@property (nonatomic, strong) UIImageView *chainTypeIv;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UIImageView *rankIv;
@property (nonatomic, strong) UILabel *rankLb;

@end

@implementation PW_RankListNFTCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.rankLb.hidden = YES;
    self.rankIv.hidden = YES;
    if (index>=0&&index<=2) {
        self.rankIv.image = [UIImage imageNamed:PW_StrFormat(@"icon_nft_rank_%ld",index+1)];
        self.rankIv.hidden = NO;
    }else{
        self.rankLb.hidden = NO;
    }
    self.rankLb.text = @(index).stringValue;
}
- (void)setModel:(PW_NFTTokenModel *)model {
    _model = model;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.imageThumbnailUrl]];
    self.nameLb.text = model.name;
    [self.seriesBtn setTitle:model.slug forState:UIControlStateNormal];
    self.chainTypeIv.image = [UIImage imageNamed:PW_StrFormat(@"icon_small_chain_%@",model.chainId)];
    self.priceLb.text = model.ethPrice;
}
- (void)seriesAction {
    if (self.seriesBlock) {
        self.seriesBlock(self.model);
    }
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.seriesBtn];
    [self.bodyView addSubview:self.chainTypeIv];
    [self.bodyView addSubview:self.priceLb];
    [self.bodyView addSubview:self.rankIv];
    [self.bodyView addSubview:self.rankLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(-10);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(82);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(12);
        make.top.equalTo(self.iconIv);
        make.right.mas_lessThanOrEqualTo(-60);
    }];
    [self.seriesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.nameLb.mas_bottom).offset(5);
        make.right.mas_lessThanOrEqualTo(-60);
    }];
    [self.chainTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.bottom.equalTo(self.iconIv.mas_bottom).offset(-10);
        make.width.height.mas_equalTo(10);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chainTypeIv.mas_right).offset(4);
        make.centerY.equalTo(self.chainTypeIv);
    }];
    [self.rankIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(-15);
    }];
    [self.rankLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-16);
        make.width.height.mas_equalTo(38);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 4) radius:8];
        _bodyView.layer.cornerRadius = 8;
    }
    return _bodyView;
}
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}
- (UIButton *)seriesBtn {
    if (!_seriesBtn) {
        _seriesBtn = [PW_ViewTool buttonSemiboldTitle:@"--" fontSize:12 titleColor:[UIColor g_primaryNFTColor] imageName:nil target:self action:@selector(seriesAction)];
    }
    return _seriesBtn;
}
- (UIImageView *)chainTypeIv {
    if (!_chainTypeIv) {
        _chainTypeIv = [[UIImageView alloc] init];
    }
    return _chainTypeIv;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelText:@"--" fontSize:13 textColor:[UIColor g_grayTextColor]];
    }
    return _priceLb;
}
- (UIImageView *)rankIv {
    if (!_rankIv) {
        _rankIv = [[UIImageView alloc] init];
    }
    return _rankIv;
}
- (UILabel *)rankLb {
    if (!_rankLb) {
        _rankLb = [PW_ViewTool labelSemiboldText:@"-" fontSize:21 textColor:[UIColor g_textColor]];
        _rankLb.textAlignment = NSTextAlignmentCenter;
        _rankLb.backgroundColor = [UIColor g_hex:@"#C3FFD7"];
        [_rankLb setCornerRadius:19];
    }
    return _rankLb;
}

@end
