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
    UILabel *tipLb = [[UILabel alloc] init];
    tipLb.font = [UIFont systemFontOfSize:15];
    tipLb.text = LocalizedStr(@"text_importExistWallet");
    tipLb.textColor = [UIColor g_whiteTextColor];
    [self.view addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(10);
        make.left.offset(26);
    }];
    UIView *row1View = [self createRowIconName:@"icon_privateKey" title:LocalizedStr(@"text_privateKey") desc:LocalizedStr(@"text_privateKeyTip")];
    [row1View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privateKeyImport)]];
    [self.view addSubview:row1View];
    [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(tipLb.mas_bottom).offset(20);
        make.height.offset(62);
    }];
    UIView *row2View = [self createRowIconName:@"icon_mnemonic" title:LocalizedStr(@"text_mnemonicWord") desc:LocalizedStr(@"text_mnemonicWordTip")];
    [row2View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mnemonicImport)]];
    [self.view addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(row1View.mas_bottom).offset(10);
        make.height.offset(62);
    }];
}
- (UIView *)createRowIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    bodyView.layer.cornerRadius = 8;
    bodyView.layer.shadowColor = [UIColor g_shadowColor].CGColor;
    bodyView.layer.shadowOffset = CGSizeMake(0, 2);
    bodyView.layer.shadowRadius = 8;
    bodyView.layer.shadowOpacity = 1;
    UIImageView *iconIv = [[UIImageView alloc] init];
    iconIv.image = [UIImage imageNamed:iconName];
    [bodyView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.centerY.offset(0);
    }];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = title;
    titleLb.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLb.textColor = [UIColor g_boldTextColor];
    [bodyView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bodyView.mas_centerY);
        make.left.equalTo(iconIv.mas_right).offset(12);
    }];
    UILabel *descLb = [[UILabel alloc] init];
    descLb.text = desc;
    descLb.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    descLb.textColor = [UIColor g_grayTextColor];
    [bodyView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom);
        make.left.equalTo(iconIv.mas_right).offset(12);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] init];
    arrowIv.image = [UIImage imageNamed:@"icon_arrow"];
    [bodyView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
    return bodyView;
}

@end
