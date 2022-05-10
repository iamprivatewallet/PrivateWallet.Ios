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
    [maskView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.right.offset(-18);
        make.centerY.offset(-20);
        make.height.mas_greaterThanOrEqualTo(300);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_shareApp_bg"]];
    [contentView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    contentView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        contentView.transform = CGAffineTransformIdentity;
        contentView.alpha = 1;
    } completion:nil];
    [self createItems:contentView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PW_ShareTool shareTitle:nil subTitle:AppTestflightUrl data:[contentView convertViewToImage] completionBlock:^(BOOL completed) {
            [UIView animateWithDuration:0.25 animations:^{
                maskView.alpha = 0;
            } completion:^(BOOL finished) {
                [maskView removeFromSuperview];
            }];
        }];
    });
}
+ (void)createItems:(UIView *)contentView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo_big"]];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(62);
        make.centerX.offset(0);
        make.width.height.offset(120);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:PW_APPName fontSize:21 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom).offset(16);
        make.centerX.offset(0);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_shareAppText") fontSize:21 textColor:[UIColor g_textColor]];
    tipLb.textAlignment = NSTextAlignmentCenter;
    [tipLb setWordSpace:5];
    [contentView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(5);
        make.centerX.offset(0);
        make.left.mas_greaterThanOrEqualTo(15);
    }];
    UILabel *downloadTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_scanDownloadApp") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:downloadTipLb];
    [downloadTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(56);
        make.centerX.offset(0);
    }];
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor g_borderColor];
    [contentView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(downloadTipLb.mas_left).offset(-(PW_IPhoneX?20:15));
        make.width.offset(80).priorityLow();
        make.left.mas_greaterThanOrEqualTo(15);
        make.height.offset(1);
        make.centerY.equalTo(downloadTipLb);
    }];
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor g_borderColor];
    [contentView addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downloadTipLb.mas_right).offset(PW_IPhoneX?20:15);
        make.width.equalTo(leftLineView);
        make.height.offset(1);
        make.centerY.equalTo(downloadTipLb);
    }];
    UIView *downLoadView = [[UIView alloc] init];
    downLoadView.backgroundColor = [UIColor g_bgColor];
    [downLoadView setBorderColor:[UIColor g_primaryColor] width:2 radius:8];
    [contentView addSubview:downLoadView];
    [downLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downloadTipLb.mas_bottom).offset(20);
        make.centerX.offset(0);
        make.size.mas_equalTo(86);
    }];
    UIImageView *downLoadIv = [[UIImageView alloc] init];
    downLoadIv.image = [SGQRCodeObtain generateQRCodeWithData:[CATCommon JSONString:AppDownloadUrl] size:70];
    [downLoadView addSubview:downLoadIv];
    [downLoadIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(70);
    }];
}

@end
