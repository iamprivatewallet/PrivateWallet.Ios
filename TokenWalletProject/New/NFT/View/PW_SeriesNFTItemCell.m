//
//  PW_SeriesNFTItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SeriesNFTItemCell.h"

@interface PW_SeriesNFTItemCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIImageView *chainTypeIv;
@property (nonatomic, strong) UILabel *priceLb;
@property (nonatomic, strong) UIButton *seriesBtn;
@property (nonatomic, strong) UIButton *collectBtn;

@end

@implementation PW_SeriesNFTItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)collectAction {
    self.collectBtn.selected = !self.collectBtn.isSelected;
    if (self.collectBlock) {
        self.collectBlock(self.collectBtn.selected);
    }
}
- (void)seriesAction {
    if (self.seriesBlock) {
        self.seriesBlock();
    }
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.chainTypeIv];
    [self.bodyView addSubview:self.priceLb];
    [self.bodyView addSubview:self.seriesBtn];
    [self.bodyView addSubview:self.collectBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(3);
        make.right.offset(-3);
        make.bottom.offset(-83);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(5);
        make.left.offset(12);
        make.right.mas_lessThanOrEqualTo(-12);
    }];
    [self.chainTypeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(32);
        make.left.offset(12);
        make.width.height.mas_equalTo(10);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chainTypeIv.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(-5);
        make.centerY.equalTo(self.chainTypeIv);
    }];
    [self.seriesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.centerY.equalTo(self.collectBtn);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.bottom.offset(-10);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 6) radius:8];
        _bodyView.layer.cornerRadius = 6;
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
- (UIImageView *)chainTypeIv {
    if (!_chainTypeIv) {
        _chainTypeIv = [[UIImageView alloc] init];
    }
    return _chainTypeIv;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelText:@"--" fontSize:13 textColor:[UIColor g_textColor]];
    }
    return _priceLb;
}
- (UIButton *)seriesBtn {
    if (!_seriesBtn) {
        _seriesBtn = [PW_ViewTool buttonSemiboldTitle:@"--" fontSize:12 titleColor:[UIColor g_primaryNFTColor] imageName:nil target:self action:@selector(seriesAction)];
    }
    return _seriesBtn;
}
- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [PW_ViewTool buttonTitle:@"--" fontSize:12 titleColor:[UIColor g_grayTextColor] imageName:@"icon_collect" target:self action:@selector(collectAction)];
        [_collectBtn setImage:[UIImage imageNamed:@"icon_collect_selected"] forState:UIControlStateSelected];
    }
    return _collectBtn;
}

@end