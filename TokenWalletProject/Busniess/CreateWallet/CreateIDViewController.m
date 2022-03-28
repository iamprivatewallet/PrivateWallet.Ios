//
//  CreateIDViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/20.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CreateIDViewController.h"
#import "AddCurrencyViewController.h"

@interface CreateIDViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *createButton;

@property (nonatomic, strong) UITextField *ID_TF;
@property (nonatomic, strong) UITextField *pw_TF;
@property (nonatomic, strong) UITextField *repw_TF;
@property (nonatomic, strong) UITextField *pwRemind_TF;

@property (nonatomic, strong) UILabel *pwTipsLbl;

@end

@implementation CreateIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"" isWhiteBg:YES];
    [self makeViews];
    
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.view text:@"创建身份" textColor:COLOR(44, 43, 55) font:GCSFontRegular(16)];
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
        
    self.createButton = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"创建" titleFont:GCSFontRegular(16) enable:NO];
    [self.createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.createButton.layer.cornerRadius = 8;
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(CGFloatScale(45));
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight-20);
    }];
}

- (void)getTextFieldViewWithTopView:(UIView *)topView{
    NSArray *textList = @[@"身份名",@"密码",@"重复输入密码",@"密码提示（可选）"];
    UIView *lastView = nil;
    for (int i = 0; i<textList.count; i++) {

        UITextField *tf =  [ZZCustomView textFieldInitFrame:CGRectZero view:self.view placeholder:textList[i] delegate:self font:GCSFontRegular(14)];
        tf.backgroundColor = [UIColor im_inputBgColor];
        tf.layer.cornerRadius = 8;
        tf.layer.borderColor = [UIColor mp_lineGrayColor].CGColor;
        tf.layer.borderWidth = 1;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf addTarget:self action:@selector(tfChangeAction:) forControlEvents:UIControlEventEditingChanged];
        tf.tag = 10+i;
        
        [tf addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];

        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView?lastView.mas_bottom:topView.mas_bottom).offset(CGFloatScale(i==0?20:13));
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(CGFloatScale(50));
        }];
        
        if (i == 0) {
            self.ID_TF = tf;
        }else if(i == 1){
            tf.secureTextEntry = YES;
            self.pw_TF = tf;
        }else if(i == 2){
            tf.secureTextEntry = YES;
            self.repw_TF = tf;
            
        }else{
            self.pwRemind_TF = tf;
        }
        
        lastView = tf;
    }
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(showPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.repw_TF).offset(-10);
        make.centerY.equalTo(self.repw_TF);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.pwTipsLbl = [ZZCustomView labelInitWithView:self.view text:@"" textColor:[UIColor im_btnSelectColor] font:GCSFontRegular(10)];
    [self.pwTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pw_TF);
        make.top.equalTo(self.pw_TF.mas_bottom).offset(5);
    }];
}

- (void)touchDownAction:(UITextField *)sender{
    ToastHelper * th = [ToastHelper sharedToastHelper];
    if (sender == self.pw_TF) {

        if (self.pw_TF.text.length == 0) {
            [th showToast:NSStringWithFormat(@"该密码将作为身份下多链钱包的交易密码。\n%@不会存储密码，也无法帮你找回，请务必妥善\n保管密码。",APPName)];

            self.pwTipsLbl.text = @"不少于8位字符，建议混合大小写字母、数字、符号";

        }else{
            self.pwTipsLbl.text = NSStringWithFormat(@"%lu字符",(unsigned long)self.pw_TF.text.length);
        }
        [self.repw_TF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pwTipsLbl.mas_bottom).offset(11);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(CGFloatScale(50));
        }];
    }else{
        [th dismissToast];
        self.pwTipsLbl.text = @"";
        [self.repw_TF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pw_TF.mas_bottom).offset(13);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(CGFloatScale(50));
        }];
    }
}
//TextField ValueChanged
- (void)tfChangeAction:(UITextField *)sender{
    
    if (sender == self.pw_TF) {
        if (self.pw_TF.text.length == 0) {
            self.pwTipsLbl.text = @"不少于8位字符，建议混合大小写字母、数字、符号";

        }else{
            self.pwTipsLbl.text = NSStringWithFormat(@"%lu字符",(unsigned long)self.pw_TF.text.length);
        }
    }
    
    if (self.ID_TF.text.length > 0 && self.pw_TF.text.length > 0 && self.repw_TF.text.length > 0) {
        self.createButton.userInteractionEnabled = YES;
        self.createButton.backgroundColor = [UIColor im_btnSelectColor];
    }else{
        self.createButton.userInteractionEnabled = NO;
        self.createButton.backgroundColor = [UIColor im_btnUnSelectColor];
    }
}
-(void)showPasswordAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
        self.repw_TF.secureTextEntry = self.pw_TF.secureTextEntry = NO;
    }else{
        [sender setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
        self.repw_TF.secureTextEntry = self.pw_TF.secureTextEntry = YES;
    }
}

- (void)createButtonAction{
    if (self.pw_TF.text.length < 8) {
        return [self showAlertViewWithText:@"不少于8位字符，建议混合大小写字母、数字、符号" actionText:@"知道了"];
    }
    if (![self.pw_TF.text isEqualToString:self.repw_TF.text]) {
        return [self showAlertViewWithText:@"密码不一致" actionText:@"知道了"];
    }
    
    
    [self getMnemonic];
}

- (void)getMnemonic {
    [self.view showLoadingIndicator];
    //创建助记词
    [FchainTool generateMnemonicBlock:^(NSString * _Nonnull result) {
        [self.view hideLoadingIndicator];
        [self createWalletWithWordStr:result];
    }];
}
- (void)createWalletWithWordStr:(NSString *)wordStr{
    [User_manager loginWithUserName:self.ID_TF.text withPassword:self.pw_TF.text withPwTip:self.pwRemind_TF.text withMnemonic:wordStr isBackup:NO];
    [FchainTool genWalletsWithMnemonic:wordStr createList:@[@"ETH"] block:^(BOOL sucess) {
        if (sucess) {
            NSArray *list = [[WalletManager shareWalletManager] getWallets];
            if (list.count>0) {
                [User_manager updateChooseWallet:list[0]];
            }
            
            [self showSuccessMessage:@"创建成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AddCurrencyViewController *acVC = [[AddCurrencyViewController alloc] init];
                acVC.isFirstBackup = YES;
                [self.navigationController pushViewController:acVC animated:YES];
            });
        }
    }];
}

#pragma mark Delegate

//- (void)textFieldDidBeginEditing:(UITextField *)textField

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
