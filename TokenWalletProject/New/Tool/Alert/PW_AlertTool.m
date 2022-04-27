//
//  PW_AlertTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AlertTool.h"

@implementation PW_AlertTool

+ (void)showAlertTitle:(NSString *)title desc:(NSString *)desc sureBlock:(void (^)(void))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showAlertView:contentView];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:title fontSize:21 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(25);
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
    UILabel *contentLb = [PW_ViewTool labelText:desc fontSize:15 textColor:[UIColor g_textColor]];
    [bodyView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(24);
        make.right.offset(-24);
        make.bottom.offset(-10);
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
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
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

+ (void)showAnimationAlertContentView:(UIView *)contentView {
    contentView.alpha = 0.0;
    contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        contentView.alpha = 1.0;
        contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
+ (void)showAnimationSheetContentView:(UIView *)contentView {
    contentView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
+ (UIView *)showAlertView:(UIView *)view {
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
        make.left.offset(25);
        make.right.offset(-25);
        make.centerY.offset(0);
        make.height.mas_greaterThanOrEqualTo(50);
    }];
    view.layer.cornerRadius = 22;
    return maskView;
}
+ (UIView *)showSheetView:(UIView *)view {
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
        make.height.mas_greaterThanOrEqualTo(50);
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
