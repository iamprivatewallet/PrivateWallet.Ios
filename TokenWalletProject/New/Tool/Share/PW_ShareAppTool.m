//
//  PW_ShareAppTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ShareAppTool.h"
#import "SGQRCode.h"
#import "PW_ShareTool.h"

@implementation PW_ShareAppTool

+ (void)showShareApp {
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor g_maskColor];
    [[[UIApplication sharedApplication].delegate window] addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_darkBgColor];
    contentView.clipsToBounds = YES;
    [maskView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-18);
        make.centerY.offset(-10);
        make.height.mas_greaterThanOrEqualTo(300);
        make.height.mas_lessThanOrEqualTo(SCREEN_HEIGHT*0.8);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bg"]];
    bgIv.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(0).priorityLow();
    }];
    contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    contentView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        contentView.alpha = 1;
    } completion:nil];
    [self createItems:contentView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PW_ShareTool shareTitle:nil subTitle:AppDownloadUrl data:[contentView convertViewToImage] completionBlock:^(BOOL completed) {
            [UIView animateWithDuration:0.25 animations:^{
                maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [maskView removeFromSuperview];
            }];
        }];
    });
}
+ (void)createItems:(UIView *)contentView {
    UIImageView *logoIv = [[UIImageView alloc] init];
    logoIv.image = [UIImage imageNamed:@"icon_logo_big"];
    [contentView addSubview:logoIv];
    UIImageView *textIv = [[UIImageView alloc] init];
    textIv.image = [UIImage imageNamed:@"private_wallet"];
    [contentView addSubview:textIv];
    UILabel *textLb = [PW_ViewTool labelText:LocalizedStr(@"text_appDesc") fontSize:14 textColor:[UIColor g_whiteTextColor]];
    textLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:textLb];
    CGFloat downloadWH = 260;
    CGFloat downloadOffsetY = -30;
    CGFloat logoWH = 120;
    CGFloat logoOffsetY = 50;
    CGFloat padding = 40;
    if (!PW_IPhoneX) {
        downloadWH = 200;
        logoWH = 100;
        logoOffsetY = 30;
        padding = 30;
    }
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(logoOffsetY);
        make.centerX.offset(0);
        make.width.height.mas_equalTo(logoWH);
    }];
    [textIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(logoIv.mas_bottom).offset(22);
    }];
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(textIv.mas_bottom).offset(18);
        make.left.mas_greaterThanOrEqualTo(50);
    }];
    UIView *downLoadView = [[UIView alloc] init];
    [contentView addSubview:downLoadView];
    [downLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY).offset(downloadOffsetY);
        make.centerX.offset(0);
        make.size.mas_equalTo(downloadWH);
    }];
    UIImageView *scanIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_scan_big"]];
    [downLoadView addSubview:scanIv];
    [scanIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    CGFloat downloadIvWH = downloadWH-2*padding;
    UIImageView *downLoadIv = [[UIImageView alloc] init];
    downLoadIv.image = [SGQRCodeObtain generateQRCodeWithData:AppDownloadUrl size:downloadIvWH];
    [downLoadView addSubview:downLoadIv];
    [downLoadIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(downloadIvWH);
    }];
    UILabel *downloadTipLb = [PW_ViewTool labelBoldText:LocalizedStr(@"text_scanDownloadApp") fontSize:25 textColor:[UIColor g_whiteTextColor]];
    downloadTipLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:downloadTipLb];
    [downloadTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downLoadView.mas_bottom).offset(20);
        make.left.mas_greaterThanOrEqualTo(60);
        make.centerX.offset(0);
    }];
}

@end
