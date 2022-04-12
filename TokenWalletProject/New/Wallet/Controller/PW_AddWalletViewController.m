//
//  PW_AddWalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddWalletViewController.h"
#import "PW_AddImportWalletViewController.h"
#import "PW_AddCreateWalletViewController.h"

@interface PW_AddWalletViewController ()

@property (nonatomic, strong) UIView *headerView;

@end

@implementation PW_AddWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_addWallet")];
    [self makeViews];
}
- (void)createAction {
    PW_AddCreateWalletViewController *vc = [[PW_AddCreateWalletViewController alloc] init];
    vc.walletType = self.walletType;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)importPrivateKeyAction {
    PW_AddImportWalletViewController *vc = [[PW_AddImportWalletViewController alloc] init];
    vc.walletType = self.walletType;
    vc.importType = PW_ImportWalletTypePrivateKey;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)importMnemonicWordAction {
    PW_AddImportWalletViewController *vc = [[PW_AddImportWalletViewController alloc] init];
    vc.walletType = self.walletType;
    vc.importType = PW_ImportWalletTypeMnemonic;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)makeViews {
    self.headerView = [[UIView alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH-40, 82)];
    [self.headerView setShadowColor:[UIColor g_hex:@"#00A4B8" alpha:0.45] offset:CGSizeMake(0, 5) radius:15 path:path];
    [self.headerView addTapTarget:self action:@selector(createAction)];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(22);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(82);
    }];
    UILabel *titleLb = [PW_ViewTool labelText:LocalizedStr(@"text_importExistWallet") fontSize:15 textColor:[UIColor g_textColor]];
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(26);
        make.left.offset(26);
    }];
    UIView *privateKeyView = [self createRowViewImageName:@"icon_privateKey_gray" title:LocalizedStr(@"text_privateKey") desc:LocalizedStr(@"text_privateKeyTip")];
    [privateKeyView addTapTarget:self action:@selector(importPrivateKeyAction)];
    [self.view addSubview:privateKeyView];
    UIView *mnemonicWordView = [self createRowViewImageName:@"icon_mnemonic_gray" title:LocalizedStr(@"text_mnemonicWord") desc:LocalizedStr(@"text_mnemonicWordTip")];
    [mnemonicWordView addTapTarget:self action:@selector(importMnemonicWordAction)];
    [self.view addSubview:mnemonicWordView];
    [privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(20);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(62);
    }];
    [mnemonicWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privateKeyView.mas_bottom).offset(10);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(62);
    }];
    [self createHeaderItems];
}
- (void)createHeaderItems {
    UIImage *bgImage = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH-40, 82) gradientColors:@[[UIColor g_hex:@"#00D5E9"],[UIColor g_hex:@"#00A4B9"]] gradientType:PW_GradientLeftToRight cornerRadius:8];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:bgImage];
    [self.headerView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wallet_big"]];
    [self.headerView addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_createWallet") fontSize:18 textColor:[UIColor whiteColor]];
    [self.headerView addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_addWalletTip") fontSize:13 textColor:[UIColor g_lightTextColor]];
    [self.headerView addSubview:descLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_light"]];
    [self.headerView addSubview:arrowIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.bottom.equalTo(self.headerView.mas_centerY).offset(-2);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(10);
        make.top.equalTo(self.headerView.mas_centerY).offset(2);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
}
- (UIView *)createRowViewImageName:(NSString *)imageName title:(NSString *)title desc:(NSString *)desc {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor g_bgColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH-40, 62)];
    view.layer.cornerRadius = 8;
    [view setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8 path:path];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelMediumText:title fontSize:16 textColor:[UIColor g_boldTextColor]];
    [view addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:desc fontSize:12 textColor:[UIColor g_grayTextColor]];
    [view addSubview:descLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [view addSubview:arrowIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_centerY).offset(-2);
        make.left.equalTo(iconIv.mas_right).offset(12);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_centerY).offset(2);
        make.left.equalTo(iconIv.mas_right).offset(12);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
        make.centerY.offset(0);
    }];
    return view;
}

@end
