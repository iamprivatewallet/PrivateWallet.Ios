//
//  TokenAlertView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TokenAlertView.h"

@interface ImAlertView :UIView

@property (nonatomic, copy)   void(^buttonClickIndex)(NSInteger,NSString *);
@property (nonatomic, strong) UIButton *hidePWBtn;
@property (nonatomic, strong) UITextField *textField;

@end
@implementation ImAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message textField_p:(NSString *)tf_placehoder keyboardType:(UIKeyboardType)keyboardType isPassword:(BOOL)isPassword buttonTitlesArray:(NSArray *)buttonTitles  action:(void(^)(NSInteger index, NSString *text))action{
    self = [super init];
    if (self) {
        self.backgroundColor = COLOR(248, 248, 248);
        self.layer.cornerRadius = kRealValue(14);
        self.buttonClickIndex = action;
        if (message) {
            //有副标题
            [self setUpWithTitle:title message:message textField_p:tf_placehoder buttonTitles:buttonTitles];
        }else{
            [self setUpWithTitle:title textField_p:tf_placehoder keyboardType:keyboardType isPassword:isPassword buttonTitles:buttonTitles];
        }
    }
    return self;
}

- (void)setUpWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder keyboardType:(UIKeyboardType)keyboardType isPassword:(BOOL)isPassword buttonTitles:(NSArray *)buttonTitles {
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self text:title textColor:[UIColor im_textColor_three] font:GCSFontMedium(18)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    UIView *tf_bgView = [[UIView alloc] init];
    tf_bgView.backgroundColor = COLOR(249, 250, 251);
    tf_bgView.layer.cornerRadius = 10;
    tf_bgView.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    tf_bgView.layer.borderWidth = 1;
    [self addSubview:tf_bgView];
    [tf_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(titleLbl.mas_bottom).offset(isPassword?10:25);
        make.height.mas_equalTo(CGFloatScale(45));
    }];
    
    self.textField = [ZZCustomView textFieldInitFrame:CGRectZero view:tf_bgView placeholder:tf_placehoder delegate:nil font:GCSFontRegular(14)];
    self.textField.keyboardType = keyboardType;
    [self.textField becomeFirstResponder];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tf_bgView).offset(12);
        make.right.equalTo(tf_bgView).offset(-35);
        make.top.bottom.equalTo(tf_bgView);
    }];
    if (isPassword) {//是否是密码框
        self.textField.secureTextEntry = YES;
        self.hidePWBtn = [ZZCustomView buttonInitWithView:tf_bgView imageName:@"hideAssets"];
        [self.hidePWBtn addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.hidePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tf_bgView).offset(-10);
            make.centerY.equalTo(tf_bgView);
            make.width.height.mas_equalTo(CGFloatScale(20));
        }];
    }
   
    [self creatButtonWithTitles:buttonTitles topView:self.textField];
}

- (void)setUpWithTitle:(NSString *)title message:(NSString *)message textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles {

    UILabel *titleLbl = [ZZCustomView labelInitWithView:self text:title textColor:[UIColor blackColor] font:GCSFontRegular(18)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(25);

    }];
    UILabel *messageLbl = [ZZCustomView labelInitWithView:self text:message textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    messageLbl.numberOfLines = 0;
    [messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(titleLbl.mas_bottom).offset(12);
        make.height.mas_equalTo(40);
    }];
    
    UIView *tf_bgView = [[UIView alloc] init];
    tf_bgView.backgroundColor = COLOR(249, 250, 251);
    tf_bgView.layer.cornerRadius = 10;
    tf_bgView.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    tf_bgView.layer.borderWidth = 1;
    [self addSubview:tf_bgView];
    [tf_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(messageLbl.mas_bottom).offset(10);
        make.height.mas_equalTo(CGFloatScale(45));
    }];
    
    self.textField = [ZZCustomView textFieldInitFrame:CGRectZero view:tf_bgView placeholder:tf_placehoder delegate:nil font:GCSFontRegular(14)];
    self.textField.secureTextEntry = YES;
    [self.textField becomeFirstResponder];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tf_bgView).offset(12);
        make.right.equalTo(tf_bgView).offset(-35);
        make.top.bottom.equalTo(tf_bgView);
    }];
    
    self.hidePWBtn = [ZZCustomView buttonInitWithView:tf_bgView imageName:@"hideAssets"];
    [self.hidePWBtn addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.hidePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tf_bgView).offset(-10);
        make.centerY.equalTo(tf_bgView);
        make.width.height.mas_equalTo(CGFloatScale(20));
    }];
    [self creatButtonWithTitles:buttonTitles topView:tf_bgView];
}

