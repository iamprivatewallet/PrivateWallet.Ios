//
//  PW_TipTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TipTool.h"

@implementation PW_TipTool

+ (void)showBackupTipSureBlock:(void (^)(void))block {
    [self showBackupTipDesc:LocalizedStr(@"text_backupAlertDesc") sureBlock:block];
}
+ (void)showBackupTipPrivateKeySureBlock:(void (^)(void))block {
    [self showBackupTipDesc:LocalizedStr(@"text_backupAlertPrivateKeyDesc") sureBlock:block];
}
+ (void)showBackupTipDesc:(NSString *)desc sureBlock:(void (^)(void))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [self showTipView:contentView];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    __weak typeof(view) weakView = view;
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
    }];
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:@"icon_noPhoto_big"];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(38);
        make.centerX.offset(0);
        make.height.offset(108);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_backupAlertTitle") fontSize:21 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom);
        make.centerX.offset(0);
        make.right.offset(-10);
    }];
    UILabel *descLb = [PW_ViewTool labelMediumText:desc fontSize:14 textColor:[UIColor g_grayTextColor]];
    descLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(10);
        make.centerX.offset(0);
        make.right.offset(-10);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_myUnderstand") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if(block){
            block();
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLb.mas_bottom).offset(24);
        make.centerX.offset(0);
        make.width.offset(200);
        make.height.offset(55);
        make.bottom.offset(-120);
    }];
    [self showAnimationContentView:contentView];
}
+ (void)showPayPwdSureBlock:(void (^)(NSString *pwd))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [self showTipView:contentView];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_payCheck") fontSize:17 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.left.offset(26);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    __weak typeof(view) weakView = view;
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
    }];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_secretKey_big"]];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.centerX.offset(0);
    }];
    UIView *pwdView = [[UIView alloc] init];
    pwdView.backgroundColor = [UIColor g_grayBgColor];
    [pwdView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [contentView addSubview:pwdView];
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom).offset(20);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
    }];
    UITextField *pwdTF = [[UITextField alloc] init];
    pwdTF.font = [UIFont pw_semiBoldFontOfSize:14];
    [pwdTF pw_setPlaceholder:LocalizedStr(@"text_inputTradePwd")];
    pwdTF.textColor = [UIColor g_textColor];
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.secureTextEntry = YES;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        CGFloat duration = [x.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect frame = [x.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [UIView animateWithDuration:duration animations:^{
            contentView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        CGFloat duration = [x.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            contentView.transform = CGAffineTransformIdentity;
        }];
    }];
//    NSNotification *showNoti = [NSNotification notificationWithName:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addNotification:showNoti block:^(NSNotification * _Nonnull notification) {
//        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//        CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        [UIView animateWithDuration:duration animations:^{
//            contentView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
//        }];
//    }];
//    NSNotification *hideNoti = [NSNotification notificationWithName:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addNotification:hideNoti block:^(NSNotification *notification) {
//        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//        [UIView animateWithDuration:duration animations:^{
//            contentView.transform = CGAffineTransformIdentity;
//        }];
//    }];
    [pwdView addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(20);
        make.right.offset(-15);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    RAC(sureBtn, enabled) = [RACSignal combineLatest:@[pwdTF.rac_textSignal] reduce:^id(NSString *pwd){
        return @(pwd.length>0);
    }];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if(block){
            block(pwdTF.text);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTF.mas_bottom).offset(20);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-(20+SafeBottomInset));
    }];
    [self showAnimationContentView:contentView];
}
+ (void)showAnimationContentView:(UIView *)contentView {
    contentView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
+ (UIView *)showTipView:(UIView *)view {
    if(view==nil){
        return nil;
    }
    view.backgroundColor = [UIColor g_bgColor];
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor g_maskColor];
    [maskView addSubview:view];
    [[UIApplication sharedApplication].delegate.window addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
    }];
    [view setNeedsLayout];
    [view layoutIfNeeded];
    CAShapeLayer *styleLayer = [CAShapeLayer layer];
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(28, 28)];
    styleLayer.path = shadowPath.CGPath;
    view.layer.mask = styleLayer;
    return maskView;
}

@end
