//
//  PW_ChangePwdViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChangePwdViewController.h"

@interface PW_ChangePwdViewController ()

@property (nonatomic, strong) UITextField *originPwdTf;
@property (nonatomic, strong) UITextField *pwdTf;
@property (nonatomic, strong) UITextField *againPwdTf;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation PW_ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_changePwd")];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.originPwdTf.rac_textSignal,self.pwdTf.rac_textSignal,self.againPwdTf.rac_textSignal] reduce:^id(NSString *originPwd,NSString *pwd,NSString *againPwd){
        return @([originPwd trim].length>0&&[pwd trim].length>0&&[againPwd trim].length>0);
    }];
}
- (void)sureAction {
    NSString *originPwd = [self.originPwdTf.text trim];
    NSString *pwd = [self.pwdTf.text trim];
    NSString *againPwd = [self.againPwdTf.text trim];
    if (![originPwd isNoEmpty]) {
        [self showError:LocalizedStr(@"text_inputOrginPwd")];
        return;
    }
    if (![originPwd isEqualToString:self.model.walletPassword]) {
        [self showError:LocalizedStr(@"text_pwdError")];
        return;
    }
    if (![pwd isNoEmpty]) {
        [self showError:LocalizedStr(@"text_inputTradePwd")];
        return;
    }
    if (![pwd judgePassWordLegal]) {
        [self showError:LocalizedStr(@"text_pwdFormatError")];
        return;
    }
    if (![pwd isEqualToString:againPwd]) {
        [self showError:LocalizedStr(@"text_pwdDisagreeError")];
        return;
    }
    [[PW_WalletManager shared] updateWalletPwd:pwd address:self.model.address type:self.model.type];
    [self showSuccess:LocalizedStr(@"text_changeSuccess")];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.bottom.right.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIView *originView = [[UIView alloc] init];
    originView.backgroundColor = [UIColor g_bgCardColor];
    [originView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [contentView addSubview:originView];
    UILabel *originTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_originPwd") fontSize:20 textColor:[UIColor g_boldTextColor]];
    [originView addSubview:originTipLb];
    self.originPwdTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputOrginPwd")];
    [self.originPwdTf pw_setSecureTextEntry];
    [originView addSubview:self.originPwdTf];
    [originView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(84);
    }];
    [originTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(18);
    }];
    [self.originPwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.left.offset(18);
        make.right.offset(-15);
        make.bottom.offset(-10);
    }];
    UIView *setupView = [[UIView alloc] init];
    setupView.backgroundColor = [UIColor g_bgCardColor];
    [setupView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [contentView addSubview:setupView];
    UILabel *setupTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_setTradePwd") fontSize:20 textColor:[UIColor g_boldTextColor]];
    [setupView addSubview:setupTipLb];
    self.pwdTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_setTradePwdTip")];
    [self.pwdTf pw_setSecureTextEntry];
    [setupView addSubview:self.pwdTf];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [setupView addSubview:lineView];
    self.againPwdTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputAgain")];
    [self.againPwdTf pw_setSecureTextEntry];
    [setupView addSubview:self.againPwdTf];
    [setupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(140);
    }];
    [setupTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(18);
    }];
    [self.pwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(setupTipLb.mas_bottom).offset(10);
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(40);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTf.mas_bottom).offset(5);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(1);
    }];
    [self.againPwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(40);
    }];
    self.sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottomMargin.offset(-20);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
    }];
}

@end
