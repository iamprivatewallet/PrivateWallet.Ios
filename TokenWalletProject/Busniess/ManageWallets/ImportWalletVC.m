//
//  ImportWalletViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/4.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ImportWalletVC.h"

@interface ImportWalletVC ()
<
UITextFieldDelegate,
UITextViewDelegate,
WKUIDelegate,
WKNavigationDelegate,
WBQRCodeDelegate
>
@property (nonatomic, copy) NSString *keyWordsStr;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic, copy) NSString *pwTipsStr;

@property (nonatomic, strong) NSString *placeholderStr;;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIButton *ensureBtn;
@property (nonatomic, strong) UITextField *repassword_TF;
@property (nonatomic, strong) UITextView *keyWord_TV;

@property (nonatomic, strong) WKWebView *webView;


@end

@implementation ImportWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:NSStringWithFormat(@"导入%@钱包",self.walletTypeStr) rightImg:@"scan" rightAction:@selector(navRightItemAction)];
    [self createWebView];

    [self makeViews];

}
- (void)navRightItemAction{
    //扫描
    if (![CATCommon isHaveAuthorForCamer]) {
        return;
    }
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    WBVC.delegate = self;
    WBVC.zh_showCustomNav = YES;
    [UITools QRCodeFromVC:self scanVC:WBVC];
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [bottomView addSubview:self.ensureBtn];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.right.equalTo(bottomView).offset(-10);
        make.top.equalTo(bottomView).offset(10);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.ensureBtn.mas_top).offset(-10);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        
    }];
    self.webView = [[WKWebView alloc] init];
    [self.view addSubview:self.webView];
    self.webView .UIDelegate = self;
    self.webView .navigationDelegate = self;
}
- (void)hiddenPwAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.repassword_TF.secureTextEntry = NO;
        [sender setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
    }else{
        self.repassword_TF.secureTextEntry = YES;
        [sender setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
    }
    
}
- (void)textFieldAction:(UITextField *)sender{
   
    if (sender.tag == 10) {
        self.passwordStr = sender.text;
    }else if (sender.tag == 12) {
        self.pwTipsStr = sender.text;
    }
    BOOL btnStatus;
    if (self.importType == kImportWalletTypeKeystore) {
        btnStatus = self.keyWordsStr.length>0 && self.passwordStr.length>0;
    }else{
        btnStatus = self.keyWordsStr.length>0 && self.passwordStr.length>0 && self.repassword_TF.text.length>0;
    }
    if (btnStatus) {
        self.ensureBtn.userInteractionEnabled = YES;
        self.ensureBtn.backgroundColor = [UIColor im_btnSelectColor];
    }else{
        self.ensureBtn.backgroundColor = [UIColor im_btnUnSelectColor];

    }
}

- (void)importKeystoreWallet{
    if (![self.keyWordsStr isNoEmpty]) {
        return [self showAlertViewWithText:@"请输入Keystore" actionText:@"好"];
    }
    if (self.passwordStr.length < 8) {
        return [self showAlertViewWithText:@"不少于8位字符，建议混合大小写字母、数字、符号" actionText:@"知道了"];
    }
    
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *pathURL = [NSURL fileURLWithPath:bundleStr];
    if (@available(iOS 9.0, *)) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:pathURL]];
    }
    
}

- (void)importButtonAction{
    if (self.importType != kImportWalletTypeKeystore) {
        [self importWordsWallet];
    }else{
        [self importKeystoreWallet];
    }
}

