//
//  PW_FirstChooseViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "PW_FirstChooseViewController.h"
#import "PW_ImportViewController.h"
#import "PW_CreateViewController.h"
#import "PW_BackupWalletViewController.h"

@interface PW_FirstChooseViewController ()

@end

@implementation PW_FirstChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupFullBackground];
    [self makeViews];
}
- (void)importAction {
    PW_ImportViewController *importVc = [[PW_ImportViewController alloc] init];
    [self.navigationController pushViewController:importVc animated:YES];
}
- (void)createAction {
    PW_CreateViewController *createVc = [[PW_CreateViewController alloc] init];
    [self.navigationController pushViewController:createVc animated:YES];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    UIImageView *logoIv = [[UIImageView alloc] init];
    logoIv.image = [UIImage imageNamed:@"icon_logo_big"];
    [contentView addSubview:logoIv];
    UIImageView *textIv = [[UIImageView alloc] init];
    textIv.image = [UIImage imageNamed:@"private_wallet"];
    [contentView addSubview:textIv];
    UILabel *textLb = [PW_ViewTool labelText:LocalizedStr(@"text_appDesc") fontSize:17 textColor:[UIColor g_whiteTextColor]];
    textLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:textLb];
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(textIv.mas_top).offset(-22);
    }];
    [textIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(textLb.mas_top).offset(-18);
    }];
    [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.equalTo(contentView.mas_centerY).offset(-30);
        make.left.mas_greaterThanOrEqualTo(50);
    }];
    UIView *importView = [[UIView alloc] init];
    [importView setCornerRadius:8];
    importView.layer.borderColor = [UIColor g_primaryColor].CGColor;
    importView.layer.borderWidth = 1;
    [importView addTapTarget:self action:@selector(importAction)];
    [self createBtnItemsWithView:importView imageName:@"icon_import" title:LocalizedStr(@"text_import")];
    [contentView addSubview:importView];
    UIView *createView = [[UIView alloc] init];
    [createView setCornerRadius:8];
    createView.layer.borderColor = [UIColor g_primaryColor].CGColor;
    createView.layer.borderWidth = 1;
    [createView addTapTarget:self action:@selector(createAction)];
    [self createBtnItemsWithView:createView imageName:@"icon_new" title:LocalizedStr(@"text_create")];
    [contentView addSubview:createView];
    [importView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(createView.mas_top).offset(-18);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
    }];
    [createView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.bottomMargin.offset(-30);
        make.height.offset(55);
    }];
}
- (void)createBtnItemsWithView:(UIView *)view imageName:(NSString *)imageName title:(NSString *)title {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.centerX.equalTo(view.mas_left).mas_offset(30);
    }];
    UILabel *titleLb = [PW_ViewTool labelMediumText:title fontSize:22 textColor:[UIColor g_whiteTextColor]];
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(66);
        make.centerY.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_white"]];
    [view addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-28);
        make.centerY.offset(0);
    }];
}

@end