- (void)creatButtonWithTitles:(NSArray *)titleArray topView:(UIView *)topView{
    
    UIView *line_h = [[UIView alloc] init];
    line_h.backgroundColor = [UIColor mp_lineGrayColor];
    [self addSubview:line_h];
    [line_h mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.mas_bottom).offset(-CGFloatScale(45));
    }];
    if (titleArray.count == 2) {
        //2个按钮 单独处理 左右分布
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *item = [ZZCustomView buttonInitWithView:self title:obj titleColor:[UIColor im_textBlueColor] titleFont:GCSFontRegular(16)];
            item.tag = idx;
            [item addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(idx == 0? self :self.mas_centerX);
                make.right.equalTo(idx == 0? self.mas_centerX :self);
                make.bottom.equalTo(self);
                make.top.equalTo(topView.mas_bottom).offset(20);
                make.height.mas_equalTo(CGFloatScale(45));
            }];
        }];
        
        UIView *line_v = [[UIView alloc] init];
        line_v.backgroundColor = [UIColor mp_lineGrayColor];
        [self addSubview:line_v];
        [line_v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.equalTo(line_h);
            make.bottom.equalTo(self);
            make.left.equalTo(self.mas_centerX);
        }];
    }else {
       
    }
    
}

- (void)hideButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.hidePWBtn setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
        self.textField.secureTextEntry = NO;

    }else{
        [self.hidePWBtn setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
        self.textField.secureTextEntry = YES;

    }
}

- (void)messageButtonsEvent:(UIButton *)button {
    if (button.tag == 0) {
        [self dismiss:NO];
    }else{
        if (self.buttonClickIndex) {
            self.buttonClickIndex(button.tag,self.textField.text);
            [self dismiss:NO];
        }
    }
}

- (BOOL)isInputTextField{
    if (!self.textField.text || [self.textField.text isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [self.superview removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
        
    }];
    
}

@end
@implementation TokenAlertView
+ (void)showViewWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder action:(void(^)(NSInteger index,NSString *inputText))action{
    [TokenAlertView showWithTitle:title textField_p:tf_placehoder buttonTitles:@[@"取消",@"确认"] isPassword:NO action:action];
}
+ (void)showViewWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder keyboardType:(UIKeyboardType)keyboardType action:(void(^)(NSInteger index,NSString *inputText))action{
    [TokenAlertView showWithTitle:title textField_p:tf_placehoder buttonTitles:@[@"取消",@"确认"] keyboardType:keyboardType isPassword:NO action:action];
}
+ (void)showInputPasswordWithTitle:(NSString *)title ViewWithAction:(void(^)(NSInteger index,NSString *inputText))action{
    [TokenAlertView showWithTitle:title textField_p:@"密码" buttonTitles:@[@"取消",@"确认"] isPassword:YES action:action];
}
+ (void)showWithTitle:(NSString *)title  textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles isPassword:(BOOL)isPassword action:(void(^)(NSInteger index,NSString *inputText))action{
    [TokenAlertView showWithTitle:title textField_p:tf_placehoder buttonTitles:@[@"取消",@"确认"] keyboardType:0 isPassword:isPassword action:action];
}
+ (void)showWithTitle:(NSString *)title  textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles keyboardType:(UIKeyboardType)keyboardType isPassword:(BOOL)isPassword action:(void(^)(NSInteger index,NSString *inputText))action{
    TokenAlertView *backView = nil;
    [SVProgressHUD dismiss];
    for (TokenAlertView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[TokenAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    ImAlertView *alertView1 = [[ImAlertView alloc] initWithTitle:title message:nil textField_p:tf_placehoder keyboardType:keyboardType isPassword:isPassword buttonTitlesArray:buttonTitles action:action];
    [backView addSubview:alertView1];
    [alertView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(CGFloatScale(28));
        make.right.equalTo(backView).offset(-CGFloatScale(28));
        make.bottom.equalTo(backView.mas_centerY).offset(-CGFloatScale(50));
//        make.height.mas_equalTo(CGFloatScale(200));
    }];
    
    alertView1.transform = CGAffineTransformMakeTranslation(0, 600);

    [UIView animateWithDuration:0.2 animations:^{
        alertView1.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}
+ (void)showWithTitle:(NSString *)title message:(NSString *)message textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles action:(void(^)(NSInteger index,NSString *inputText))action{
    [self showWithTitle:title message:message textField_p:tf_placehoder buttonTitles:buttonTitles keyboardType:0 action:action];
}
+ (void)showWithTitle:(NSString *)title message:(NSString *)message textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles keyboardType:(UIKeyboardType)keyboardType action:(void(^)(NSInteger index,NSString *inputText))action{
    TokenAlertView *backView = nil;
    [SVProgressHUD dismiss];
    for (TokenAlertView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[TokenAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    ImAlertView *alertView1 = [[ImAlertView alloc] initWithTitle:title message:message textField_p:tf_placehoder keyboardType:keyboardType isPassword:NO buttonTitlesArray:buttonTitles action:action];
    [backView addSubview:alertView1];
    [alertView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(CGFloatScale(28));
        make.right.equalTo(backView).offset(-CGFloatScale(28));
        make.bottom.equalTo(backView.mas_centerY).offset(-CGFloatScale(50));
//        make.height.mas_equalTo(CGFloatScale(200));
    }];
    
    alertView1.transform = CGAffineTransformMakeTranslation(0, 600);

    [UIView animateWithDuration:0.3 animations:^{
        alertView1.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    
}

@end
