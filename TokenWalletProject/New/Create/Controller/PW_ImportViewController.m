//
//  PW_ImportViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ImportViewController.h"
#import "PW_PrivateKeyImportViewController.h"
#import "PW_MnemonicImportViewController.h"

@interface PW_ImportViewController ()

@end

@implementation PW_ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_importWallet")];
    [self makeViews];
}
- (void)privateKeyImport {
    PW_PrivateKeyImportViewController *vc = [[PW_PrivateKeyImportViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)mnemonicImport {
    PW_MnemonicImportViewController *vc = [[PW_MnemonicImportViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)makeViews {
//    UILabel *tipLb = [[UILabel alloc] init];
//    tipLb.font = [UIFont systemFontOfSize:15];
//    tipLb.text = LocalizedStr(@"text_importExistWallet");
//    tipLb.textColor = [UIColor g_whiteTextColor];
//    [self.view addSubview:tipLb];
//    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.naviBar.mas_bottom).offset(10);
//        make.left.offset(26);
//    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lock_big"]];
    [contentView addSubview:iconIv];
    UIView *row1View = [self createRowIconName:@"icon_privateKey" title:LocalizedStr(@"text_privateKey") desc:LocalizedStr(@"text_privateKeyTip")];
    [row1View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privateKeyImport)]];
    [contentView addSubview:row1View];
    UIView *row2View = [self createRowIconName:@"icon_mnemonic" title:LocalizedStr(@"text_mnemonicWord") desc:LocalizedStr(@"text_mnemonicWordTip")];
    [row2View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mnemonicImport)]];
    [contentView addSubview:row2View];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(26);
        make.right.offset(-26);
        make.bottom.equalTo(row1View.mas_top).offset(-20);
    }];
    [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.equalTo(row2View.mas_top).offset(-18);
        make.height.offset(65);
    }];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(65);
        make.bottomMargin.offset(-35);
    }];
}
- (UIView *)createRowIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc {
    UIView *bodyView = [[UIView alloc] init];
    [bodyView setCornerRadius:8];
    UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH-72, 65) gradientColors:@[[UIColor g_darkGradientStartColor],[UIColor blackColor]] gradientType:PW_GradientLeftToRight];
    bodyView.backgroundColor = [UIColor colorWithPatternImage:image];
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:iconName];
    [bodyView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bodyView.mas_left).offset(30);
        make.centerY.offset(0);
    }];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = title;
    titleLb.font = [UIFont pw_mediumFontOfSize:20];
    titleLb.textColor = [UIColor g_whiteTextColor];
    [bodyView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bodyView.mas_centerY).offset(3);
        make.left.offset(60);
    }];
    UILabel *descLb = [[UILabel alloc] init];
    descLb.text = desc;
    descLb.font = [UIFont pw_regularFontOfSize:12];
    descLb.textColor = [UIColor g_grayTextColor];
    [bodyView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom);
        make.left.equalTo(titleLb);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = [UIImage imageNamed:@"icon_arrow"];
    [bodyView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.offset(0);
    }];
    return bodyView;
}

@end
