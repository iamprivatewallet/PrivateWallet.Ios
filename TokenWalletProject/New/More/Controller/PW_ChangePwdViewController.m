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
    UIView *originView = [[UIView alloc] init];
    originView.backgroundColor = [UIColor g_bgColor];
    [originView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [originView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.view addSubview:originView];
    UILabel *originTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_originPwd") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [originView addSubview:originTipLb];
    self.originPwdTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputOrginPwd")];
    self.originPwdTf.secureTextEntry = YES;
    [originView addSubview:self.originPwdTf];
    [originView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.offset(20);
        make.right.offset(-20);
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
    setupView.backgroundColor = [UIColor g_bgColor];
    [setupView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [setupView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.view addSubview:setupView];
    UILabel *setupTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_setTradePwd") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [setupView addSubview:setupTipLb];
    self.pwdTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_setTradePwdTip")];
    self.pwdTf.secureTextEntry = YES;
    [setupView addSubview:self.pwdTf];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [setupView addSubview:lineView];
    self.againPwdTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputAgain")];
    self.againPwdTf.secureTextEntry = YES;
    [setupView addSubview:self.againPwdTf];
    [setupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(160);
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
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(40);
    }];
    self.sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(setupView.mas_bottom).offset(40);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
    }];
}

@end
