//
//  PW_MnemonicImportViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MnemonicImportViewController.h"
#import "PW_ScanTool.h"

@interface PW_MnemonicImportViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *mnemonicView;
@property (nonatomic, weak) UIButton *advancedModeBtn;
@property (nonatomic, weak) UIView *advancedModeView;
@property (nonatomic, weak) UIView *walletNameView;
@property (nonatomic, weak) UIView *pwdView;
@property (nonatomic, strong) UITextField *mnemonicTF;
@property (nonatomic, strong) UITextField *walletNameTF;
@property (nonatomic, strong) UITextField *walletPathTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *againPwdTF;
@property (nonatomic, weak) UIButton *sureBtn;

@property (nonatomic, assign) BOOL showAdvancedMode;

@end

@implementation PW_MnemonicImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_mnemonicWordImport") rightImg:@"icon_scan" rightAction:@selector(scanAction)];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.mnemonicTF.rac_textSignal,self.walletNameTF.rac_textSignal,self.pwdTF.rac_textSignal,self.againPwdTF.rac_textSignal] reduce:^id(NSString *mnemonic,NSString *walletName,NSString *pwd,NSString *againPwd){
        return @([mnemonic trim].length && [walletName trim].length && [pwd trim].length && [againPwd trim].length);
    }];
}
- (void)scanAction {
    [[PW_ScanTool shared] showScanWithResultBlock:^(NSString * _Nonnull result) {
        self.mnemonicTF.text = result;
    }];
}
- (void)infoAction {
    
}
- (void)advanceModeAction {
    self.showAdvancedMode = !self.showAdvancedMode;
    self.advancedModeView.hidden = !self.showAdvancedMode;
    [self.advancedModeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advancedModeBtn.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(self.showAdvancedMode?84:0);
    }];
}
- (void)sureAction {
    NSString *mnemonicStr = [self.mnemonicTF.text trim];
    NSArray *array = [mnemonicStr componentsSeparatedByString:@" "];
    NSMutableString *wordStr = [[NSMutableString alloc] init];
    NSInteger wordCount = 0;
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *subStr = [array objectAtIndex:i];
        if ([subStr isEqualToString:@""]) {
            continue;
        }
        [wordStr appendString:subStr];
        if (i != array.count-1) {
            [wordStr appendString:@" "];
        }
        wordCount++;
    }
    if (wordCount != 12) {
        [self showError:LocalizedStr(@"text_mnemonicsError")];
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
    NSString *fixWordStr = [wordStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.sureBtn.userInteractionEnabled = NO;
    [self.view showLoadingIndicator];
    [FchainTool restoreWalletWithMnemonic:fixWordStr walletName:walletName password:pwdStr block:^(NSString * _Nonnull result) {
        [self.view hideLoadingIndicator];
        self.sureBtn.userInteractionEnabled = YES;
        if([result isNoEmpty]){
            if([User_manager loginWithUserName:result withPassword:pwdStr withPwTip:@"" withMnemonic:fixWordStr isBackup:YES]){
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
            [self showError:LocalizedStr(@"text_pleaseEnterCorrectMnemonicPhrase")];
        }
    }];
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
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
    UIView *mnemonicView = [[UIView alloc] init];
    mnemonicView.backgroundColor = [UIColor g_bgCardColor];
    [mnemonicView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:mnemonicView];
    self.mnemonicView = mnemonicView;
    [mnemonicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(84);
    }];
//    UIButton *advancedModeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [advancedModeBtn setTitle:LocalizedStr(@"text_advancedMode") forState:UIControlStateNormal];
//    [advancedModeBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
//    advancedModeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
//    [advancedModeBtn addTarget:self action:@selector(advanceModeAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:advancedModeBtn];
//    self.advancedModeBtn = advancedModeBtn;
//    [advancedModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(mnemonicView.mas_bottom).offset(12);
//        make.left.offset(35);
//        make.height.offset(20);
//    }];
//    UIView *advancedModeView = [[UIView alloc] init];
//    advancedModeView.backgroundColor = [UIColor g_bgColor];
//    advancedModeView.layer.cornerRadius = 8;
//    advancedModeView.layer.shadowColor = [UIColor g_shadowColor].CGColor;
//    advancedModeView.layer.shadowOffset = CGSizeMake(0, 2);
//    advancedModeView.layer.shadowRadius = 8;
//    advancedModeView.layer.shadowOpacity = 1;
//    advancedModeView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH-40, 84)].CGPath;
//    advancedModeView.hidden = !self.showAdvancedMode;
//    [self.contentView addSubview:advancedModeView];
//    self.advancedModeView = advancedModeView;
//    [advancedModeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(advancedModeBtn.mas_bottom).offset(15);
//        make.left.offset(20);
//        make.right.offset(-20);
//        make.height.mas_equalTo(self.showAdvancedMode?84:0);
//    }];
    UIView *walletNameView = [[UIView alloc] init];
    walletNameView.backgroundColor = [UIColor g_bgCardColor];
    [walletNameView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:walletNameView];
    self.walletNameView = walletNameView;
    [walletNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mnemonicView.mas_bottom).offset(15);
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
        make.left.offset(25);
        make.right.offset(-25);
        make.bottom.offset(-40);
    }];
    [self createMnemonicItems];
//    [self createAdvancedModeItems];
    [self createWalletNameItems];
    [self createPwdItems];
}
- (void)createMnemonicItems {
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = LocalizedStr(@"text_mnemonicWord");
    titleLb.font = [UIFont pw_mediumFontOfSize:20];
    titleLb.textColor = [UIColor g_boldTextColor];
    [self.mnemonicView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
    }];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setImage:[UIImage imageNamed:@"icon_info"] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mnemonicView addSubview:infoBtn];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb.mas_right).offset(5);
        make.centerY.equalTo(titleLb);
    }];
    self.mnemonicTF = [[UITextField alloc] init];
    [self.mnemonicTF pw_setPlaceholder:LocalizedStr(@"text_inputMnemonicWordTip")];
    self.mnemonicTF.font = [UIFont systemFontOfSize:14];
    self.mnemonicTF.textColor = [UIColor g_textColor];
    self.mnemonicTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.mnemonicTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.mnemonicView addSubview:self.mnemonicTF];
    [self.mnemonicTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(titleLb.mas_bottom).offset(0);
        make.bottom.offset(-5);
    }];
}
- (void)createAdvancedModeItems {
    if (self.advancedModeView==nil) {
        return;
    }
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = LocalizedStr(@"text_setWalletPath");
    titleLb.font = [UIFont pw_mediumFontOfSize:20];
    titleLb.textColor = [UIColor g_boldTextColor];
    [self.advancedModeView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
    }];
    self.walletPathTF = [[UITextField alloc] init];
    [self.walletPathTF pw_setPlaceholder:@"m/44’/60’/0’/0/0"];
    self.walletPathTF.font = [UIFont systemFontOfSize:14];
    self.walletPathTF.textColor = [UIColor g_textColor];
    self.walletPathTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.walletPathTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.advancedModeView addSubview:self.walletPathTF];
    [self.walletPathTF mas_makeConstraints:^(MASConstraintMaker *make) {
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
    self.pwdTF = [PW_ViewTool textFieldFont:[UIFont systemFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_setTradePwdTip")];
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
    self.againPwdTF = [PW_ViewTool textFieldFont:[UIFont systemFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputAgain")];
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
