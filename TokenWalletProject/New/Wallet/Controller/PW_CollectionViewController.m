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

@property (nonatomic, strong) UIImageView *topBgIv;

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
    
    [self setNavNoLineTitle:LocalizedStr(@"text_collection")];
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
    [PW_SharePayTool showPayMeViewWithAddress:self.model.tokenContract name:self.model.tokenName];
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
    self.qrIv.image = [SGQRCodeObtain generateQRCodeWithData:[CATCommon JSONString:walletAddress] size:170];
}
- (void)makeViews {
    self.topBgIv = [[UIImageView alloc] init];
    self.topBgIv.image = [UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH, 248) gradientColors:@[[UIColor g_hex:@"#2A8094"],[UIColor g_hex:@"#195179"]] gradientType:PW_GradientLeftToRight];
    [self.view insertSubview:self.topBgIv atIndex:0];
    self.tokenView = [[UIView alloc] init];
    self.tokenView.backgroundColor = [UIColor g_bgColor];
    [self.tokenView setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    self.tokenView.layer.cornerRadius = 21;
    [self.tokenView addTapTarget:self action:@selector(changeTokenAction)];
    [self.view addSubview:self.tokenView];
    [self.topBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(248);
    }];
    [self.tokenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.offset(20);
        make.height.offset(42);
    }];
    [self createTokenItems];
    [self createWarnView];
    [self createQrCodeView];
}
- (void)createTokenItems {
    self.iconIv = [[UIImageView alloc] init];
    [self.tokenView addSubview:self.iconIv];
    self.nameLb = [PW_ViewTool labelMediumText:@"--" fontSize:18 textColor:[UIColor g_boldTextColor]];
    [self.tokenView addSubview:self.nameLb];
    self.subNameLb = [PW_ViewTool labelMediumText:@"--" fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.tokenView addSubview:self.subNameLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_dark"]];
    [self.tokenView addSubview:arrowIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(10);
        make.centerY.offset(0);
    }];
    [self.subNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(5);
        make.bottom.equalTo(self.nameLb);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subNameLb.mas_right).offset(18);
        make.centerY.offset(0);
        make.right.offset(-20);
    }];
}
- (void)createWarnView {
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_warning_light"]];
    [self.view addSubview:iconIv];
    self.tipLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:14 textColor:[UIColor whiteColor]];
    [self.view addSubview:self.tipLb];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.equalTo(self.tokenView.mas_bottom).offset(16);
    }];
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconIv);
        make.left.equalTo(iconIv.mas_right).offset(6);
    }];
}
- (void)createQrCodeView {
    UIView *qrView = [[UIView alloc] init];
    qrView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:qrView];
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgIv.mas_bottom).offset(-32);
        make.left.right.bottom.offset(0);
    }];
    [qrView setRadius:32 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIView *qrBodyView = [[UIView alloc] init];
    [qrBodyView setBorderColor:[UIColor g_borderColor] width:1 radius:15];
    [qrView addSubview:qrBodyView];
    [qrBodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(200);
        make.top.offset(60);
        make.centerX.offset(0);
    }];
    self.qrIv = [[UIImageView alloc] init];
    [qrBodyView addSubview:self.qrIv];
    [self.qrIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(170);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_walletAddress") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [qrBodyView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrBodyView.mas_bottom).offset(15);
        make.centerX.offset(0);
    }];
    self.addressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:16 textColor:[UIColor g_boldTextColor]];
    self.addressLb.textAlignment = NSTextAlignmentCenter;
    [qrView addSubview:self.addressLb];
    [self.addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(20);
        make.left.offset(CGFloatScale(65));
        make.right.offset(CGFloatScale(-65));
    }];
    UIButton *shareBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_share") fontSize:17 titleColor:[UIColor g_boldTextColor] imageName:@"icon_share_primary" target:self action:@selector(shareAction)];
    [shareBtn setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [shareBtn setBorderColor:[UIColor g_borderColor] width:1 radius:27.5];
    [qrView addSubview:shareBtn];
    UIButton *copyBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_copy") fontSize:17 titleColor:[UIColor g_boldTextColor] imageName:@"icon_copy_primary" target:self action:@selector(copyAction)];
    [copyBtn setShadowColor:[UIColor g_shadowColor] offset:CGSizeMake(0, 2) radius:8];
    [copyBtn setBorderColor:[UIColor g_borderColor] width:1 radius:27.5];
    [qrView addSubview:copyBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLb.mas_bottom).offset(22);
        make.height.offset(55);
        make.width.offset(140);
        make.right.equalTo(qrView.mas_centerX).offset(-10);
    }];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareBtn);
        make.left.equalTo(shareBtn.mas_right).offset(20);
        make.height.offset(55);
        make.width.offset(140);
    }];
}

@end