- (void)importWordsWallet{
    //导入钱包
    if (![self.keyWordsStr isNoEmpty]) {
        NSString *alertStr = @"请输入私钥";
        if (self.importType == kImportWalletTypeMnemonic) {
            alertStr = @"请输入助记词";
        }
        return [self showAlertViewWithText:alertStr actionText:@"好"];
    }
    
    if (![self.passwordStr isEqualToString:self.repassword_TF.text]) {
        return [self showAlertViewWithText:@"密码不一致" actionText:@"好"];
    }
    if (self.passwordStr.length < 8) {
        return [self showAlertViewWithText:@"不少于8位字符，建议混合大小写字母、数字、符号" actionText:@"知道了"];
    }
    
    if (self.importType == kImportWalletTypeMnemonic) {
        NSArray *wordList = [self.keyWordsStr componentsSeparatedByCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]];
        if (wordList.count != 12) {
            return [self showAlertViewWithText:@"请输入正确的助记词" actionText:@"知道了"];
        }
    }else{
        if (self.keyWordsStr.length != 64 && self.importType == kImportWalletTypePrivateKey) {
            return [self showAlertViewWithText:@"请输入正确的私钥" actionText:@"知道了"];
        }
    }
    
    self.ensureBtn.userInteractionEnabled = NO;
    Wallet *wallet = [[Wallet alloc] init];
    wallet.walletPassword = self.passwordStr;
    wallet.walletPasswordTips = self.pwTipsStr;
    wallet.type = self.walletTypeStr;
    if (self.importType == kImportWalletTypeMnemonic) {
        //助记词导入
        wallet.mnemonic = self.keyWordsStr;
        [self importMnemonicWithWallet:wallet];
    }else if (self.importType == kImportWalletTypePrivateKey) {
        //私钥导入
        wallet.priKey = self.keyWordsStr;
        [self importPriKeyWithWallet:wallet];
    }
   
}
//根据KeyStore导入钱包，根据webView的js代理
- (void)createWebView{
    
}
- (void)importPriKeyWithWallet:(Wallet *)wallet{
    [FchainTool importPrikeyFromModel:wallet errorType:^(NSString * _Nonnull errorType, BOOL sucess) {
        self.ensureBtn.userInteractionEnabled = YES;
        if (sucess) {
            [self showSuccessMessage:@"导入成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [UITools showToast:errorType];
        }
    }];
}
- (void)importMnemonicWithWallet:(Wallet *)wallet{
    [FchainTool importMnemonicFromModel:wallet errorType:^(NSString * _Nonnull errorType, BOOL sucess) {
        self.ensureBtn.userInteractionEnabled = YES;
        if (sucess) {
            [self showSuccessMessage:@"导入成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [UITools showToast:errorType];
        }
    }];
}

#pragma mark delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.importType == kImportWalletTypeKeystore) {
        return 2;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.importType == kImportWalletTypeKeystore) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"importCell";
    NSInteger index;
    if (indexPath.section == 0) {
        index = 0;
    }else if (indexPath.section == 1) {
        index = indexPath.row;
    }else{
        index = indexPath.row+2;
    }
    [self makePlaceHolderStrWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [self makeContentViewsWithIndexPath:indexPath cell:cell index:index];
    }
    
    UITextField *textField = [cell.contentView viewWithTag:10+index];
    
    
    [textField im_setPlaceholder:self.placeholderStr];
    
    if (indexPath.section == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth*2);

    }
    
    if (self.importType == kImportWalletTypeKeystore) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth*2);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (self.importType == kImportWalletTypeKeystore) {
            return CGFloatScale(150);
        }
        return CGFloatScale(90);
    }else{
        return CGFloatScale(50);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFloatScale(40);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]init];
    
    UILabel *titleLabel = [ZZCustomView labelInitWithView:bgView text:@"" textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(8);
        make.bottom.equalTo(bgView).offset(-8);
    }];
   
    switch (section) {
        case 0:{
            if (self.importType == kImportWalletTypeKeystore) {
                titleLabel.text = @"Keystore";
            }else if(self.importType == kImportWalletTypePrivateKey){
                titleLabel.text = @"私钥";
            }else{
                titleLabel.text = @"助记词";
            }
            UIImageView *icon = [ZZCustomView imageViewInitView:bgView imageName:@"suggested"];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel.mas_right).offset(5);
                make.centerY.equalTo(titleLabel);
                make.width.height.mas_equalTo(15);
            }];
        }
            break;
        case 1:{
            titleLabel.text = @"密码";
        }
            break;
        case 2:{
            titleLabel.text = @"密码提示";
        }
            break;
    }
    
    return bgView;
}


- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length>0){
        self.placeHolderLabel.hidden = YES;
    }else{
        self.placeHolderLabel.hidden = NO;
    }
    self.keyWordsStr = textView.text;
}
- (void)makePlaceHolderStrWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.importType == kImportWalletTypePrivateKey) {
            self.placeholderStr = @"输入明文私钥";

        }else if (self.importType == kImportWalletTypeMnemonic){
            self.placeholderStr = @"输入助记词单词，并使用空格分隔";

        }else{
            self.placeholderStr = @"Keystore文件内容";
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            self.placeholderStr = @"钱包密码";
        }else{
            self.placeholderStr = @"重复输入密码";
        }
    }else{
        self.placeholderStr = @"选填";
    }
}
- (void)makeContentViewsWithIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell index:(NSInteger)index{
   
    if (indexPath.section == 0 ) {
       
        UITextView *textView = [ZZCustomView textViewInitFrame:CGRectZero view:cell.contentView delegate:self font:GCSFontMedium(14) textColor:[UIColor blackColor]];
        textView.tag = 20+index;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.top.equalTo(cell.contentView).offset(8);
            make.bottom.equalTo(cell.contentView).offset(-8);
            make.right.equalTo(cell.contentView).offset(-20);
        }];
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.text = self.placeholderStr;
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.font = GCSFontMedium(14);
        self.placeHolderLabel.textColor = [UIColor im_inputPlaceholderColor];
        [textView addSubview:self.placeHolderLabel];
        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textView).offset(5);
            make.top.equalTo(textView).offset(7);
        }];
        self.keyWord_TV = textView;
    }else{
        UITextField *textField = [[UITextField alloc] init];
        if (indexPath.section == 1) {
            if (indexPath.row ==1) {
                self.repassword_TF = textField;
            }
            textField.secureTextEntry = YES;
        }
        
        textField.tag = 10+index;
        textField.delegate = self;
        textField.font = GCSFontMedium(14);
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-45);
        }];
    }
    
    if (indexPath.section == 1 ) {
        if (indexPath.row == 1 || self.importType == kImportWalletTypeKeystore) {
            UIButton *hiddenBtn = [ZZCustomView buttonInitWithView:cell.contentView imageName:@"hideAssets"];
            [hiddenBtn addTarget:self action:@selector(hiddenPwAction:) forControlEvents:UIControlEventTouchUpInside];
            [hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-20);
                make.centerY.equalTo(cell.contentView);
                make.width.height.mas_equalTo(22);
            }];
        }
        
    }
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *keystoreJs;
    if ([self.walletTypeStr isEqualToString:@"CVN"]) {
        keystoreJs = NSStringWithFormat(@"wraperImportKeystore(\"%@\",\"%@\")",[CATCommon JSONString:self.keyWordsStr],self.passwordStr);
    }else{
        keystoreJs = NSStringWithFormat(@"JSON.stringify(web3.eth.accounts.decrypt('%@','%@'))",self.keyWordsStr,self.passwordStr);

    }
    [webView evaluateJavaScript:keystoreJs completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSDictionary *dic = [CATCommon JSONTurnDict:response];
            Wallet *wallet = [[Wallet alloc] init];
            wallet.walletPassword = self.passwordStr;
            wallet.walletPasswordTips = self.pwTipsStr;
            wallet.type = self.walletTypeStr;
            wallet.priKey = [dic[@"privateKey"] formatDelEth];
            [self importPriKeyWithWallet:wallet];
        }
        
    }];
}

//MARK: WBQRCodeDelegate
- (void)scanNoPopWithResult:(NSString*)result{
    self.keyWord_TV.text = result;
}

- (UIButton *)ensureBtn{
    if (!_ensureBtn) {
        _ensureBtn = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"确认" titleFont:GCSFontRegular(16) enable:NO];
        [_ensureBtn addTarget:self action:@selector(importButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _ensureBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
