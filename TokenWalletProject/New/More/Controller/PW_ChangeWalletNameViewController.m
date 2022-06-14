//
//  PW_ChangeWalletNameViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChangeWalletNameViewController.h"

@interface PW_ChangeWalletNameViewController ()

@property (nonatomic, strong) UITextField *nameTf;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation PW_ChangeWalletNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_changeWalletName")];
    [self makeViews];
    RAC(self.sureBtn, enabled) = [RACSignal combineLatest:@[self.nameTf.rac_textSignal] reduce:^id(NSString *name){
        return @([name trim].length>0);
    }];
}
- (void)sureAction {
    NSString *walletName = [self.nameTf.text trim];
    if (![walletName judgeWalletName]) {
        [self showError:LocalizedStr(@"text_walletNameInputError")];
        return;
    }
    [[PW_WalletManager shared] updateWalletName:walletName address:self.model.address type:self.model.type];
    [self showSuccess:LocalizedStr(@"text_saveSuccess")];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.bottom.right.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIView *nameView = [[UIView alloc] init];
    nameView.backgroundColor = [UIColor g_bgColor];
    [nameView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [nameView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [contentView addSubview:nameView];
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_walletName") fontSize:20 textColor:[UIColor g_boldTextColor]];
    [nameView addSubview:tipLb];
    self.nameTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:15] color:[UIColor g_textColor] placeholder:self.model.walletName];
    [nameView addSubview:self.nameTf];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(36);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(74);
    }];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18);
        make.top.offset(15);
    }];
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.bottom.offset(-5);
        make.left.offset(18);
        make.right.offset(-15);
    }];
    self.sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottomMargin.offset(-30);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
    }];
}

@end
