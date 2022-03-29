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

@interface PW_FirstChooseViewController ()

@end

@implementation PW_FirstChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UIImageView *bgIv = [[UIImageView alloc] init];
    bgIv.image = [UIImage imageNamed:@"first_bg"];
    [self.view addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
    }];
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(-50);
        make.left.right.offset(0);
    }];
    UIImageView *tipIv = [[UIImageView alloc] init];
    tipIv.image = [UIImage imageNamed:@"first_tip"];
    [contentView addSubview:tipIv];
    [tipIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(-40);
        make.right.offset(40);
    }];
    UIImageView *textIv = [[UIImageView alloc] init];
    textIv.image = [UIImage imageNamed:@"first_text"];
    [contentView addSubview:textIv];
    [textIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(tipIv.mas_bottom).offset(-10);
    }];
    UIButton *importBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [importBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    importBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    importBtn.layer.cornerRadius = 16;
    importBtn.layer.masksToBounds = YES;
    importBtn.layer.borderColor = [UIColor g_primaryColor].CGColor;
    importBtn.layer.borderWidth = 1;
    [importBtn setTitle:LocalizedStr(@"text_import") forState:UIControlStateNormal];
    [importBtn addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:importBtn];
    [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textIv.mas_bottom).offset(48);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
    }];
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    createBtn.layer.cornerRadius = 16;
    createBtn.layer.masksToBounds = YES;
    createBtn.backgroundColor = [UIColor g_primaryColor];
    [createBtn setTitle:LocalizedStr(@"text_create") forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:createBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(importBtn.mas_bottom).offset(20);
        make.left.offset(25);
        make.right.offset(-25);
        make.bottom.offset(0);
        make.height.offset(55);
    }];
}

@end
