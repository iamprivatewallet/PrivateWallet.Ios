//
//  PW_NetworkManageCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NetworkManageCell.h"

@interface PW_NetworkManageCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *iconLb;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIImageView *arrowIv;

@end

@implementation PW_NetworkManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    self.arrowIv.hidden = isEdit;
    self.topBtn.hidden = !isEdit;
}
- (void)topAction {
    if (self.topBlock) {
        self.topBlock(self.model);
    }
}
- (void)setModel:(PW_NetworkModel *)model {
    _model = model;
    self.iconLb.text = model.title.pw_firstStr.uppercaseString;
    self.nameLb.text = model.title;
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.iconLb];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.topBtn];
    self.arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.bodyView addSubview:self.arrowIv];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(6);
        make.bottom.offset(-6);
        make.right.offset(-10);
    }];
    [self.iconLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.width.height.offset(36);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconLb.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    [self.arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        [_bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        _bodyView.layer.cornerRadius = 8;
        _bodyView.backgroundColor = [UIColor g_bgColor];
    }
    return _bodyView;
}
- (UILabel *)iconLb {
    if (!_iconLb) {
        _iconLb = [[UILabel alloc] init];
        _iconLb.layer.cornerRadius = 18;
        _iconLb.layer.masksToBounds = YES;
        _iconLb.backgroundColor = [UIColor g_primaryColor];
        _iconLb.textColor = [UIColor g_primaryTextColor];
        _iconLb.textAlignment = NSTextAlignmentCenter;
    }
    return _iconLb;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [PW_ViewTool buttonImageName:@"icon_sticky_top" target:self action:@selector(topAction)];
        _topBtn.hidden = YES;
    }
    return _topBtn;
}

@end
