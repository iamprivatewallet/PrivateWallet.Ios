//
//  PW_TokenInfoViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenInfoViewController.h"
#import "PW_TokenModel.h"

@interface PW_TokenInfoViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *releaseView;

@property (nonatomic, strong) UILabel *tokenFullNameLb;
@property (nonatomic, strong) UILabel *websiteLb;
@property (nonatomic, strong) UILabel *contractAddressLb;
@property (nonatomic, strong) UILabel *tokenTotalLb;
@property (nonatomic, strong) UILabel *releaseTimeLb;

@property (nonatomic, strong) PW_TokenModel *model;

@end

@implementation PW_TokenInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_tokenInfo")];
    [self makeViews];
    [self requestData];
}
- (void)copyWebsiteAction {
    [self.model.webUrl pasteboardToast:YES];
}
- (void)copyContractAddressAction {
    [self.model.tokenContract pasteboardToast:YES];
}
- (void)refreshUI {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:self.model.tokenLogo] placeholderImage:[UIImage imageNamed:@"icon_token_default"]];
    self.titleLb.text = self.model.tokenName;
    self.descLb.text = self.model.tokenName;
    self.tokenFullNameLb.text = self.model.tokenTitle;
    self.websiteLb.text = self.model.webUrl;
    self.contractAddressLb.text = self.model.tokenContract;
//    self.tokenTotalLb.text = self.model.;
    self.releaseTimeLb.text = self.model.tokenTime;
}
- (void)requestData {
    [self.view showLoadingIndicator];
    [self requestApi:WalletTokenItemURL params:@{@"tokenId":self.tokenId} completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        self.model = [PW_TokenModel mj_objectWithKeyValues:data];
        [self refreshUI];
    } errBlock:^(NSString * _Nonnull msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.centerX.offset(0);
        make.size.mas_equalTo(65);
    }];
    self.titleLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:32 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(22);
        make.centerX.offset(0);
    }];
    self.descLb = [PW_ViewTool labelMediumText:@"--" fontSize:16 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:self.descLb];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(6);
        make.centerX.offset(0);
    }];
    self.baseView = [[UIView alloc] init];
    [self.baseView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLb.mas_bottom).offset(30);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    self.releaseView = [[UIView alloc] init];
    [self.releaseView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.releaseView];
    [self.releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(160);
        make.bottom.offset(-40);
    }];
    [self createBaseItems];
    [self createReleaseItems];
}
- (void)createBaseItems {
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_baseInfo") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:titleLb];
    UILabel *fullNameTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_tokenFullName") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.baseView addSubview:fullNameTipLb];
    self.tokenFullNameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:self.tokenFullNameLb];
    UILabel *websiteTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_website") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.baseView addSubview:websiteTipLb];
    self.websiteLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_primaryColor]];
    [self.baseView addSubview:self.websiteLb];
    UIButton *copyWebsiteBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyWebsiteAction)];
    [copyWebsiteBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.baseView addSubview:copyWebsiteBtn];
    UILabel *contractAddressTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_contractAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.baseView addSubview:contractAddressTipLb];
    self.contractAddressLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:self.contractAddressLb];
    UIButton *copyContractAddressBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyContractAddressAction)];
    [copyContractAddressBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.baseView addSubview:copyContractAddressBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(18);
    }];
    [fullNameTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(12);
        make.left.offset(18);
    }];
    [self.tokenFullNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fullNameTipLb.mas_bottom).offset(5);
        make.left.offset(18);
        make.right.mas_lessThanOrEqualTo(-18);
    }];
    [websiteTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tokenFullNameLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [self.websiteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(websiteTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [copyWebsiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.websiteLb.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(-18);
        make.centerY.equalTo(self.websiteLb);
    }];
    [contractAddressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.websiteLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [self.contractAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contractAddressTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [copyContractAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contractAddressLb.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(-18);
        make.bottom.offset(-24);
        make.centerY.equalTo(self.contractAddressLb);
    }];
}
- (void)createReleaseItems {
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_releaseInfo") fontSize:13 textColor:[UIColor g_boldTextColor]];
    [self.releaseView addSubview:titleLb];
    UILabel *tokenTotalTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_tokenTotal") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.releaseView addSubview:tokenTotalTipLb];
    self.tokenTotalLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:self.tokenTotalLb];
    UILabel *releaseTimeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_releaseTime") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.releaseView addSubview:releaseTimeTipLb];
    self.releaseTimeLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:13 textColor:[UIColor g_primaryColor]];
    [self.releaseView addSubview:self.releaseTimeLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(18);
    }];
    [tokenTotalTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom).offset(12);
        make.left.offset(18);
    }];
    [self.tokenTotalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tokenTotalTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [releaseTimeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tokenTotalLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [self.releaseTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(releaseTimeTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
}

@end
