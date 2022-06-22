//
//  PW_AppPwdLockView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/22.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AppPwdLockView.h"

@interface PW_AppPwdLockView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *wrongView;
@property (nonatomic, strong) UILabel *wrongLb;
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) PW_PasswordView *pwdView;

@end

@implementation PW_AppPwdLockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
        [self refreshUI];
    }
    return self;
}
- (void)makeViews {
    [self addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.wrongView = [[UIView alloc] init];
    self.wrongView.backgroundColor = [UIColor g_hex:@"#EA3442"];
    self.wrongView.hidden = YES;
    [self.effectView.contentView addSubview:self.wrongView];
    [self.wrongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(NavAndStatusHeight);
        make.left.right.offset(0);
        make.height.mas_equalTo(55);
    }];
    self.wrongLb = [PW_ViewTool labelText:[PW_LockTool getUnlockPwdErrorStr] fontSize:14 textColor:[UIColor whiteColor]];
    self.wrongLb.textAlignment = NSTextAlignmentCenter;
    [self.wrongView addSubview:self.wrongLb];
    [self.wrongLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(36);
        make.center.offset(0);
    }];
    [self.effectView.contentView addSubview:self.bodyView];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.centerY.offset(-30);
        make.height.mas_equalTo(120);
    }];
    UILabel *tipLb = [PW_ViewTool labelText:@"Enter AppLock Password" fontSize:18 textColor:[UIColor g_textColor]];
    [self.bodyView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.offset(0);
    }];
    self.pwdView = [[PW_PasswordView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.pwdView.completeBlock = ^(PW_PasswordView * _Nonnull view, NSString * _Nonnull text) {
        [weakSelf completeWithText:text];
    };
    [self.bodyView addSubview:self.pwdView];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-18);
        make.bottom.offset(-20);
        make.height.mas_equalTo(36);
    }];
}
- (void)reset {
    [self refreshUI];
}
- (void)completeWithText:(NSString *)text {
    BOOL isSuccess = [text isEqualToString:[PW_LockTool getUnlockPwd]];
    if (self.completeBlock) {
        self.completeBlock(self, isSuccess);
    }
    if (isSuccess==NO) {
        [PW_LockTool deductUnlockPwd];
        [self.pwdView reset];
        self.wrongView.hidden = NO;
        self.wrongLb.text = [PW_LockTool getUnlockPwdErrorStr];
        if (![PW_LockTool hasUnlockPwd]) {
            self.bodyView.hidden = YES;
            [self.pwdView reset];
            [self.pwdView resignFirstResponder];
        }
    }else{
        [PW_LockTool resetUnlockPwd];
        self.wrongView.hidden = YES;
        self.bodyView.hidden = NO;
    }
}
- (void)refreshUI {
    if ([PW_LockTool getUnlockPwdErrorCount]!=0) {
        self.wrongView.hidden = NO;
        self.wrongLb.text = [PW_LockTool getUnlockPwdErrorStr];
    }
    if (![PW_LockTool hasUnlockPwd]) {
        self.bodyView.hidden = YES;
        [self.pwdView reset];
        [self.pwdView resignFirstResponder];
    }else{
        self.bodyView.hidden = NO;
        [self.pwdView reset];
        [self.pwdView becomeFirstResponder];
    }
}
#pragma mark - lazy
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setCornerRadius:8];
    }
    return _bodyView;
}

@end
