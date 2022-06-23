//
//  PW_AppAuthLockView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/23.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AppAuthLockView.h"
#import "PW_AuthenticationTool.h"

@interface PW_AppAuthLockView ()

@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *wrongView;
@property (nonatomic, strong) UILabel *wrongLb;

@end

@implementation PW_AppAuthLockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.effectView.contentView addSubview:self.wrongView];
    [self.wrongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(NavAndStatusHeight);
        make.left.right.offset(0);
        make.height.mas_equalTo(55);
    }];
    [self.wrongView addSubview:self.wrongLb];
    [self.wrongLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(30);
        make.center.offset(0);
    }];
}
- (void)start {
    LAContext *context = [PW_AuthenticationTool isSupportBiometrics];
    if (context) {
        self.wrongView.hidden = YES;
        [PW_AuthenticationTool showWithDesc:LocalizedStr(@"text_unlockApp") reply:^(BOOL success, NSError * _Nonnull error) {
            if (self.completeBlock) {
                self.completeBlock(self, success);
            }
        }];
    }else{
        self.wrongView.hidden = NO;
    }
}
- (void)reset {
    self.wrongView.hidden = YES;
}
#pragma mark - lazy
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}
- (UIView *)wrongView {
    if (!_wrongView) {
        _wrongView = [[UIView alloc] init];
        _wrongView.backgroundColor = [UIColor g_wrongColor];
        _wrongView.hidden = YES;
    }
    return _wrongView;
}
- (UILabel *)wrongLb {
    if (!_wrongLb) {
        NSString *str = [PW_AuthenticationTool biometryTypeStr];
        NSString *tipStr = NSStringWithFormat(@"%@ %@",str,LocalizedStr(@"text_permissionsNotEnabled"));
        _wrongLb = [PW_ViewTool labelText:tipStr fontSize:14 textColor:[UIColor whiteColor]];
        _wrongLb.textAlignment = NSTextAlignmentCenter;
    }
    return _wrongLb;
}

@end
