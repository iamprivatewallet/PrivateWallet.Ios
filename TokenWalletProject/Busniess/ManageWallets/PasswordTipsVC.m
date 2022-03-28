//
//  PasswordTipsVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "PasswordTipsVC.h"

@interface PasswordTipsVC ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *hidePWBtn;
@property (nonatomic, strong) UIButton *rightNavBtn;

@end

@implementation PasswordTipsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"密码提示"];
    [self makeViews];
    
    if (self.wallet) {
        self.textField.text = self.wallet.walletPasswordTips;

    }else{
        self.textField.text = User_manager.currentUser.user_pass_tip;

    }
        // Do any additional setup after loading the view.
}
- (void)rightNavItemAction{
    
    User_manager.currentUser.user_pass_tip = self.textField.text;
    [User_manager saveTask];
    //修改成功
    [self showSuccessMessage:@"修改成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
- (void)textFieldChangeValueAction:(UITextField *)sender{
    [self.rightNavBtn setTitleColor:[UIColor im_textColor_three] forState:UIControlStateNormal];
    self.rightNavBtn.userInteractionEnabled = YES;
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor im_tableBgColor];
    self.rightNavBtn = [ZZCustomView buttonInitWithView:self.naviBar title:@"完成" titleColor:COLORA(0, 0, 0, 0.2) titleFont:GCSFontRegular(14)];
    self.rightNavBtn.userInteractionEnabled = NO;
    [self.rightNavBtn addTarget:self action:@selector(rightNavItemAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.naviBar addSubview:self.rightNavBtn];
    [self.rightNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar).offset(-12);
        make.bottom.equalTo(self.naviBar).offset(-10);
    }];
    
    UIView *tf_bgView = [[UIView alloc] init];
    tf_bgView.backgroundColor = [UIColor whiteColor];
    tf_bgView.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    tf_bgView.layer.borderWidth = 1;
    [self.view addSubview:tf_bgView];
    [tf_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight+CGFloatScale(20));
        make.height.mas_equalTo(CGFloatScale(55));
    }];
    
    self.textField = [ZZCustomView textFieldInitFrame:CGRectZero view:tf_bgView placeholder:@"" delegate:nil font:GCSFontRegular(12)];
    [self.textField addTarget:self action:@selector(textFieldChangeValueAction:) forControlEvents:UIControlEventEditingChanged];
    self.textField.secureTextEntry = YES;
    self.textField.userInteractionEnabled = NO;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tf_bgView).offset(20);
        make.right.equalTo(tf_bgView).offset(-55);
        make.top.bottom.equalTo(tf_bgView);
    }];
    
    self.hidePWBtn = [ZZCustomView buttonInitWithView:tf_bgView imageName:@"hideAssets"];
    [self.hidePWBtn addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.hidePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tf_bgView).offset(-20);
        make.centerY.equalTo(tf_bgView);
        make.width.height.mas_equalTo(CGFloatScale(25));
    }];
}
- (void)hideButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.hidePWBtn setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
        self.textField.secureTextEntry = NO;
        self.textField.userInteractionEnabled = YES;
    }else{
        [self.hidePWBtn setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
        self.textField.secureTextEntry = YES;
        self.textField.userInteractionEnabled = NO;
    }
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
