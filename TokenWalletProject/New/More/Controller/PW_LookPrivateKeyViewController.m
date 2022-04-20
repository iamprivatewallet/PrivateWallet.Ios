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
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_privateKey") fontSize:15 textColor:[UIColor g_boldTextColor]];
    [self.view addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_privateKeyWalletTip") fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.view addSubview:descLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(30);
        make.left.offset(25);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(6);
        make.left.offset(25);
        make.right.offset(-25);
    }];
    UIView *privateKeyView = [[UIView alloc] init];
    privateKeyView.backgroundColor = [UIColor g_bgColor];
    [privateKeyView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [privateKeyView setBorderColor:[UIColor g_borderColor] width:2 radius:8];
    [self.view addSubview:privateKeyView];
    self.privateKeyLb = [PW_ViewTool labelSemiboldText:self.model.priKey fontSize:12 textColor:[UIColor g_grayTextColor]];
    [privateKeyView addSubview:self.privateKeyLb];
    self.myCopyBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyAction)];
    [privateKeyView addSubview:self.myCopyBtn];
    self.lookBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_clickLookPrivateKey") fontSize:15 titleColor:[UIColor g_textColor] cornerRadius:17.5 backgroundColor:[UIColor g_bgColor] target:self action:@selector(lookAction)];
    [self.lookBtn setBorderColor:[UIColor g_borderColor] width:1 radius:17.5];
    [privateKeyView addSubview:self.lookBtn];
    [privateKeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLb.mas_bottom).offset(20);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(144);
    }];
    [self.privateKeyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(180);
        make.height.offset(35);
        make.center.offset(0);
    }];
    [self.myCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.right.offset(-10);
    }];
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_privateKeyWalletDesc") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.view addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privateKeyView.mas_bottom).offset(20);
        make.left.offset(25);
        make.right.offset(-25);
    }];
}

@end
