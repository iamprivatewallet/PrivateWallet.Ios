//
//  PW_TokenTradeDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenTradeDetailViewController.h"
#import "PW_WebViewController.h"

@interface PW_TokenTradeDetailViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *blockView;

@end

@implementation PW_TokenTradeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_tradeDetail")];
    [self makeViews];
}
- (void)blockchainDetailAction {
    if([self.model.detaInfoUrl isNoEmpty]){
        PW_WebViewController *webVc = [[PW_WebViewController alloc] init];
        webVc.urlStr = self.model.detaInfoUrl;
        [self.navigationController pushViewController:webVc animated:YES];
    }
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
    UIImageView *stateIv = [[UIImageView alloc] init];
    [self.contentView addSubview:stateIv];
    NSString *amountStr = NSStringWithFormat(@"%@%@ %@",self.model.isOut?@"-":@"+",self.model.value,self.model.tokenName);
    UILabel *amountLb = [PW_ViewTool labelBoldText:amountStr fontSize:23 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:amountLb];
    UILabel *stateLb = [PW_ViewTool labelMediumText:@"" fontSize:14 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:stateLb];
    NSString *imageName = @"icon_trade_pending";
    stateLb.text = LocalizedStr(@"text_pending");
    if(self.model.transactionStatus<0){
        imageName = @"icon_trade_fail";
        stateLb.text = LocalizedStr(@"text_tradeFail");
        stateLb.textColor = [UIColor g_errorColor];
    }else if(self.model.transactionStatus>0){
        if (self.model.isOut) {
            imageName = @"icon_trade_out";
        }else{
            imageName = @"icon_trade_in";
        }
        stateLb.text = LocalizedStr(@"text_collectionSuccess");
        stateLb.textColor = [UIColor g_successColor];
    }
    stateIv.image = [UIImage imageNamed:imageName];
    [stateIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.offset(0);
    }];
    [stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateIv.mas_bottom).offset(2);
        make.centerX.offset(0);
    }];
    [amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLb.mas_bottom).offset(8);
        make.centerX.offset(-5);
    }];
    self.baseView = [[UIView alloc] init];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLb.mas_bottom).offset(20);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(-20);
    }];
    UIButton *detailBtn = [PW_ViewTool buttonTitle:LocalizedStr(@"text_blockchainViewDetail") fontSize:14 titleColor:[UIColor g_linkColor] imageName:nil target:self action:@selector(blockchainDetailAction)];
    [self.view addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom).offset(20);
        make.centerX.offset(0);
        make.bottomMargin.offset(-20);
    }];
    [self createBaseItems];
}
- (void)createBaseItems {
    UIView *sendView = [self createRowViewTitle:LocalizedStr(@"text_sendAddress") desc:self.model.fromAddress showCopy:YES];
    [self.baseView addSubview:sendView];
    [sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(64);
    }];
    UIView *receiveView = [self createRowViewTitle:LocalizedStr(@"text_receiveAddress") desc:self.model.toAddress showCopy:YES];
    [self.baseView addSubview:receiveView];
    [receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendView.mas_bottom);
        make.left.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(64);
    }];
    NSString *useGasToken = @"0";
    if([self.model.gasPrice isNoEmpty]&&[self.model.gasUsed isNoEmpty]){
        NSString *gwei = [self.model.gasPrice stringDownDividingBy10Power:9 scale:9];
        useGasToken = [[gwei stringDownMultiplyingBy:self.model.gasUsed decimal:9] stringDownDividingBy10Power:9 scale:9];
    }
    PW_TokenModel *mainTokenModel = [PW_GlobalData shared].mainTokenModel;
    UIView *gasFeeView = [self createRowViewTitle:LocalizedStr(@"text_minersFee") desc:NSStringWithFormat(@"%@ %@",useGasToken,mainTokenModel.tokenName) showCopy:NO];
    [self.baseView addSubview:gasFeeView];
    [gasFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiveView.mas_bottom);
        make.left.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(64);
    }];
    UIView *hashView = [self createRowViewTitle:LocalizedStr(@"text_tradeHash") desc:self.model.hashStr showCopy:YES];
    [self.baseView addSubview:hashView];
    [hashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gasFeeView.mas_bottom);
        make.left.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(64);
    }];
    UIView *blockView = [self createRowViewTitle:LocalizedStr(@"text_blockHeight") desc:@"--" showCopy:YES];
    [self.baseView addSubview:blockView];
    [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hashView.mas_bottom);
        make.left.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(64);
    }];
    UIView *timeView = [self createRowViewTitle:LocalizedStr(@"text_time") desc:[NSString timeStrTimeInterval:self.model.timeStamp] showCopy:NO showLine:NO];
    [self.baseView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blockView.mas_bottom);
        make.left.right.bottom.offset(0);
        make.height.mas_greaterThanOrEqualTo(64);
    }];
}
- (UIView *)createRowViewTitle:(NSString *)title desc:(NSString *)desc showCopy:(BOOL)showCopy {
    return [self createRowViewTitle:title desc:desc showCopy:showCopy showLine:YES];
}
- (UIView *)createRowViewTitle:(NSString *)title desc:(NSString *)desc showCopy:(BOOL)showCopy showLine:(BOOL)showLine {
    UIView *contentView = [[UIView alloc] init];
    UILabel *titleLb = [PW_ViewTool labelText:title fontSize:14 textColor:[UIColor g_grayTextColor]];
    [contentView addSubview:titleLb];
    UILabel *descLb = [PW_ViewTool labelBoldText:desc fontSize:14 textColor:[UIColor g_textColor]];
    [contentView addSubview:descLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(15);
    }];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(titleLb.mas_bottom).offset(2);
        make.right.mas_lessThanOrEqualTo(-20);
        make.bottom.mas_lessThanOrEqualTo(-15);
    }];
    if (showLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor g_lineColor];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(1);
        }];
    }
    if (showCopy) {
        UIButton *copyBtn = [PW_ViewTool buttonImageName:@"icon_copy_gray" target:nil action:nil];
        [copyBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
            [desc pasteboardToast:YES];
        }];
        [contentView addSubview:copyBtn];
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.centerY.offset(0);
        }];
    }
    return contentView;
}

@end
