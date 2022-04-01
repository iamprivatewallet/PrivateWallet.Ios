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
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [self showTipView:contentView];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    __weak typeof(view) weakView = view;
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
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
    UILabel *descLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_backupAlertDesc") fontSize:14 textColor:[UIColor g_grayTextColor]];
    descLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(10);
        make.centerX.offset(0);
        make.right.offset(-10);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_myUnderstand") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIButton * _Nonnull button) {
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
