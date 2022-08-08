//
//  PW_ConfirmPurchaseNFTAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ConfirmPurchaseNFTAlertViewController.h"

@interface PW_ConfirmPurchaseNFTAlertViewController ()

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *priceLb;

@end

@implementation PW_ConfirmPurchaseNFTAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
}
- (void)sureAction {
    if (self.sureBlock) {
        self.sureBlock();
    }
}
#pragma mark - views
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(284);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_confirmPurchase") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:titleLb];
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    [self.contentView addSubview:closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-30);
        make.width.height.mas_equalTo(24);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_primaryColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(55);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(1);
    }];
    UILabel *nameTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_NFTName") fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:nameTipLb];
    [self.contentView addSubview:self.nameLb];
    UILabel *priceTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_transferAmount") fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:priceTipLb];
    [self.contentView addSubview:self.priceLb];
    [nameTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.offset(30);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.equalTo(nameTipLb.mas_bottom).offset(6);
    }];
    [priceTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLb.mas_bottom).offset(18);
        make.left.offset(30);
    }];
    [self.priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.top.equalTo(priceTipLb.mas_bottom).offset(6);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLb.mas_bottom).offset(28);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(50);
        make.bottom.offset(-PW_SafeBottomInset-10);
    }];
}
#pragma mark - lazy
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:16 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:16 textColor:[UIColor g_textColor]];
    }
    return _priceLb;
}

@end
