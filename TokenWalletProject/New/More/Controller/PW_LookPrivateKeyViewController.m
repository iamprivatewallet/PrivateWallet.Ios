//
//  PW_LookPrivateKeyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_LookPrivateKeyViewController.h"

@interface PW_LookPrivateKeyViewController ()

@property (nonatomic, strong) UILabel *privateKeyLb;
@property (nonatomic, strong) UIButton *lookBtn;
@property (nonatomic, strong) UIButton *myCopyBtn;

@property (nonatomic, assign) BOOL isLook;

@end

@implementation PW_LookPrivateKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_lookPrivateKey")];
    [self makeViews];
    [RACObserve(self, isLook) subscribeNext:^(NSNumber * _Nullable x) {
        self.lookBtn.hidden = x.boolValue;
        self.privateKeyLb.hidden = self.myCopyBtn.hidden = !x.boolValue;
    }];
}
- (void)lookAction {
    [PW_TipTool showBackupTipPrivateKeySureBlock:^{
        self.isLook = YES;
    }];
}
- (void)copyAction {
    [self.model.priKey pasteboardToast:YES];
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
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_privateKey") fontSize:20 textColor:[UIColor g_textColor]];
    [contentView addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_privateKeyWalletTip") fontSize:15 textColor:[UIColor g_grayTextColor]];
    [contentView addSubview:descLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(38);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(18);
        make.left.offset(38);
        make.right.offset(-38);
    }];
    UIView *privateKeyView = [[UIView alloc] init];
    privateKeyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH-72, 110) gradientColors:@[[UIColor g_darkGradientStartColor],[UIColor g_darkGradientEndColor]] gradientType:PW_GradientLeftToRight cornerRadius:8]];
    [contentView addSubview:privateKeyView];
    self.privateKeyLb = [PW_ViewTool labelSemiboldText:self.model.priKey fontSize:13 textColor:[UIColor g_whiteTextColor]];
    [privateKeyView addSubview:self.privateKeyLb];
    self.myCopyBtn = [PW_ViewTool buttonImageName:@"icon_copy_primary" target:self action:@selector(copyAction)];
    [privateKeyView addSubview:self.myCopyBtn];
    self.lookBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_clickLookPrivateKey") fontSize:18 titleColor:[UIColor g_whiteTextColor] imageName:nil target:self action:@selector(lookAction)];
    [privateKeyView addSubview:self.lookBtn];
    [privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLb.mas_bottom).offset(20);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(110);
    }];
    [self.privateKeyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    [self.myCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.right.offset(-15);
    }];
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_privateKeyWalletDesc") fontSize:13 textColor:[UIColor g_textColor]];
    [contentView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privateKeyView.mas_bottom).offset(25);
        make.left.offset(36);
        make.right.offset(-36);
    }];
}

@end
