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
    self.descLb.text = NSStringWithFormat(@"(%@)",self.model.tokenName);
    self.tokenFullNameLb.text = self.model.tokenTitle;
    self.websiteLb.text = self.model.webUrl;
    self.contractAddressLb.text = self.model.tokenContract;
//    self.tokenTotalLb.text = self.model.;
    self.releaseTimeLb.text = self.model.tokenTime;
}
- (void)requestData {
    [self.view showLoadingIndicator];
    [self pw_requestApi:WalletTokenItemURL params:@{@"tokenId":self.tokenId} completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        self.model = [PW_TokenModel mj_objectWithKeyValues:data];
        [self refreshUI];
    } errBlock:^(NSString * _Nonnull msg) {
        [self.view hideLoadingIndicator];
        [self showError:msg];
    }];
}
- (void)makeViews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bgView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [bgView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
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
        make.top.offset(25);
        make.centerX.offset(0);
        make.size.mas_equalTo(85);
    }];
    self.titleLb = [PW_ViewTool labelBoldText:@"--" fontSize:22 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:self.titleLb];
    self.descLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:self.descLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIv.mas_bottom).offset(2);
        make.right.equalTo(self.descLb.mas_left).offset(-8);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.titleLb);
        make.left.equalTo(self.contentView.mas_centerX).offset(0);
    }];
    self.baseView = [[UIView alloc] init];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLb.mas_bottom).offset(30);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    self.releaseView = [[UIView alloc] init];
    [self.contentView addSubview:self.releaseView];
    [self.releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(160);
        make.bottom.offset(-40);
    }];
    [self createBaseItems];
    [self createReleaseItems];
}
- (void)createBaseItems {
    UIView *basicInfoView = [[UIView alloc] init];
    [self.baseView addSubview:basicInfoView];
    [basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(82);
    }];
    UILabel *titleLb = [PW_ViewTool labelText:LocalizedStr(@"text_baseInfo") fontSize:14 textColor:[UIColor g_textColor]];
    [basicInfoView addSubview:titleLb];
    UILabel *fullNameTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_tokenName") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [basicInfoView addSubview:fullNameTipLb];
    self.tokenFullNameLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_boldTextColor]];
    [basicInfoView addSubview:self.tokenFullNameLb];
    UIView *line1View = [[UIView alloc] init];
    line1View.backgroundColor = [UIColor g_lineColor];
    [basicInfoView addSubview:line1View];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(fullNameTipLb.mas_top).offset(-8);
        make.left.offset(0);
    }];
    [fullNameTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(basicInfoView.mas_centerY).offset(2);
        make.left.offset(0);
    }];
    [self.tokenFullNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fullNameTipLb.mas_bottom).offset(2);
        make.left.offset(0);
        make.right.mas_lessThanOrEqualTo(0);
    }];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
    UIView *websiteView = [[UIView alloc] init];
    [self.baseView addSubview:websiteView];
    [websiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(basicInfoView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(66);
    }];
    UILabel *websiteTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_webSite") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [websiteView addSubview:websiteTipLb];
    self.websiteLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_linkColor]];
    [websiteView addSubview:self.websiteLb];
    UIButton *copyWebsiteBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyWebsiteAction)];
    [copyWebsiteBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [websiteView addSubview:copyWebsiteBtn];
    UIView *line2View = [[UIView alloc] init];
    line2View.backgroundColor = [UIColor g_lineColor];
    [websiteView addSubview:line2View];
    [websiteTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(websiteView.mas_centerY).offset(-2);
        make.left.offset(0);
    }];
    [self.websiteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(websiteView.mas_centerY).offset(2);
        make.left.offset(0);
        make.right.mas_lessThanOrEqualTo(-25);
    }];
    [copyWebsiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
    UIView *addressView = [[UIView alloc] init];
    [self.baseView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(websiteView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(66);
        make.bottom.offset(0);
    }];
    UILabel *contractAddressTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_contractAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [addressView addSubview:contractAddressTipLb];
    self.contractAddressLb = [PW_ViewTool labelBoldText:@"--" fontSize:12 textColor:[UIColor g_boldTextColor]];
    [addressView addSubview:self.contractAddressLb];
    UIButton *copyContractAddressBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyContractAddressAction)];
    [copyContractAddressBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [addressView addSubview:copyContractAddressBtn];
    UIView *line3View = [[UIView alloc] init];
    line3View.backgroundColor = [UIColor g_lineColor];
    [addressView addSubview:line3View];
    [contractAddressTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressView.mas_centerY).offset(-2);
        make.left.offset(0);
    }];
    [self.contractAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_centerY).offset(2);
        make.left.offset(0);
        make.right.mas_lessThanOrEqualTo(-25);
    }];
    [copyContractAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
}
- (void)createReleaseItems {
    UIView *releaseInfoView = [[UIView alloc] init];
    [self.releaseView addSubview:releaseInfoView];
    [releaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(82);
    }];
    UILabel *titleLb = [PW_ViewTool labelText:LocalizedStr(@"text_releaseInfo") fontSize:14 textColor:[UIColor g_textColor]];
    [self.releaseView addSubview:titleLb];
    UILabel *tokenTotalTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_tokenTotal") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.releaseView addSubview:tokenTotalTipLb];
    self.tokenTotalLb = [PW_ViewTool labelBoldText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
    [self.baseView addSubview:self.tokenTotalLb];
    UIView *line1View = [[UIView alloc] init];
    line1View.backgroundColor = [UIColor g_lineColor];
    [releaseInfoView addSubview:line1View];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tokenTotalTipLb.mas_top).offset(-8);
        make.left.offset(0);
    }];
    [tokenTotalTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(releaseInfoView.mas_centerY).offset(2);
        make.left.offset(0);
    }];
    [self.tokenTotalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tokenTotalTipLb.mas_bottom).offset(2);
        make.left.offset(0);
    }];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
    UIView *releaseTimeView = [[UIView alloc] init];
    [self.releaseView addSubview:releaseTimeView];
    [releaseTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(releaseInfoView.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(66);
    }];
    UILabel *releaseTimeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_releaseTime") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [releaseTimeView addSubview:releaseTimeTipLb];
    self.releaseTimeLb = [PW_ViewTool labelBoldText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
    [releaseTimeView addSubview:self.releaseTimeLb];
    [releaseTimeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(releaseTimeView.mas_centerY).offset(-2);
        make.left.offset(0);
    }];
    [self.releaseTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(releaseTimeView.mas_centerY).offset(2);
        make.left.offset(0);
    }];
}

@end
