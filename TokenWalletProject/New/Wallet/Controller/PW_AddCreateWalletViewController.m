//
//  PW_AddCreateWalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/12.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddCreateWalletViewController.h"
#import "PW_BackupWalletViewController.h"

@interface PW_AddCreateWalletViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *walletNameView;
@property (nonatomic, weak) UIView *pwdView;
@property (nonatomic, weak) UIView *warnView;
@property (nonatomic, strong) UITextField *walletNameTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *againPwdTF;

@property (nonatomic, weak) UIButton *sureBtn;

@end

@implementation PW_AddCreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_createWallet")];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.walletNameTF.rac_textSignal,self.pwdTF.rac_textSignal,self.againPwdTF.rac_textSignal] reduce:^id(NSString *walletName,NSString *pwd,NSString *againPwd){
        return @(walletName.length && pwd.length && againPwd.length);
    }];
}
- (void)createAction {
    NSString *walletName = [self.walletNameTF.text trim];
    if ([walletName isEmptyStr]) {
        [self showError:LocalizedStr(@"text_walletNameInputError")];
        return;
    }
    NSString *pwdStr = self.pwdTF.text;
    if (![pwdStr judgePassWordLegal]) {
        [self showError:LocalizedStr(@"text_pwdFormatError")];
        return;
    }
    if (![pwdStr isEqualToString:self.againPwdTF.text]) {
        [self showError:LocalizedStr(@"text_pwdDisagreeError")];
        return;
    }
    [self.view showLoadingIndicator];
    //创建助记词
    [FchainTool generateMnemonicBlock:^(NSString * _Nonnull result) {
        [self.view hideLoadingIndicator];
        Wallet *wallet = [[Wallet alloc] init];
        wallet.walletName = walletName;
        wallet.walletPassword = pwdStr;
        wallet.walletPasswordTips = @"";
        wallet.mnemonic = result;
        wallet.type = self.walletType;
        PW_BackupWalletViewController *vc = [[PW_BackupWalletViewController alloc] init];
        vc.isFirst = YES;
        vc.wordStr = result;
        vc.wallet = wallet;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)pwdTFDidBegin:(UITextField *)sender {
    if (sender==self.pwdTF) {
        if ([self.pwdTF.text isEmptyStr]) {
            [self showMessage:LocalizedStr(@"text_inputPwdTip")];
        }
    }
}
- (void)pwdTFDidEnd:(UITextField *)sender {
    if (sender==self.pwdTF) {
        [self dismissMessage];
    }
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:@"icon_privateKey_big"];
    [self.contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(30);
    }];
    UIView *walletNameView = [[UIView alloc] init];
    walletNameView.backgroundColor = [UIColor g_bgColor];
    walletNameView.layer.cornerRadius = 8;
    walletNameView.layer.shadowColor = [UIColor g_shadowColor].CGColor;
    walletNameView.layer.shadowOffset = CGSizeMake(0, 2);
    walletNameView.layer.shadowRadius = 8;
    walletNameView.layer.shadowOpacity = 1;
    walletNameView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH-40, 84)].CGPath;
    [self.contentView addSubview:walletNameView];
    self.walletNameView = walletNameView;
    [walletNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom).offset(40);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.mas_equalTo(84);
    }];
    UIView *pwdView = [[UIView alloc] init];
    pwdView.backgroundColor = [UIColor g_bgColor];
    pwdView.layer.cornerRadius = 8;
    pwdView.layer.shadowColor = [UIColor g_shadowColor].CGColor;
    pwdView.layer.shadowOffset = CGSizeMake(0, 2);
    pwdView.layer.shadowRadius = 8;
    pwdView.layer.shadowOpacity = 1;
    pwdView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH-40, 160)].CGPath;
    [self.contentView addSubview:pwdView];
    self.pwdView = pwdView;
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletNameView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.mas_equalTo(160);
    }];
    UIView *warnView = [[UIView alloc] init];
    warnView.backgroundColor = [UIColor g_warnBgColor];
    warnView.layer.cornerRadius = 12;
    [self.contentView addSubview:warnView];
    self.warnView = warnView;
    [warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdView.mas_bottom).offset(56);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_create") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(createAction)];
    [self.contentView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(warnView.mas_bottom).offset(45);
        make.height.offset(55);
        make.left.offset(25);
        make.right.offset(-25);
        make.bottom.offset(-40);
    }];
    [self createWalletNameItems];
    [self createPwdItems];
    [self createWarnItems];
}
- (void)createWalletNameItems {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = NSStringWithFormat(@"%@ - %@",LocalizedStr(@"text_walletName"),self.walletType);
    titleLb.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    titleLb.textColor = [UIColor g_boldTextColor];
    titleLb.layer.opacity = 0.7;
    [self.walletNameView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
    }];
    self.walletNameTF = [[UITextField alloc] init];
    [self.walletNameTF pw_setPlaceholder:self.walletType];
    self.walletNameTF.font = [UIFont systemFontOfSize:14];
    self.walletNameTF.textColor = [UIColor g_textColor];
    self.walletNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.walletNameView addSubview:self.walletNameTF];
    [self.walletNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(titleLb.mas_bottom).offset(0);
        make.bottom.offset(-5);
    }];
}
- (void)createPwdItems {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = LocalizedStr(@"text_setTradePwd");
    titleLb.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    titleLb.textColor = [UIColor g_boldTextColor];
    titleLb.layer.opacity = 0.7;
    [self.pwdView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
    }];
    self.pwdTF = [[UITextField alloc] init];
    [self.pwdTF pw_setPlaceholder:LocalizedStr(@"text_setTradePwdTip")];
    self.pwdTF.font = [UIFont systemFontOfSize:14];
    self.pwdTF.textColor = [UIColor g_textColor];
    self.pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwdTF.keyboardType = UIKeyboardTypeAlphabet;
    self.pwdTF.textContentType = UITextContentTypePassword;
    self.pwdTF.secureTextEntry = YES;
    [self.pwdTF addTarget:self action:@selector(pwdTFDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.pwdTF addTarget:self action:@selector(pwdTFDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.pwdView addSubview:self.pwdTF];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(titleLb.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.pwdView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTF.mas_bottom).offset(5);
        make.left.offset(18);
        make.right.offset(-15);
        make.height.offset(1);
    }];
    self.againPwdTF = [[UITextField alloc] init];
    [self.againPwdTF pw_setPlaceholder:LocalizedStr(@"text_inputAgain")];
    self.againPwdTF.font = [UIFont systemFontOfSize:14];
    self.againPwdTF.textColor = [UIColor g_textColor];
    self.againPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.againPwdTF.keyboardType = UIKeyboardTypeAlphabet;
    self.againPwdTF.textContentType = UITextContentTypePassword;
    self.againPwdTF.secureTextEntry = YES;
    [self.pwdView addSubview:self.againPwdTF];
    [self.againPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.height.offset(50);
    }];
}
- (void)createWarnItems {
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:@"icon_warning"];
    [self.warnView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10);
    }];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    titleLb.textColor = [UIColor g_warnColor];
    titleLb.text = LocalizedStr(@"text_createWalletTip");
    titleLb.numberOfLines = 0;
    [self.warnView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.top.offset(8);
        make.right.offset(-10);
        make.bottom.offset(-8);
    }];
}

@end
