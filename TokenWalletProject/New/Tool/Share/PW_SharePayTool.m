//
//  PW_SharePayTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SharePayTool.h"
#import "SGQRCode.h"
#import "PW_ShareTool.h"

@implementation PW_SharePayTool

+ (void)showPayMeViewWithAddress:(NSString *)address name:(NSString *)name {
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor g_maskColor];
    [[[UIApplication sharedApplication].delegate window] addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [maskView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-18);
        make.centerY.offset(-10);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.8);
    }];
    UIView *bodyView = [[UIView alloc] init];
    [scrollView addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_darkBgColor];
    contentView.clipsToBounds = YES;
    [bodyView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_big"] forState:UIControlStateNormal];
    __weak typeof(maskView) weakSelf = maskView;
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
    [maskView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom).offset(10);
        make.centerX.offset(0);
    }];
    contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    contentView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        contentView.alpha = 1;
    } completion:nil];
    [self createItems:contentView address:address name:name];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PW_ShareTool shareTitle:nil subTitle:AppDownloadUrl data:[contentView convertViewToImage]];
    });
}
+ (void)createItems:(UIView *)contentView address:(NSString *)address name:(NSString *)name {
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bg"]];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(0).priorityLow();
    }];
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_scanPayMe") fontSize:25 textColor:[UIColor g_whiteTextColor]];
    tipLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.left.mas_greaterThanOrEqualTo(50);
        make.centerX.offset(0);
    }];
    UIView *qrView = [[UIView alloc] init];
    [contentView addSubview:qrView];
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(18);
        make.centerX.offset(0);
        make.size.mas_equalTo(260);
    }];
    UIImageView *scanIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_scan_big"]];
    [qrView addSubview:scanIv];
    [scanIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *qrIv = [[UIImageView alloc] init];
    qrIv.image = [SGQRCodeObtain generateQRCodeWithData:address size:180];
    [qrView addSubview:qrIv];
    [qrIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(180);
    }];
    UIView *addressView = [[UIView alloc] init];
    [addressView setBorderColor:[UIColor g_hex:@"#FBAE17"] width:1 radius:8];
    [contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrView.mas_bottom).offset(25);
        make.width.offset(256);
        make.centerX.offset(0);
    }];
    UILabel *addressTipLb = [PW_ViewTool labelBoldText:LocalizedStr(@"text_walletAddress") fontSize:20 textColor:[UIColor g_whiteTextColor]];
    [addressView addSubview:addressTipLb];
    [addressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.centerX.offset(0);
    }];
    UILabel *addressLb = [PW_ViewTool labelBoldText:address fontSize:14 textColor:[UIColor g_whiteTextColor]];
    addressLb.numberOfLines = 1;
    addressLb.textAlignment = NSTextAlignmentCenter;
    addressLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [addressView addSubview:addressLb];
    [addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTipLb.mas_bottom).offset(2);
        make.left.offset(45);
        make.right.offset(-45);
        make.bottom.offset(-20);
    }];
    UIImageView *logoIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo"]];
    [contentView addSubview:logoIv];
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(40);
        make.right.equalTo(contentView.mas_centerX).offset(-9);
        make.width.height.mas_equalTo(89);
    }];
    UIImageView *downLoadIv = [[UIImageView alloc] init];
    downLoadIv.image = [SGQRCodeObtain generateQRCodeWithData:AppDownloadUrl size:89];
    [contentView addSubview:downLoadIv];
    [downLoadIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIv);
        make.left.equalTo(contentView.mas_centerX).offset(9);
        make.width.height.mas_equalTo(89);
    }];
    UILabel *downloadTipLb = [PW_ViewTool labelBoldText:LocalizedStr(@"text_scanDownloadApp") fontSize:14 textColor:[UIColor g_whiteTextColor]];
    [contentView addSubview:downloadTipLb];
    [downloadTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIv.mas_bottom).offset(18);
        make.centerX.offset(0);
        make.left.mas_greaterThanOrEqualTo(50);
        make.bottom.offset(-40);
    }];
}

@end
