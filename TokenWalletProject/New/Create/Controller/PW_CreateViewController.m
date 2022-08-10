//
//  PW_CreateViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_CreateViewController.h"
#import "PW_BackupWalletViewController.h"

@interface PW_CreateViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *walletNameView;
@property (nonatomic, weak) UIView *pwdView;
@property (nonatomic, weak) UIView *warnView;
@property (nonatomic, strong) UITextField *walletNameTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *againPwdTF;

@property (nonatomic, weak) UIButton *sureBtn;

@end

@implementation PW_CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_createWallet")];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.walletNameTF.rac_textSignal,self.pwdTF.rac_textSignal,self.againPwdTF.rac_textSignal] reduce:^id(NSString *walletName,NSString *pwd,NSString *againPwd){
        return @([walletName trim].length && [pwd trim].length && [againPwd trim].length);
    }];
}
- (void)createAction {
    NSString *walletName = [self.walletNameTF.text trim];
    if (![walletName judgeWalletName]) {
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
        [self createWalletWithWordStr:result];
    }];
}
- (void)createWalletWithWordStr:(NSString *)wordStr{
    NSString *pwdStr = self.pwdTF.text;
    self.sureBtn.userInteractionEnabled = NO;
    [self.view showLoadingIndicator];
    if ([User_manager loginWithUserName:kDefaultUserName withPassword:pwdStr withPwTip:@"" withMnemonic:wordStr isBackup:NO]){
        [FchainTool genWalletsWithMnemonic:wordStr createList:@[@"ETH"] block:^(BOOL sucess) {
            [self.view hideLoadingIndicator];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.sureBtn.userInteractionEnabled = YES;
            });
            if (sucess) {
                NSArray *list = [[PW_WalletManager shared] getWallets];
                if (list.count>0) {
                    [User_manager updateChooseWallet:list[0]];
                }
                [self showSuccess:LocalizedStr(@"text_success")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    PW_BackupWalletViewController *vc = [[PW_BackupWalletViewController alloc] init];
                    vc.isFirst = YES;
                    vc.wordStr = wordStr;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }else{
                [self showError:LocalizedStr(@"text_createFailure")];
            }
        }];
    }
}
- (void)pwdTFDidBegin:(UITextField *)sender {
    if (sender==self.pwdTF) {
        if (![self.pwdTF.text isNoEmpty]) {
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
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [bodyView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
        make.height.greaterThanOrEqualTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    UIView *walletNameView = [[UIView alloc] init];
    walletNameView.backgroundColor = [UIColor g_bgCardColor];
    [walletNameView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:walletNameView];
    self.walletNameView = walletNameView;
    [walletNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
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
    UIView *warnView = [[UIView alloc] init];
    warnView.backgroundColor = [UIColor g_warnBgColor];
    warnView.layer.cornerRadius = 12;
    [self.contentView addSubview:warnView];
    self.warnView = warnView;
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_create") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(createAction)];
    [self.contentView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [warnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(pwdView.mas_bottom).offset(40);
        make.bottom.equalTo(sureBtn.mas_top).offset(-18);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(55);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottomMargin.offset(-35);
    }];
    [self createWalletNameItems];
    [self createPwdItems];
    [self createWarnItems];
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
    self.walletNameTF = [PW_ViewTool textFieldFont:[UIFont systemFontOfSize:14] color:[UIColor g_textColor] placeholder:@"ETH"];
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
    [self.pwdTF addTarget:self action:@selector(pwdTFDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.pwdTF addTarget:self action:@selector(pwdTFDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
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
- (void)createWarnItems {
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:@"icon_warning"];
    [iconIv setRequiredHorizontal];
    [self.warnView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(20);
    }];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    titleLb.textColor = [UIColor g_warnColor];
    titleLb.text = LocalizedStr(@"text_createWalletTip");
    titleLb.numberOfLines = 0;
    [self.warnView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.top.offset(18);
        make.right.offset(-35);
        make.bottom.offset(-18);
    }];
}

@end
