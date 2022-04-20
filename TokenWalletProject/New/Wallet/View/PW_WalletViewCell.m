//
//  PW_WalletViewCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletViewCell.h"

@interface PW_WalletViewCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UILabel *stateLb;
@property (nonatomic, strong) UIButton *copyBtn;

@end

@implementation PW_WalletViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeViews];
    }
    return self;
}
- (void)setWallet:(Wallet *)wallet {
    _wallet = wallet;
    self.nameLb.text = wallet.walletName;
    self.addressLb.text = [wallet.address showShortAddress];
    self.stateLb.hidden = ![User_manager.currentUser.chooseWallet_address isEqualToString:wallet.address];
}
- (void)copyAction {
    [self.wallet.address pasteboardToast:YES];
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.nameLb];
    [self.bodyView addSubview:self.addressLb];
    [self.bodyView addSubview:self.stateLb];
    [self.bodyView addSubview:self.copyBtn];
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
    [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.right.offset(-18);
    }];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLb.mas_bottom).offset(4);
        make.left.offset(20);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLb.mas_right).offset(8);
        make.centerY.equalTo(self.addressLb);
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
- (UILabel *)stateLb {
    if (!_stateLb) {
        _stateLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_current") fontSize:13 textColor:[UIColor g_primaryColor]];
        _stateLb.hidden = YES;
    }
    return _stateLb;
}
- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [PW_ViewTool buttonImageName:@"icon_copyAndBg" target:self action:@selector(copyAction)];
    }
    return _copyBtn;
}

@end
