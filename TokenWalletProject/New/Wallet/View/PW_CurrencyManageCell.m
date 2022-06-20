//
//  PW_CurrencyManageCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_CurrencyManageCell.h"

@interface PW_CurrencyManageCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;
@property (nonatomic, strong) UIButton *topBtn;

@end

@implementation PW_CurrencyManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)topAction {
    if (self.topBlock) {
        self.topBlock(self.model);
    }
}
- (void)setModel:(PW_TokenModel *)model {
    _model = model;
    self.topBtn.hidden = model.isDefault;
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = model.tokenSymbol;
    self.subNameLb.text = model.tokenName;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconIv];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.subNameLb];
    [self.bodyView addSubview:self.topBtn];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.bottom.offset(0);
        make.right.offset(-20);
    }];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
        make.width.height.offset(46);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(8);
        make.centerY.offset(0);
    }];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(8);
        make.baseline.equalTo(self.nameLb);
    }];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
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
        _nameLb = [PW_ViewTool labelBoldText:@"--" fontSize:20 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}
- (UILabel *)subNameLb {
    if (!_subNameLb) {
        _subNameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    }
    return _subNameLb;
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [PW_ViewTool buttonImageName:@"icon_sticky_top" target:self action:@selector(topAction)];
    }
    return _topBtn;
}

@end
