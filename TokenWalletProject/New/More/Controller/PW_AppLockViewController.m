//
//  PW_AppLockViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/5/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AppLockViewController.h"
#import "PW_AuthenticationTool.h"
#import "PW_UnlockPasswordViewController.h"

@interface PW_AppLockViewController ()

@property (nonatomic, strong) UIButton *pwdBtn;
@property (nonatomic, strong) UIButton *biologicalBtn;

@end

@implementation PW_AppLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_appLock")];
    [self makeViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pwdBtn.selected = [PW_LockTool getOpenUnlockPwd];
    self.biologicalBtn.selected = [PW_LockTool getUnlockAppTransaction];
}
- (void)pwdAction:(UIButton *)btn {
    if (btn.selected==NO) {
        PW_UnlockPasswordViewController *vc = [[PW_UnlockPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        btn.selected = NO;
        [PW_LockTool setOpenUnlockPwd:NO];
    }
}
- (void)biologicalAction:(UIButton *)btn {
    LAContext *context = [PW_AuthenticationTool isSupportBiometrics];
    NSString *biometryTypeStr = [PW_AuthenticationTool biometryTypeStr];
    if (context) {
        NSString *desc = NSStringWithFormat(LocalizedStr(@"text_biologicalTitle"),biometryTypeStr);
        [PW_AuthenticationTool showWithDesc:desc reply:^(BOOL success, NSError * _Nonnull error) {
            if (success) {
                btn.selected = !btn.selected;
                [PW_LockTool setUnlockAppTransaction:btn.selected];
            }
        }];
    }else{
        [self showError:NSStringWithFormat(@"%@ %@",biometryTypeStr,LocalizedStr(@"text_permissionsNotEnabled"))];
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
    UIView *pwdView = [self createRowIconName:@"icon_lock_pwd" title:LocalizedStr(@"text_unlockPassword") desc:nil];
    [contentView addSubview:pwdView];
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.offset(28);
        make.height.mas_greaterThanOrEqualTo(70);
    }];
    self.pwdBtn = [PW_ViewTool buttonImageName:@"icon_switch_off" selectedImage:@"icon_switch_on" target:self action:@selector(pwdAction:)];
    [pwdView addSubview:self.pwdBtn];
    [self.pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.offset(0);
    }];
    LAContext *context = [PW_AuthenticationTool isSupportBiometrics];
    NSString *biometryTypeStr = @"TouchID";
    if (context) {
        switch (context.biometryType) {
            case LABiometryTypeFaceID:
                biometryTypeStr = @"FaceID";
                break;
            default:
                break;
        }
    }
    UIView *biologicalView = [self createRowIconName:@"icon_lock_pwd" title:NSStringWithFormat(LocalizedStr(@"text_biologicalTitle"),biometryTypeStr) desc:LocalizedStr(@"text_biologicalDesc")];
    [contentView addSubview:biologicalView];
    [biologicalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(pwdView.mas_bottom).offset(0);
        make.height.mas_greaterThanOrEqualTo(70);
    }];
    self.biologicalBtn = [PW_ViewTool buttonImageName:@"icon_switch_off" selectedImage:@"icon_switch_on" target:self action:@selector(biologicalAction:)];
    [biologicalView addSubview:self.biologicalBtn];
    [self.biologicalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.offset(0);
    }];
}
- (UIView *)createRowIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc {
    UIView *bodyView = [[UIView alloc] init];
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:iconName];
    [bodyView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bodyView.mas_left).offset(20);
        make.top.offset(4);
    }];
    UILabel *titleLb = [PW_ViewTool labelMediumText:title fontSize:18 textColor:[UIColor g_textColor]];
    [bodyView addSubview:titleLb];
    if ([desc isNoEmpty]) {
        UILabel *descLb = [PW_ViewTool labelText:desc fontSize:14 textColor:[UIColor g_grayTextColor]];
        [bodyView addSubview:descLb];
        [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(2);
            make.left.equalTo(titleLb);
            make.right.mas_lessThanOrEqualTo(-60);
            make.bottom.offset(-10);
        }];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(18);
            make.left.offset(55);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
    }else{
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(55);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
    }
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [bodyView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(1);
    }];
    return bodyView;
}

@end
