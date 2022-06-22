//
//  PW_CollectionViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_CollectionViewController.h"
#import "SGQRCode.h"
#import "PW_SharePayTool.h"
#import "PW_ChooseCurrencyViewController.h"

@interface PW_CollectionViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *tipLb;

@property (nonatomic, strong) UIView *tokenView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *subNameLb;

@property (nonatomic, strong) UIImageView *qrIv;
@property (nonatomic, strong) UILabel *addressLb;

@end

@implementation PW_CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@""];
    [self setupFullBackground];
    [self makeViews];
    [self refreshUI];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)changeTokenAction {
    PW_ChooseCurrencyViewController *vc = [[PW_ChooseCurrencyViewController alloc] init];
    vc.selectedTokenContract = self.model.tokenContract;
    vc.chooseBlock = ^(PW_TokenModel * _Nonnull model) {
        self.model = model;
        [self refreshUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)shareAction {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    [PW_SharePayTool showPayMeViewWithAddress:walletAddress name:self.model.tokenName];
}
- (void)copyAction {
    [self.model.tokenContract pasteboardToast:YES];
}
- (void)refreshUI {
    self.tipLb.text = NSStringWithFormat(LocalizedStr(@"text_transferAssetsTip"),self.model.tokenName);
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:self.model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.nameLb.text = self.model.tokenName;
    self.subNameLb.text = [self.model.tokenName lowercaseString];
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    self.addressLb.text = walletAddress;
//    NSString *tokenAddress = self.model.tokenContract;
//    NSString *str;
//    if (![walletAddress isEqualToString:tokenContract]) {
//        str = NSStringWithFormat(@"ethereum:%@?contractAddress=%@",walletAddress,tokenAddress);
//    }else{
//        str = NSStringWithFormat(@"ethereum:%@",walletAddress);
//    }
    self.qrIv.image = [SGQRCodeObtain generateQRCodeWithData:[CATCommon JSONString:walletAddress] size:190];
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
        make.height.mas_greaterThanOrEqualTo(scrollView);
    }];
//    self.tokenView = [[UIView alloc] init];
//    self.tokenView.backgroundColor = [UIColor g_bgColor];
//    [self.tokenView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
//    self.tokenView.layer.cornerRadius = 21;
//    [self.tokenView addTapTarget:self action:@selector(changeTokenAction)];
//    [self.view addSubview:self.tokenView];
//    [self.tokenView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
//        make.left.offset(20);
//        make.height.offset(42);
//    }];
    UILabel *titleLb = [PW_ViewTool labelMediumText:NSStringWithFormat(@"%@ %@",self.model.tokenName,LocalizedStr(@"text_collection")) fontSize:25 textColor:[UIColor g_whiteTextColor]];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.centerX.offset(0);
    }];
    UIView *qrView = [[UIView alloc] init];
    [self.contentView addSubview:qrView];
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(25);
        make.centerX.offset(0);
        make.size.mas_equalTo(290);
    }];
    UIImageView *scanIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_scan_big"]];
    [qrView addSubview:scanIv];
    [scanIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.qrIv = [[UIImageView alloc] init];
    [qrView addSubview:self.qrIv];
    [self.qrIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(190);
    }];
    UIView *addressView = [[UIView alloc] init];
    [addressView setBorderColor:[UIColor g_hex:@"#FBAE17"] width:1 radius:8];
    [self.contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrView.mas_bottom).offset(25);
        make.width.offset(266);
        make.centerX.offset(0);
    }];
    UILabel *addressTipLb = [PW_ViewTool labelBoldText:LocalizedStr(@"text_walletAddress") fontSize:20 textColor:[UIColor g_whiteTextColor]];
    [addressView addSubview:addressTipLb];
    [addressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.centerX.offset(0);
    }];
    self.addressLb = [PW_ViewTool labelBoldText:@"--" fontSize:14 textColor:[UIColor g_whiteTextColor]];
    self.addressLb.numberOfLines = 1;
    self.addressLb.textAlignment = NSTextAlignmentCenter;
    self.addressLb.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [addressView addSubview:self.addressLb];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressTipLb.mas_bottom).offset(2);
        make.left.offset(45);
        make.right.offset(-45);
        make.bottom.offset(-20);
    }];
    self.tipLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor g_whiteTextColor]];
    self.tipLb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tipLb];
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(addressView.mas_bottom).offset(44);
    }];
    UIView *shareView = [self createBtnViewTitle:LocalizedStr(@"text_share") imageName:@"icon_share_logo" action:@selector(shareAction)];
    [self.contentView addSubview:shareView];
    UIView *copyView = [self createBtnViewTitle:LocalizedStr(@"text_copy") imageName:@"icon_copy_logo" action:@selector(copyAction)];
    [self.contentView addSubview:copyView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLb.mas_bottom).offset(20);
        make.left.offset(36);
        make.height.mas_equalTo(55);
        make.bottom.mas_lessThanOrEqualTo(-SafeBottomInset-20);
    }];
    [copyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareView.mas_right).offset(25);
        make.top.bottom.width.height.equalTo(shareView);
        make.right.offset(-36);
    }];
}
- (UIView *)createBtnViewTitle:(NSString *)title imageName:(NSString *)imageName action:(SEL)action {
    UIView *contentView = [[UIView alloc] init];
    [contentView setBorderColor:[UIColor g_primaryColor] width:1 radius:8];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [iconIv setRequiredHorizontal];
    [contentView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    UILabel *titleLb = [PW_ViewTool labelText:title fontSize:18 textColor:[UIColor g_whiteTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(12);
        make.centerY.offset(0);
        make.right.mas_lessThanOrEqualTo(0);
    }];
    [contentView addTapTarget:self action:action];
    return contentView;
}
//- (void)createTokenItems {
//    self.iconIv = [[UIImageView alloc] init];
//    [self.tokenView addSubview:self.iconIv];
//    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
//    [self.tokenView addSubview:self.nameLb];
//    self.subNameLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
//    [self.tokenView addSubview:self.subNameLb];
//    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_black"]];
//    [self.tokenView addSubview:arrowIv];
//    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(25);
//        make.left.offset(15);
//        make.centerY.offset(0);
//    }];
//    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconIv.mas_right).offset(10);
//        make.centerY.offset(0);
//    }];
//    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLb.mas_right).offset(5);
//        make.bottom.equalTo(self.nameLb);
//    }];
//    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.subNameLb.mas_right).offset(18);
//        make.centerY.offset(0);
//        make.right.offset(-20);
//    }];
//}

@end
