//
//  PW_PutawayAuctionNFTAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PutawayAuctionNFTAlertViewController.h"
#import "PW_ConfirmNFTAlertViewController.h"

@interface PW_PutawayAuctionNFTAlertViewController ()

@property (nonatomic, strong) UITextField *priceTf;
@property (nonatomic, strong) UILabel *unitLb;

@end

@implementation PW_PutawayAuctionNFTAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
}
- (void)sureAction {
    PW_ConfirmNFTAlertViewController *vc = [[PW_ConfirmNFTAlertViewController alloc] init];
    vc.titleStr = LocalizedStr(@"text_confirmOffer");
    vc.descStr = PW_StrFormat(LocalizedStr(@"text_putawayAuctionTip"),@"0.01ETH");
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - views
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(250);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_auction") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:titleLb];
    [self.contentView addSubview:self.closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UIView *transferView = [[UIView alloc] init];
    transferView.backgroundColor = [UIColor g_bgCardColor];
    [transferView setBorderColor:[UIColor g_borderColor] width:1 radius:6];
    [self.contentView addSubview:transferView];
    [transferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(94);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_setPrice") fontSize:16 textColor:[UIColor g_textColor]];
    [transferView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(12);
    }];
    [transferView addSubview:self.priceTf];
    [transferView addSubview:self.unitLb];
    [self.priceTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.equalTo(self.unitLb.mas_left).offset(-10);
        make.top.offset(50);
        make.bottom.offset(-12);
    }];
    [self.unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.priceTf);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(transferView.mas_bottom).offset(15);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(50);
        make.bottom.offset(-PW_SafeBottomInset-10);
    }];
}
#pragma mark - lazy
- (UITextField *)priceTf {
    if (!_priceTf) {
        _priceTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputPrice")];
        _priceTf.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _priceTf;
}
- (UILabel *)unitLb {
    if (!_unitLb) {
        _unitLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
        [_unitLb setRequiredHorizontal];
    }
    return _unitLb;
}

@end
