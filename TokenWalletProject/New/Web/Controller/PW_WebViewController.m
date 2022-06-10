//
//  PW_WebViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WebViewController.h"

@interface PW_WebViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) CALayer *progresslayer;

@end

@implementation PW_WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:self.titleStr isNoLine:NO];
    [self makeViews];
}
- (void)makeViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
    
    self.progresslayer = [[CALayer alloc]init];
    self.progresslayer.frame = CGRectMake(0, kNavBarAndStatusBarHeight, ScreenWidth*0.1, 3);
    self.progresslayer.backgroundColor = [UIColor im_blueColor].CGColor;
    [self.view.layer addSublayer:self.progresslayer];

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
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
        self.titleLable.text = title;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
