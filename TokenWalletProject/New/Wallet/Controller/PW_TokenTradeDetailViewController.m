//
//  PW_TokenTradeDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenTradeDetailViewController.h"
#import "BrowseWebViewController.h"

@interface PW_TokenTradeDetailViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *blockView;

@end

@implementation PW_TokenTradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_collectionSuccess")];
    [self makeViews];
}
- (void)copySendAction {
    [self.model.fromAddress pasteboardToast:YES];
}
- (void)copyReceiveAction {
    [self.model.toAddress pasteboardToast:YES];
}
- (void)copyHashAction {
    [self.model.hashStr pasteboardToast:YES];
}
- (void)blockchainDetailAction {
    if([self.model.detaInfoUrl isNoEmpty]){
        BrowseWebViewController *webVc = [[BrowseWebViewController alloc] init];
        webVc.title = @"详细信息";
        webVc.urlStr = self.model.detaInfoUrl;
        [self.navigationController pushViewController:webVc animated:YES];
    }
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    UIImageView *stateIv = [[UIImageView alloc] init];
    stateIv.image = [UIImage imageNamed:self.model.isOut?@"icon_roll_out_big":@"icon_roll_in_big"];
    [self.contentView addSubview:stateIv];
    NSString *amountStr = NSStringWithFormat(@"%@%@",self.model.isOut?@"-":@"+",self.model.value);
    UILabel *amountLb = [PW_ViewTool labelSemiboldText:amountStr fontSize:32 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:amountLb];
    UILabel *unitLb = [PW_ViewTool labelSemiboldText:self.model.tokenName fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:unitLb];
    NSString *stateStr = self.model.transactionStatus==0?LocalizedStr(@"text_pending"):(self.model.transactionStatus==1?LocalizedStr(@"text_collectionSuccess"):LocalizedStr(@"text_tradeFail"));
    UILabel *stateLb = [PW_ViewTool labelMediumText:stateStr fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:stateLb];
    [stateIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(45);
        make.centerX.offset(0);
    }];
    [amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateIv.mas_bottom).offset(22);
        make.centerX.offset(-5);
    }];
    [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLb);
        make.left.equalTo(amountLb.mas_right).offset(1);
    }];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLb.mas_bottom).offset(5);
        make.centerX.offset(0);
    }];
    self.baseView = [[UIView alloc] init];
    [self.baseView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLb.mas_bottom).offset(38);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    self.blockView = [[UIView alloc] init];
    [self.blockView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:self.blockView];
    [self.blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_bottom).offset(15);
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-20);
    }];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:LocalizedStr(@"text_blockchainViewDetail") forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(blockchainDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont pw_semiBoldFontOfSize:14];
    [self.view addSubview:detailBtn];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.offset(0);
    }];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom).offset(20);
        make.centerX.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
    [self createBaseItems];
    [self createBlockItems];
}
- (void)createBaseItems {
    UILabel *sendTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_sendAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.baseView addSubview:sendTipLb];
    UILabel *sendAddressLb = [PW_ViewTool labelSemiboldText:self.model.fromAddress fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:sendAddressLb];
    UIButton *copySendBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copySendAction)];
    [copySendBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.baseView addSubview:copySendBtn];
    UILabel *receiveTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_receiveAddress") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.baseView addSubview:receiveTipLb];
    UILabel *receiveAddressLb = [PW_ViewTool labelSemiboldText:self.model.toAddress fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:receiveAddressLb];
    UIButton *copyReceiveBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyReceiveAction)];
    [copyReceiveBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.baseView addSubview:copyReceiveBtn];
    UILabel *minersFeeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.baseView addSubview:minersFeeTipLb];
    NSString *useGasToken = @"0";
    if([self.model.gasPrice isNoEmpty]){
        NSString *gwei = [self.model.gasPrice stringDownDividingBy10Power:self.model.tokenDecimals scale:9];
        useGasToken = [gwei stringDownMultiplyingBy:self.model.gasUsed decimal:8];
    }
    UILabel *minersFeeLb = [PW_ViewTool labelSemiboldText:NSStringWithFormat(@"%@ %@",useGasToken,self.model.tokenName) fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.baseView addSubview:minersFeeLb];
    [sendTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.left.offset(18);
    }];
    [sendAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [copySendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sendAddressLb.mas_right).offset(8);
        make.centerY.equalTo(sendAddressLb);
        make.right.mas_lessThanOrEqualTo(-18);
    }];
    [receiveTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendAddressLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [receiveAddressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiveTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [copyReceiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiveAddressLb.mas_right).offset(8);
        make.centerY.equalTo(receiveAddressLb);
        make.right.mas_lessThanOrEqualTo(-18);
    }];
    [minersFeeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiveAddressLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeTipLb.mas_bottom).offset(5);
        make.left.offset(18);
        make.bottom.offset(-24);
    }];
}
- (void)createBlockItems {
    UILabel *hashTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_tradeHash") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.blockView addSubview:hashTipLb];
    UILabel *hashLb = [PW_ViewTool labelSemiboldText:self.model.hashStr fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.blockView addSubview:hashLb];
    UIButton *copyHashBtn = [PW_ViewTool buttonImageName:@"icon_copy" target:self action:@selector(copyHashAction)];
    [copyHashBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.blockView addSubview:copyHashBtn];
    UILabel *blockHeightTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_blockHeight") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.blockView addSubview:blockHeightTipLb];
    UILabel *blockHeightLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.blockView addSubview:blockHeightLb];
    UILabel *timeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_time") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.blockView addSubview:timeTipLb];
    UILabel *timeLb = [PW_ViewTool labelSemiboldText:[NSString timeStrTimeInterval:self.model.timeStamp] fontSize:12 textColor:[UIColor g_boldTextColor]];
    [self.blockView addSubview:timeLb];
    [hashTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18);
        make.left.offset(18);
    }];
    [hashLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hashTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [copyHashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hashLb.mas_right).offset(8);
        make.centerY.equalTo(hashLb);
        make.right.mas_lessThanOrEqualTo(-18);
    }];
    [blockHeightTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hashLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [blockHeightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blockHeightTipLb.mas_bottom).offset(5);
        make.left.offset(18);
    }];
    [timeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blockHeightLb.mas_bottom).offset(18);
        make.left.offset(18);
    }];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeTipLb.mas_bottom).offset(5);
        make.left.offset(18);
        make.bottom.offset(-24);
    }];
}

@end
