//
//  PW_PrivateKeyImportViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PrivateKeyImportViewController.h"
#import "PW_ScanTool.h"

@interface PW_PrivateKeyImportViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *privateKeyView;
@property (nonatomic, weak) UIView *walletNameView;
@property (nonatomic, weak) UIView *pwdView;
@property (nonatomic, strong) UITextField *privateKeyTF;
@property (nonatomic, strong) UITextField *walletNameTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *againPwdTF;
@property (nonatomic, weak) UIButton *sureBtn;

@end

@implementation PW_PrivateKeyImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_privateKeyImport") rightImg:@"icon_scan" rightAction:@selector(scanAction)];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.privateKeyTF.rac_textSignal,self.walletNameTF.rac_textSignal,self.pwdTF.rac_textSignal,self.againPwdTF.rac_textSignal] reduce:^id(NSString *privateKey,NSString *walletName,NSString *pwd,NSString *againPwd){
        return @([privateKey trim].length && [walletName trim].length && [pwd trim].length && [againPwd trim].length);
    }];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        self.privateKeyTF.text = result;
    }];
}
- (void)infoAction {
    
}
- (void)sureAction {
    NSString *privateKeyStr = [self.privateKeyTF.text trim];
    if (![privateKeyStr isNoEmpty]) {
        [self showError:LocalizedStr(@"text_privateKeyInputError")];
        return;
    }
    NSString *pwdStr = self.pwdTF.text;
    NSString *walletName = [self.walletNameTF.text trim];
    if (![walletName judgeWalletName]) {
        [self showError:LocalizedStr(@"text_walletNameInputError")];
        return;
    }
    if (![pwdStr judgePassWordLegal]) {
        [self showError:LocalizedStr(@"text_pwdFormatError")];
        return;
    }
    if (![pwdStr isEqualToString:self.againPwdTF.text]) {
        [self showError:LocalizedStr(@"text_pwdDisagreeError")];
        return;
    }
    self.sureBtn.userInteractionEnabled = NO;
    [self.view showLoadingIndicator];
    [FchainTool restoreWalletWithPrivateKey:privateKeyStr walletName:walletName password:pwdStr block:^(NSString * _Nonnull result) {
        [self.view hideLoadingIndicator];
        self.sureBtn.userInteractionEnabled = YES;
        if([result isNoEmpty]){
            if ([User_manager loginWithUserName:result withPassword:pwdStr withPwTip:@"" withMnemonic:@"" isBackup:YES]){
                [self showSuccess:LocalizedStr(@"text_finishedWalletImport")];
                NSArray *list = [[PW_WalletManager shared] getWallets];
                if (list.count>0) {
                    [User_manager updateChooseWallet:list[0]];
                    [TheAppDelegate switchToTabBarController];
                }else{
                    [self showError:LocalizedStr(@"text_importFailure")];
                }
            }
        }else{
            [self showError:LocalizedStr(@"text_pleaseEnterCorrectPrivateKey")];
        }
    }];
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
    [scrollView setRadius:28 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
        make.height.greaterThanOrEqualTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    UIView *privateKeyView = [[UIView alloc] init];
    privateKeyView.backgroundColor = [UIColor g_bgCardColor];
    [privateKeyView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:privateKeyView];
    self.privateKeyView = privateKeyView;
    [privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(84);
    }];
    UIView *walletNameView = [[UIView alloc] init];
    walletNameView.backgroundColor = [UIColor g_bgCardColor];
    [walletNameView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:walletNameView];
    self.walletNameView = walletNameView;
    [walletNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privateKeyView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(84);
    }];
    UIView *pwdView = [[UIView alloc] init];
    pwdView.backgroundColor = [UIColor g_bgCardColor];
    [pwdView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:pwdView];
    self.pwdView = pwdView;
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletNameView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(130);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.contentView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(pwdView.mas_bottom).offset(40);
        make.height.offset(55);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottomMargin.offset(-35);
    }];
    [self createPrivateKeyItems];
    [self createWalletNameItems];
    [self createPwdItems];
}
- (void)createPrivateKeyItems {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = LocalizedStr(@"text_privateKey");
    titleLb.font = [UIFont pw_mediumFontOfSize:20];
    titleLb.textColor = [UIColor g_boldTextColor];
    [self.privateKeyView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
    }];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setImage:[UIImage imageNamed:@"icon_info"] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.privateKeyView addSubview:infoBtn];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb.mas_right).offset(5);
        make.centerY.equalTo(titleLb);
    }];
    self.privateKeyTF = [[UITextField alloc] init];
    [self.privateKeyTF pw_setPlaceholder:LocalizedStr(@"text_inputPrivateKeyTip")];
    self.privateKeyTF.font = [UIFont systemFontOfSize:14];
    self.privateKeyTF.textColor = [UIColor g_textColor];
    self.privateKeyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.privateKeyTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.privateKeyView addSubview:self.privateKeyTF];
    [self.privateKeyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(titleLb.mas_bottom).offset(0);
        make.bottom.offset(-5);
    }];
}
- (void)createWalletNameItems {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = NSStringWithFormat(@"%@ - ETH",LocalizedStr(@"text_walletName"));
    titleLb.font = [UIFont pw_mediumFontOfSize:20];
    titleLb.textColor = [UIColor g_boldTextColor];
    [self.walletNameView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
    }];
    self.walletNameTF = [[UITextField alloc] init];
    [self.walletNameTF pw_setPlaceholder:@"ETH"];
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
    titleLb.font = [UIFont pw_mediumFontOfSize:20];
    titleLb.textColor = [UIColor g_boldTextColor];
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
    [self.pwdTF pw_setSecureTextEntry];
    [self.pwdView addSubview:self.pwdTF];
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(titleLb.mas_bottom).offset(0);
        make.height.offset(45);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [self.pwdView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTF.mas_bottom).offset(0);
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
    [self.againPwdTF pw_setSecureTextEntry];
    [self.pwdView addSubview:self.againPwdTF];
    [self.againPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.height.offset(45);
    }];
}

@end
