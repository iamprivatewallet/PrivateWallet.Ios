//
//  PW_AddImportWalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/12.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddImportWalletViewController.h"
#import "PW_ScanTool.h"

@interface PW_AddImportWalletViewController ()

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

@implementation PW_AddImportWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:NSStringWithFormat(LocalizedStr(@"text_importSomeWallet"),self.walletType) rightImg:@"icon_scan" rightAction:@selector(scanAction)];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.privateKeyTF.rac_textSignal,self.walletNameTF.rac_textSignal,self.pwdTF.rac_textSignal,self.againPwdTF.rac_textSignal] reduce:^id(NSString *privateKey,NSString *walletName,NSString *pwd,NSString *againPwd){
        return @(privateKey.length && walletName.length && pwd.length && againPwd.length);
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
    NSString *keyWordsStr = nil;
    if(self.importType==PW_ImportWalletTypePrivateKey){
        NSString *privateKeyStr = [self.privateKeyTF.text trim];
        if ([privateKeyStr isEmptyStr]) {
            [self showError:LocalizedStr(@"text_privateKeyInputError")];
            return;
        }
        keyWordsStr = privateKeyStr;
    }else if(self.importType==PW_ImportWalletTypeMnemonic){
        NSString *mnemonicStr = [self.privateKeyTF.text trim];
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
        keyWordsStr = wordStr;
    }
    NSString *pwdStr = self.pwdTF.text;
    NSString *walletName = [self.walletNameTF.text trim];
    if ([walletName isEmptyStr]) {
        [self showError:LocalizedStr(@"text_walletNameInputError")];
        return;
    }
    if (![pwdStr judgePassWordLegal]) {
        [self showError:LocalizedStr(@"text_pwdFormatError")];
        return;
    }
    if (pwdStr.length<8) {
        [self showError:LocalizedStr(@"text_pwdFormatError")];
        return;
    }
    if (![pwdStr isEqualToString:self.againPwdTF.text]) {
        [self showError:LocalizedStr(@"text_pwdDisagreeError")];
        return;
    }
    Wallet *wallet = [[Wallet alloc] init];
    wallet.walletPassword = pwdStr;
    wallet.walletPasswordTips = @"";
    wallet.type = self.walletType;
    if(self.importType==PW_ImportWalletTypePrivateKey){
        wallet.priKey = keyWordsStr;
        [self importPriKeyWithWallet:wallet];
    }else if(self.importType==PW_ImportWalletTypeMnemonic){
        wallet.mnemonic = keyWordsStr;
        [self importMnemonicWithWallet:wallet];
    }
}
- (void)importPriKeyWithWallet:(Wallet *)wallet{
    [self.view showLoadingIndicator];
    self.sureBtn.userInteractionEnabled = NO;
    [FchainTool importPrikeyFromModel:wallet errorType:^(NSString * _Nonnull errorType, BOOL sucess) {
        [self.view hideLoadingIndicator];
        self.sureBtn.userInteractionEnabled = YES;
        if (sucess) {
            [self showSuccess:LocalizedStr(@"text_importSuccess")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [self showError:errorType];
        }
    }];
}
- (void)importMnemonicWithWallet:(Wallet *)wallet{
    [self.view showLoadingIndicator];
    self.sureBtn.userInteractionEnabled = NO;
    [FchainTool importMnemonicFromModel:wallet errorType:^(NSString * _Nonnull errorType, BOOL sucess) {
        [self.view hideLoadingIndicator];
        self.sureBtn.userInteractionEnabled = YES;
        if (sucess) {
            [self showSuccess:LocalizedStr(@"text_importSuccess")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [self showError:errorType];
        }
    }];
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
    UIView *privateKeyView = [[UIView alloc] init];
    privateKeyView.backgroundColor = [UIColor g_bgColor];
    privateKeyView.layer.cornerRadius = 8;
    privateKeyView.layer.shadowColor = [UIColor g_shadowColor].CGColor;
    privateKeyView.layer.shadowOffset = CGSizeMake(0, 2);
    privateKeyView.layer.shadowRadius = 8;
    privateKeyView.layer.shadowOpacity = 1;
    privateKeyView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH-40, 84)].CGPath;
    [self.contentView addSubview:privateKeyView];
    self.privateKeyView = privateKeyView;
    [privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom).offset(35);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.mas_equalTo(84);
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
        make.top.equalTo(privateKeyView.mas_bottom).offset(15);
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
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureBtn setTitle:LocalizedStr(@"text_confirm") forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [sureBtn setTitleColor:[UIColor g_primaryTextColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 16;
    sureBtn.backgroundColor = [UIColor g_primaryColor];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdView.mas_bottom).offset(40);
        make.height.offset(55);
        make.left.offset(25);
        make.right.offset(-25);
        make.bottom.offset(-40);
    }];
    [self createPrivateKeyItems];
    [self createWalletNameItems];
    [self createPwdItems];
}
- (void)createPrivateKeyItems {
    UILabel *titleLb = [[UILabel alloc] init];
    if(self.importType==PW_ImportWalletTypePrivateKey){
        titleLb.text = LocalizedStr(@"text_privateKey");
    }else if(self.importType==PW_ImportWalletTypeMnemonic){
        titleLb.text = LocalizedStr(@"text_mnemonicWord");
    }
    titleLb.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    titleLb.textColor = [UIColor g_boldTextColor];
    titleLb.layer.opacity = 0.7;
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
    if(self.importType==PW_ImportWalletTypePrivateKey){
        [self.privateKeyTF pw_setPlaceholder:LocalizedStr(@"text_inputPrivateKeyTip")];
    }else if(self.importType==PW_ImportWalletTypeMnemonic){
        [self.privateKeyTF pw_setPlaceholder:LocalizedStr(@"text_inputMnemonicWordTip")];
    }
    self.privateKeyTF.font = [UIFont systemFontOfSize:14];
    self.privateKeyTF.textColor = [UIColor g_textColor];
    self.privateKeyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.privateKeyTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.privateKeyView addSubview:self.privateKeyTF];
    [self.privateKeyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-15);
        make.top.equalTo(titleLb.mas_bottom).offset(0);
        make.height.offset(50);
    }];
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

@end
