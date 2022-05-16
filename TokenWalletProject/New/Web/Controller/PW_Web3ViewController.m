//
//  PW_Web3ViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_Web3ViewController.h"
#import <Web3WebView/Web3WebView.h>
#import "DAppsShowAlertView.h"
#import "CustomActivity.h"
#import "DAppsWebAlertView.h"
#import "PW_WebViewController.h"
#import "PW_WalletListView.h"

@interface PW_Web3ViewController ()

@property (nonatomic, strong) UIView *navContentView;
@property (nonatomic, strong) Web3WebView *webView;
@property (nonatomic, strong) CALayer *progresslayer;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *descLb;

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation PW_Web3ViewController

- (NSString *)faviconURL {
    NSString *scheme = self.webView.URL.scheme;
    if(![scheme isNoEmpty]){
        scheme = @"http";
    }
    NSString *faviconURL = [NSString stringWithFormat:@"%@://%@/favicon.ico",scheme,self.webView.URL.host];
    return faviconURL;
}
- (NSString *)currentURL {
    NSURL *cURL = self.webView.URL;
    NSString *scheme = cURL.scheme;
    if(![scheme isNoEmpty]){
        scheme = @"https";
    }
    return [NSString stringWithFormat:@"%@://%@",scheme,(cURL.host?cURL.host:[NSURL URLWithString:self.model.appUrl].host)];
}
- (NSString *)currentUrlAbsoluteStr {
    NSString *urlStr = self.webView.URL.absoluteString;
    return [urlStr isNoEmpty]?urlStr:self.model.appUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
    NSString *urlStr = self.model.appUrl;
    if (![urlStr isURL]) {
        urlStr = PW_StrFormat(@"https://%@",urlStr);
    }
    self.model.appUrl = urlStr;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    if (![self.model.iconUrl isNoEmpty]) {
        self.model.iconUrl = [self faviconURL];
    }
    self.titleLb.text = self.model.appName;
    self.descLb.text = [self currentURL];
    if ([self.model.appUrl isNoEmpty]) {
        [[PW_DappManager shared] saveModel:self.model];
    }
}
- (void)makeViews{
    UIView *navBarView = [[UIView alloc] init];
    navBarView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:navBarView];
    [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(kNavBarAndStatusBarHeight);
    }];
    self.navContentView = [[UIView alloc] init];
    [navBarView addSubview:self.navContentView];
    [self.navContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(kNavBarHeight);
    }];
    [self createNavItems];
    self.webView = [[Web3WebView alloc] init];
//    self.webView = [[WKWebView alloc] init];
    // UI代理
