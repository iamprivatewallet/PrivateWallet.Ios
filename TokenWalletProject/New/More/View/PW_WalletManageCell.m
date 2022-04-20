//
//  PW_WalletManageCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletManageCell.h"

@interface PW_WalletManageCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIImageView *arrowIv;

@end

@implementation PW_WalletManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setModel:(Wallet *)model {
    _model = model;
    self.nameLb.text = model.walletName;
    self.addressLb.text = [model.address showShortAddress];
}
- (void)copyAction {
    [self.model.address pasteboardToast:YES];
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
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.addressLb];
    [self.bodyView addSubview:self.copyBtn];
    [self.bodyView addSubview:self.topBtn];
    [self.bodyView addSubview:self.arrowIv];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-12);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(20);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLb.mas_bottom).offset(4);
        make.left.offset(20);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLb.mas_right).offset(8);
        make.centerY.equalTo(self.addressLb);
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
    if(!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
        _bodyView.layer.cornerRadius = 8;
    }
    return _bodyView;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    }
    return _nameLb;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    }
    return _addressLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copyAndBg" target:self action:@selector(copyAction)];
    }
    return _copyBtn;
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [PW_ViewTool buttonImageName:@"icon_sticky_top" target:self action:@selector(topAction)];
        _topBtn.hidden = YES;
    }
    return _topBtn;
}
- (UIImageView *)arrowIv {
    if (!_arrowIv) {
        _arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    }
    return _arrowIv;
}

@end
