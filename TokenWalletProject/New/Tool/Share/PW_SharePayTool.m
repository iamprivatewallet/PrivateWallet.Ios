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
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    contentView.layer.cornerRadius = 32;
    [maskView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.centerY.offset(-25);
        make.height.mas_greaterThanOrEqualTo(300);
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close_big"] forState:UIControlStateNormal];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [UIView animateWithDuration:0.25 animations:^{
            sender.superview.alpha = 0;
        } completion:^(BOOL finished) {
            [sender.superview removeFromSuperview];
        }];
    }];
    [maskView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(20);
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
        [PW_ShareTool shareTitle:nil subTitle:AppTestflightUrl data:[contentView convertViewToImage]];
    });
}
+ (void)createItems:(UIView *)contentView address:(NSString *)address name:(NSString *)name {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo"]];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.offset(30);
        make.width.height.offset(40);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:PW_APPName fontSize:21 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.centerY.equalTo(iconIv);
    }];
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_shadowColor];
    bodyView.layer.cornerRadius = 10;
    [contentView addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom).offset(15);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_scanPayMe") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [bodyView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.centerX.offset(0);
    }];
    CGFloat qrBodyWH = 200;
    CGFloat qrBodyInset = 40;
    if (!PW_IPhoneX) {
        qrBodyWH = 180;
        qrBodyInset = 30;
    }
    UIView *qrBodyView = [[UIView alloc] init];
    qrBodyView.backgroundColor = [UIColor g_bgColor];
    [qrBodyView setBorderColor:[UIColor g_shadowColor] width:1 radius:12];
    [bodyView addSubview:qrBodyView];
    [qrBodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(qrBodyWH);
        make.top.equalTo(tipLb.mas_bottom).offset(15);
        make.centerX.offset(0);
    }];
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    CGFloat qrImageWH = qrBodyWH-qrBodyInset;
    UIImageView *qrIv = [[UIImageView alloc] init];
    qrIv.image = [SGQRCodeObtain generateQRCodeWithData:[CATCommon JSONString:walletAddress] size:qrImageWH];
    [qrBodyView addSubview:qrIv];
    [qrIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(qrImageWH);
    }];
    UILabel *walletAddressTipLb = [PW_ViewTool labelSemiboldText:NSStringWithFormat(@"%@%@",name,LocalizedStr(@"text_walletAddress")) fontSize:14 textColor:[UIColor g_grayTextColor]];
    [bodyView addSubview:walletAddressTipLb];
    [walletAddressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrBodyView.mas_bottom).offset(20);
        make.centerX.offset(0);
    }];
    UILabel *addressLb = [PW_ViewTool labelSemiboldText:address fontSize:14 textColor:[UIColor g_boldTextColor]];
    addressLb.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:addressLb];
    [addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletAddressTipLb.mas_bottom).offset(8);
        make.left.offset(CGFloatScale(35));
        make.right.offset(CGFloatScale(-35));
        make.bottom.offset(-20);
    }];
    UILabel *downloadTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_scanDownloadApp") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:downloadTipLb];
    [downloadTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyView.mas_bottom).offset(25);
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
        make.bottom.offset(-35);
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
