//
//  PW_UnlockPasswordViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/22.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_UnlockPasswordViewController.h"

@interface PW_UnlockPasswordViewController ()

@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) PW_PasswordView *firstPwdView;
@property (nonatomic, strong) PW_PasswordView *secondPwdView;

@end

@implementation PW_UnlockPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_unlockPassword")];
    [self makeViews];
    [self.firstPwdView becomeFirstResponder];
}
- (void)nextAction {
    self.firstView.hidden = YES;
    [self.firstPwdView resignFirstResponder];
    self.secondView.hidden = NO;
    [self.secondPwdView becomeFirstResponder];
}
- (void)confirmAction {
    if ([self.firstPwdView.text isEqualToString:self.secondPwdView.text]) {
        [PW_LockTool setUnlockPwd:self.firstPwdView.text];
        [PW_LockTool setOpenUnlockPwd:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showError:LocalizedStr(@"text_unlockPwdTwoTip")];
    }
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    self.firstView = [[UIView alloc] init];
    self.firstView.backgroundColor = [UIColor g_bgCardColor];
    [self.firstView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [contentView addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    self.secondView = [[UIView alloc] init];
    self.secondView.backgroundColor = [UIColor g_bgCardColor];
    [self.secondView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    self.secondView.hidden = YES;
    [contentView addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [self createFirstViewItems];
    [self createSecondViewItems];
}
- (void)createFirstViewItems {
    UILabel *tipLb = [PW_ViewTool labelText:LocalizedStr(@"text_unlockPwdTip") fontSize:14 textColor:[UIColor g_textColor]];
    [self.firstView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(18);
        make.right.mas_lessThanOrEqualTo(10);
    }];
    self.firstPwdView = [[PW_PasswordView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.firstPwdView.completeBlock = ^(PW_PasswordView * _Nonnull view, NSString * _Nonnull text) {
        [weakSelf nextAction];
    };
    [self.firstView addSubview:self.firstPwdView];
    [self.firstPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(15);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.mas_equalTo(38);
        make.bottom.offset(-18);
    }];
}
- (void)createSecondViewItems {
    UILabel *tipLb = [PW_ViewTool labelText:LocalizedStr(@"text_unlockPwdTwoTip") fontSize:14 textColor:[UIColor g_textColor]];
    [self.secondView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(18);
        make.right.mas_lessThanOrEqualTo(10);
    }];
    self.secondPwdView = [[PW_PasswordView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.secondPwdView.completeBlock = ^(PW_PasswordView * _Nonnull view, NSString * _Nonnull text) {
        [weakSelf confirmAction];
    };
    [self.secondView addSubview:self.secondPwdView];
    [self.secondPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(15);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.mas_equalTo(38);
        make.bottom.offset(-18);
    }];
}

@end
