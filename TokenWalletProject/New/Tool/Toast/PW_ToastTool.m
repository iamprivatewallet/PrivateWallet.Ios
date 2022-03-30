//
//  PW_ToastTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ToastTool.h"
#import <MBProgressHUD.h>

@implementation PW_ToastTool

+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self showText:error isSucces:NO toView:view];
}
+ (void)showSucees:(NSString *)success toView:(UIView *)view {
    [self showText:success isSucces:YES toView:view];
}
+ (void)showText:(NSString *)text isSucces:(BOOL)isSuccess toView:(UIView *)view {
    if(view==nil){
        return;
    }
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [subView removeFromSuperview];
        }
    }
    NSString *imageName = isSuccess?@"icon_success_toast":@"icon_warn_toast";
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    contentView.layer.cornerRadius = 22;
    contentView.layer.shadowColor = COLORFORRGBA(0xCCD0D6, 0.8).CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0, 3);
    contentView.layer.shadowRadius = 16;
    contentView.layer.shadowOpacity = 1;
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    titleLb.textColor = isSuccess?[UIColor g_successColor]:[UIColor g_errorColor];
    titleLb.text = text;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(10);
        make.right.lessThanOrEqualTo(contentView.mas_right).offset(-20);
        make.top.offset(10);
        make.bottom.offset(-10);
    }];
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:imageName];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.equalTo(titleLb.mas_left).offset(-6);
        make.left.greaterThanOrEqualTo(contentView.mas_left).offset(20);
    }];
    HUD.customView = contentView;
    HUD.square = NO;
    HUD.margin = 20;
    [contentView layoutIfNeeded];
    UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    CGFloat offsetY = (SCREEN_HEIGHT-safeAreaInsets.top-safeAreaInsets.bottom)*0.5-44-contentView.bounds.size.height;
    HUD.offset = CGPointMake(0, -offsetY);
    HUD.userInteractionEnabled = NO;
    HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.minShowTime = 1.5;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:2];
}

@end
