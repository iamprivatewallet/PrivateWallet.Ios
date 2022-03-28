//
//  RecoveryViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/20.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "RecoveryIDViewController.h"
#import "AddCurrencyViewController.h"

@interface RecoveryIDViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *howInputButton;
@property (nonatomic, strong) UIButton *recoveryButton;
@property (nonatomic, strong) UILabel *placeholder_tv;

@property (nonatomic, copy) NSString *mnemonicStr;
@property (nonatomic, copy) NSString *pwStr;
@property (nonatomic, copy) NSString *repwStr;
@property (nonatomic, copy) NSString *pwRemindStr;

@property (nonatomic, strong) UITextField *repw_TF;


@end



@implementation RecoveryIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"" isWhiteBg:YES];
    [self makeViews];
    
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.view text:@"恢复身份" textColor:COLOR(44, 43, 55) font:GCSFontRegular(16)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
    UILabel *detailTitleLbl = [ZZCustomView labelInitWithView:self.view text:@"你将会拥有身份下的多链钱包，比如ETH、BSC、HECO..." textColor:[UIColor im_textColor_six] font:GCSFontRegular(14)];
    detailTitleLbl.numberOfLines = 0;
    [detailTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(titleLbl.mas_bottom);
    }];
    
    [self getTextFieldViewWithTopView:detailTitleLbl];
    
    self.recoveryButton = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"创建" titleFont:GCSFontRegular(16) enable:NO];
    [self.recoveryButton addTarget:self action:@selector(recoveryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.recoveryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(CGFloatScale(45));
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight-20);
    }];
    
    self.howInputButton = [ZZCustomView buttonInitWithView:self.view title:@" 如何导入私钥/Keystore" titleColor:[UIColor im_blueColor] titleFont:GCSFontRegular(13)];
    [self.howInputButton setImage:ImageNamed(@"help") forState:UIControlStateNormal];
    [self.howInputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.recoveryButton.mas_top).offset(-CGFloatScale(20));
    }];
}

- (void)getTextFieldViewWithTopView:(UIView *)topView {
    NSArray *textList = @[@"输入助记词单词，并使用空格分隔",@"密码",@"重复输入密码",@"密码提示（可选）"];
    UIView *lastView = nil;
    for (int i = 0; i<textList.count; i++) {
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor navAndTabBackColor];
        bg.layer.cornerRadius = 7;
        bg.layer.borderColor = [UIColor im_borderLineColor].CGColor;
        bg.layer.borderWidth = 1;
        [self.view addSubview:bg];
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView?lastView.mas_bottom:topView.mas_bottom).offset(CGFloatScale(i==0?20:13));
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(CGFloatScale(i==0?100:50));
        }];
        if (i == 0) {
            UITextView *textView = [ZZCustomView textViewInitFrame:CGRectZero view:bg delegate:self font:GCSFontRegular(14) textColor:[UIColor im_textColor_three]];
            textView.delegate = self;
            textView.backgroundColor = [UIColor navAndTabBackColor];
            textView.textContentType = UITextContentTypePassword;
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(bg).offset(-15);
                make.left.equalTo(bg).offset(15);
                make.top.equalTo(bg).offset(12);
                make.bottom.equalTo(bg).offset(-12);
            }];
            self.placeholder_tv = [ZZCustomView labelInitWithView:textView text:textList[i] textColor:[UIColor im_inputPlaceholderColor] font:GCSFontRegular(14)];
            [self.placeholder_tv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(textView).offset(5);
                make.top.equalTo(textView).offset(7);
            }];
        }else{
            UITextField *tf =  [ZZCustomView textFieldInitFrame:CGRectZero view:bg placeholder:textList[i] delegate:nil font:GCSFontRegular(14)];
            tf.tag = 10+i;
            if (i == 1 || i == 2) {
                tf.secureTextEntry = YES;
            }
            [tf addTarget:self action:@selector(tfChangeAction:) forControlEvents:UIControlEventEditingChanged];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(bg).offset(-(i == 2)?50:20);
                make.left.equalTo(bg).offset(20);
                make.top.bottom.equalTo(bg);
            }];
            if (i == 2) {
                self.repw_TF = tf;
                UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [eyeBtn setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
                [eyeBtn addTarget:self action:@selector(showPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
                [bg addSubview:eyeBtn];
                [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bg).offset(-10);
                    make.centerY.equalTo(bg);
                    make.size.mas_equalTo(CGSizeMake(30, 30));
                }];
            }
        }
        
        lastView = bg;

    }
    
    
}

- (void)tfChangeAction:(UITextField *)sender{
     if (sender.tag == 11) {
        self.pwStr = sender.text;
    }else if (sender.tag == 12) {
        self.repwStr = sender.text;
    }else{
        self.pwRemindStr = sender.text;
    }
    if (self.mnemonicStr.length > 0 && self.pwStr.length > 0 && self.repwStr.length > 0) {
        self.recoveryButton.userInteractionEnabled = YES;
        self.recoveryButton.backgroundColor = [UIColor im_btnSelectColor];
    }
}

-(void)showPasswordAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
        self.repw_TF.secureTextEntry = NO;
        self.repw_TF.userInteractionEnabled = YES;
    }else{
        [sender setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
        self.repw_TF.secureTextEntry = YES;
        self.repw_TF.userInteractionEnabled = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeholder_tv.hidden = YES;
    }else{
        self.placeholder_tv.hidden = NO;
    }
    self.mnemonicStr = textView.text;
}

- (void)recoveryButtonAction{ //暂时放这里，有更多币种，放选择币种页添加钱包
    NSInteger wordCount = 0;
    NSArray *array = [self.mnemonicStr componentsSeparatedByString:@" "];
    NSMutableString *wordStr = [[NSMutableString alloc] init];
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
        [[ToastHelper sharedToastHelper] toast:@"请正确填写助记词"];
        return;
    }
    if (![self.pwStr isEqualToString:self.repwStr]) {
        return [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"知道了"];
    }
//    if (self.pwStr.length < 8) {
//        return [self showAlertViewWithTitle:@"" text:@"不少于8位字符，建议混合大小写字母、数字、符号" actionText:@"知道了"];
//    }
    //检查助记词
    if (self.mnemonicStr.length <= 0) {
        [[ToastHelper sharedToastHelper] toast:@"请正确填写助记词"];
        return;
    }

    NSString *fixWordStr = [wordStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.recoveryButton.userInteractionEnabled = NO;
    [self.view showLoadingIndicator];
    [FchainTool restoreWalletWithMnemonic:fixWordStr password:self.pwStr block:^(NSString * _Nonnull result) {
        [self.view hideLoadingIndicator];
        self.recoveryButton.userInteractionEnabled = YES;
        [self showSuccessMessage:@"成功"];
        [User_manager loginWithUserName:result withPassword:self.pwStr withPwTip:self.pwRemindStr withMnemonic:self.mnemonicStr isBackup:YES];
        NSArray *list = [[WalletManager shareWalletManager] getWallets];
        if (list.count>0) {
            [User_manager updateChooseWallet:list[0]];
        }
        AddCurrencyViewController *acVC = [[AddCurrencyViewController alloc] init];
        acVC.isRecoveryPage = YES;
        [self.navigationController pushViewController:acVC animated:YES];
    }];
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
