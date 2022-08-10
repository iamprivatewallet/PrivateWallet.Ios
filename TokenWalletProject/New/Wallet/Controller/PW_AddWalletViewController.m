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
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.bottom.right.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    self.headerView = [[UIView alloc] init];
    [self.headerView addTapTarget:self action:@selector(createAction)];
    [contentView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(70);
    }];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_importExistWallet") fontSize:15 textColor:[UIColor g_textColor]];
    [self.view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(15);
        make.left.offset(40);
    }];
    UIView *privateKeyView = [self createRowViewImageName:@"icon_wallet_privatekey" title:LocalizedStr(@"text_privateKey") desc:LocalizedStr(@"text_privateKeyTip")];
    [privateKeyView addTapTarget:self action:@selector(importPrivateKeyAction)];
    [self.view addSubview:privateKeyView];
    UIView *mnemonicWordView = [self createRowViewImageName:@"icon_wallet_mnemonic" title:LocalizedStr(@"text_mnemonicWord") desc:LocalizedStr(@"text_mnemonicWordTip")];
    [mnemonicWordView addTapTarget:self action:@selector(importMnemonicWordAction)];
    [self.view addSubview:mnemonicWordView];
    [privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(5);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(70);
    }];
    [mnemonicWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privateKeyView.mas_bottom).offset(0);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(70);
    }];
    [self createHeaderItems];
}
- (void)createHeaderItems {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more_wallet"]];
    [self.headerView addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_createWallet") fontSize:18 textColor:[UIColor g_textColor]];
    [self.headerView addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelText:LocalizedStr(@"text_addWalletTip") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.headerView addSubview:descLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.headerView addSubview:arrowIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView.mas_left).offset(22);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(56);
        make.bottom.equalTo(self.headerView.mas_centerY).offset(-1);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb);
        make.top.equalTo(self.headerView.mas_centerY).offset(1);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
}
- (UIView *)createRowViewImageName:(NSString *)imageName title:(NSString *)title desc:(NSString *)desc {
    UIView *view = [[UIView alloc] init];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelMediumText:title fontSize:18 textColor:[UIColor g_boldTextColor]];
    [view addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelText:desc fontSize:13 textColor:[UIColor g_grayTextColor]];
    [view addSubview:descLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [view addSubview:arrowIv];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_lineColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_left).offset(22);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_centerY).offset(-1);
        make.left.offset(56);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_centerY).offset(1);
        make.left.equalTo(titleLb);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    return view;
}

@end
