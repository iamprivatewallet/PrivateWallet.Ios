//
//  PW_TipTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TipTool.h"
#import "PW_DappMoreContentView.h"
#import "PW_AlertTool.h"

@implementation PW_TipTool

+ (void)showBackupTipSureBlock:(void (^)(void))block {
    [self showBackupTipDesc:LocalizedStr(@"text_backupAlertDesc") sureBlock:block];
}
+ (void)showDeleteWalletBackupMnemonicsSureBlock:(void (^)(void))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_prompt") fontSize:22 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(38);
        make.centerX.offset(0);
        make.width.equalTo(contentView).multipliedBy(0.6);
    }];
    UIView *descBgView = [[UIView alloc] init];
    descBgView.backgroundColor = [UIColor g_warnBgColor];
    [descBgView setCornerRadius:8];
    [contentView addSubview:descBgView];
    [descBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    UILabel *descLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_backupTip") fontSize:14 textColor:[UIColor g_grayTextColor]];
    descLb.textAlignment = NSTextAlignmentCenter;
    [descBgView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(40);
        make.right.offset(-40);
        make.bottom.offset(-16);
    }];
    __weak typeof(view) weakView = view;
    UIButton *cancelBtn = [PW_ViewTool buttonTitle:LocalizedStr(@"text_cancel") fontSize:18 titleColor:[UIColor g_whiteTextColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:nil action:nil];
    [cancelBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descBgView.mas_bottom).offset(18);
        make.left.offset(36);
        make.height.offset(55);
        make.bottomMargin.offset(-20);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonTitle:LocalizedStr(@"text_backupMnemonics") fontSize:18 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    sureBtn.titleLabel.numberOfLines = 2;
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if(block){
            block();
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(25);
        make.right.offset(-36);
        make.top.width.height.bottom.equalTo(cancelBtn);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showBackupTipPrivateKeySureBlock:(void (^)(void))block {
    [self showBackupTipDesc:LocalizedStr(@"text_backupAlertPrivateKeyDesc") sureBlock:block];
}
+ (void)showBackupTipDesc:(NSString *)desc sureBlock:(void (^)(void))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
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
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_backupAlertTitle") fontSize:22 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(38);
        make.centerX.offset(0);
        make.width.equalTo(contentView).multipliedBy(0.6);
    }];
    UILabel *descLb = [PW_ViewTool labelMediumText:desc fontSize:13 textColor:[UIColor g_grayTextColor]];
    descLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(10);
        make.centerX.offset(0);
        make.width.equalTo(contentView).multipliedBy(0.6);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_myUnderstand") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
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
        make.bottomMargin.offset(-20);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showPayPwdSureBlock:(void (^)(NSString *pwd))block {
    [self showPayPwdSureBlock:block closeBlock:nil];
}
+ (void)showPayPwdSureBlock:(void (^)(NSString *pwd))block closeBlock:(void(^)(void))closeBlock {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
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
        if (closeBlock) {
            closeBlock();
        }
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
    [pwdTF pw_setSecureTextEntry];
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
    [pwdView addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(20);
        make.right.offset(-15);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
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
        make.bottomMargin.offset(-20);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showDappWalletNotSupportedWithModel:(PW_DappModel *)model sureBlock:(void(^)(void))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showAlertView:contentView];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_prompt") fontSize:21 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(25);
    }];
    UIImageView *titleIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_title_bg"]];
    [contentView addSubview:titleIv];
    [titleIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleLb);
    }];
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_grayBgColor];
    bodyView.layer.cornerRadius = 12;
    [contentView addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(15);
        make.left.offset(22);
        make.right.offset(-22);
    }];
    UILabel *contentLb = [PW_ViewTool labelText:LocalizedStr(@"text_currentWalletNotSupportedTip") fontSize:15 textColor:[UIColor g_textColor]];
    [bodyView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(24);
        make.right.offset(-24);
    }];
    UIView *rowView = [[UIView alloc] init];
    [bodyView addSubview:rowView];
    [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLb.mas_bottom).offset(10);
        make.left.offset(24);
        make.right.offset(-24);
        make.bottom.offset(-10);
    }];
    UIImageView *iconIv = [[UIImageView alloc] init];
    [iconIv sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    [rowView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.height.offset(40);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    UILabel *nameLb = [PW_ViewTool labelSemiboldText:PW_StrFormat(@"%@%@%@%@",model.appName,LocalizedStr(@"text_support"),model.firType,LocalizedStr(@"text_chain")) fontSize:16 textColor:[UIColor g_textColor]];
    [rowView addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.right.offset(0);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    __weak typeof(view) weakView = view;
    UIButton *cancelBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_cancel") fontSize:16 titleColor:[UIColor g_grayTextColor] imageName:nil target:nil action:nil];
    [cancelBtn setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [cancelBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom).offset(30);
        make.left.offset(22);
        make.height.offset(55);
        make.bottom.offset(-30);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_switchWallet") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [contentView addSubview:sureBtn];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        if (block) {
            block();
        }
        [weakView removeFromSuperview];
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(cancelBtn);
        make.left.equalTo(cancelBtn.mas_right).offset(15);
        make.right.offset(-22);
    }];
    [PW_AlertTool showAnimationAlertContentView:contentView];
}
+ (void)showDappDisclaimerUrlStr:(NSString *)urlStr sureBlock:(void(^)(void))block{
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showAlertView:contentView];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_disclaimer") fontSize:21 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(25);
    }];
    UIImageView *titleIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_title_bg"]];
    [contentView addSubview:titleIv];
    [titleIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleLb);
    }];
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_grayBgColor];
    bodyView.layer.cornerRadius = 12;
    [contentView addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(15);
        make.left.offset(22);
        make.right.offset(-22);
    }];
    UILabel *contentLb = [PW_ViewTool labelText:PW_StrFormat(LocalizedStr(@"text_dappDisclaimer"),urlStr) fontSize:15 textColor:[UIColor g_textColor]];
    [bodyView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.bottom.offset(-10);
        make.left.offset(24);
        make.right.offset(-24);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_myUnderstand") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [contentView addSubview:sureBtn];
    __weak typeof(view) weakView = view;
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        if (block) {
            block();
        }
        [weakView removeFromSuperview];
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom).offset(30);
        make.left.offset(22);
        make.right.offset(-22);
        make.height.offset(55);
    }];
    UIButton *cancelBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_cancel") fontSize:16 titleColor:[UIColor g_boldTextColor] imageName:nil target:nil action:nil];
    [cancelBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureBtn.mas_bottom).offset(15);
        make.centerX.offset(0);
        make.bottom.offset(-30);
    }];
    [PW_AlertTool showAnimationAlertContentView:contentView];
}
//dapp
+ (void)showDappMoreTitle:(NSString *)title dataArr:(NSArray<PW_DappMoreModel *> *)dataArr sureBlock:(void(^)(PW_DappMoreModel *model))block {
    if (dataArr==nil||dataArr.count==0) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:title fontSize:15 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.offset(0);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    PW_DappMoreContentView *moreView = [[PW_DappMoreContentView alloc] init];
    moreView.dataArr = dataArr;
    __weak typeof(view) weakView = view;
    moreView.clickBlock = ^(PW_DappMoreModel * _Nonnull model) {
        [weakView removeFromSuperview];
        if (block) {
            block(model);
        }
    };
    [contentView addSubview:moreView];
    NSInteger column = 5;
    NSInteger row = dataArr.count/5+((dataArr.count%column)>0?1:0);
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(25);
        make.left.right.offset(0);
        make.height.offset(row*90);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreView.mas_bottom).offset(10);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(1);
    }];
    UIButton *cancelBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_cancel") fontSize:16 titleColor:[UIColor g_boldTextColor] cornerRadius:0 backgroundColor:[UIColor g_bgColor] target:nil action:nil];
    [cancelBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.left.right.offset(0);
        make.height.offset(44);
        make.bottom.offset(-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}

@end