//    self.webView.UIDelegate = self;
//    // 导航代理
//    self.webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(navBarView.mas_bottom);
    }];
    
    self.progresslayer = [[CALayer alloc] init];
    self.progresslayer.frame = CGRectMake(0, kNavBarAndStatusBarHeight, ScreenWidth*0.1, 3);
    self.progresslayer.backgroundColor = [UIColor g_primaryColor].CGColor;
    [self.view.layer addSublayer:self.progresslayer];

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)createNavItems {
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close_dark" target:self action:@selector(closeAction)];
    [self.navContentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.offset(0);
    }];
    self.backBtn = [PW_ViewTool buttonImageName:@"icon_back" target:self action:@selector(backAction)];
    self.backBtn.hidden = YES;
    [self.navContentView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(closeBtn.mas_right).offset(20);
        make.centerY.offset(0);
    }];
    UIView *btnsView = [[UIView alloc] init];
    [btnsView setBorderColor:[UIColor g_borderColor] width:1 radius:17];
    [self.navContentView addSubview:btnsView];
    [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
        make.height.offset(34);
        make.width.offset(88);
        make.centerY.offset(0);
    }];
    UIView *spaceLineView = [[UIView alloc] init];
    spaceLineView.backgroundColor = [UIColor g_borderColor];
    [btnsView addSubview:spaceLineView];
    [spaceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(18);
        make.width.offset(0.5);
        make.center.offset(0);
    }];
    UIButton *walletBtn = [PW_ViewTool buttonImageName:@"icon_wallet_dark" target:self action:@selector(walletAction)];
    [btnsView addSubview:walletBtn];
    UIButton *moreBtn = [PW_ViewTool buttonImageName:@"icon_more_dark" target:self action:@selector(moreAction)];
    [btnsView addSubview:moreBtn];
    [walletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
    }];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(walletBtn.mas_right);
        make.top.right.bottom.offset(0);
        make.width.equalTo(walletBtn);
    }];
    self.titleLb = [PW_ViewTool labelSemiboldText:@"" fontSize:15 textColor:[UIColor g_boldTextColor]];
    self.titleLb.numberOfLines = 1;
    [self.navContentView addSubview:self.titleLb];
    self.descLb = [PW_ViewTool labelBoldText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
    self.descLb.numberOfLines = 1;
    [self.navContentView addSubview:self.descLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.navContentView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(btnsView.mas_left).offset(-10);
    }];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom);
        make.centerX.offset(0);
        make.right.mas_lessThanOrEqualTo(btnsView.mas_left).offset(-10);
    }];
}
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (void)walletAction {
    [PW_WalletListView show];
}
- (void)moreAction {
    __weak typeof(self) weakSelf = self;
    PW_DappMoreModel *refreshModel = [PW_DappMoreModel ModelIconName:@"icon_refresh_dark" title:LocalizedStr(@"text_refresh") actionBlock:^(PW_DappMoreModel * _Nonnull model) {
        [weakSelf.webView reload];
    }];
    PW_DappMoreModel *copyModel = [PW_DappMoreModel ModelIconName:@"icon_link_dark" title:LocalizedStr(@"text_copyURL") actionBlock:^(PW_DappMoreModel * _Nonnull model) {
        [[weakSelf currentUrlAbsoluteStr] pasteboardToast:YES];
    }];
    PW_DappMoreModel *shareModel = [PW_DappMoreModel ModelIconName:@"icon_share_dark" title:LocalizedStr(@"text_share") actionBlock:^(PW_DappMoreModel * _Nonnull model) {
        NSURL *url = [NSURL URLWithString:[self.model.iconUrl isNoEmpty]?self.model.iconUrl:[self faviconURL]];
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [PW_ShareTool shareIcon:image title:weakSelf.model.appName subTitle:[weakSelf currentURL] data:[NSURL URLWithString:[weakSelf currentURL]] completionBlock:nil];
        }];
    }];
    PW_DappMoreModel *browserModel = [PW_DappMoreModel ModelIconName:@"icon_browser_dark" title:LocalizedStr(@"text_browserOpen") actionBlock:^(PW_DappMoreModel * _Nonnull model) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self currentUrlAbsoluteStr]] options:@{} completionHandler:nil];
    }];
    PW_DappMoreModel *reportModel = [PW_DappMoreModel ModelIconName:@"icon_report_dark" title:LocalizedStr(@"text_report") actionBlock:^(PW_DappMoreModel * _Nonnull model) {
        PW_WebViewController *vc = [[PW_WebViewController alloc] init];
        vc.titleStr = model.title;
        vc.urlStr = WalletReportUrl;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [PW_TipTool showDappMoreTitle:PW_StrFormat(LocalizedStr(@"text_moreDappTip"),[self currentURL]) dataArr:@[refreshModel,copyModel,shareModel,browserModel,reportModel] sureBlock:^(PW_DappMoreModel * _Nonnull model) {
        if (model.actionBlock) {
            model.actionBlock(model);
        }
    }];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        float floatNum = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        self.progresslayer.frame = CGRectMake(0, kNavBarAndStatusBarHeight, ScreenWidth*floatNum, 2);
        if (floatNum == 1) {
            __weak __typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.progresslayer.frame = CGRectMake(0, kNavBarAndStatusBarHeight, 0, 3);
            });
        }
    }else if([keyPath isEqualToString:@"title"]){
        NSString *title = self.webView.title;
        self.titleLb.text = title;
        self.descLb.text = [self currentURL];
        if (![self.model.appName isNoEmpty]||[self.model.appName isEqualToString:self.model.appUrl]) {
            self.model.appName = self.webView.title;
            [[PW_DappManager shared] updateModel:self.model];
        }
    }else if([keyPath isEqualToString:@"canGoBack"]){
        BOOL canGoBack = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.backBtn.hidden = !canGoBack;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
}

@end
