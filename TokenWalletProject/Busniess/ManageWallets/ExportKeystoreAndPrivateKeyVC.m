//
//  ExportPrivateKeyVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ExportKeystoreAndPrivateKeyVC.h"
#import "ExportTopView.h"
#import "ExportCopyTextView.h"
#import "ExportCopyCodeView.h"
#import "brewchain.h"

@interface ExportKeystoreAndPrivateKeyVC ()
<
ExportTopViewDelegate,
UIScrollViewDelegate,
WKUIDelegate,
WKNavigationDelegate
>
@property (nonatomic, strong) ExportTopView *topView;
@property (nonatomic, strong) ExportCopyTextView *leftView;
@property (nonatomic, strong) ExportCopyCodeView *rightView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ExportKeystoreAndPrivateKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:NSStringWithFormat(@"导出%@",self.exportType==kExportTypeKeystore?@"Keystore":@"私钥")];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.rightView];
    
    [self changeValue];
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *pathURL = [NSURL fileURLWithPath:bundleStr];
    if (@available(iOS 9.0, *)) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:pathURL]];
    }
}

- (void)changeValue{
    BOOL isKeystore = self.exportType == kExportTypeKeystore;
    [self.topView setTopItemTitleWithType:isKeystore];
    if (!isKeystore) {
        [self.rightView setCodeViewIsKeystore:isKeystore data:self.wallet];
        [self.leftView setViewIsKeystore:isKeystore data:self.wallet];
    }
}

#pragma mark delegate
- (void)clickItemWithIndex:(NSInteger)index{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(index*ScreenWidth, 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > 0) {
        self.topView.bottomLine.frame = CGRectMake(scrollView.contentOffset.x/2, self.topView.height-2, ScreenWidth/2, 2);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.topView chooseItemWithIndex:scrollView.contentOffset.x/ScreenWidth];

}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *keystoreJs;
    if ([self.wallet.type isEqualToString:@"CVN"]) {
        keystoreJs = NSStringWithFormat(@"wraperExportKeystore('%@','%@')",self.wallet.priKey,self.wallet.walletPassword);
    }else{
        keystoreJs = NSStringWithFormat(@"JSON.stringify(web3.eth.accounts.privateKeyToAccount('%@').encrypt('%@'))",self.wallet.priKey,self.wallet.walletPassword);
    }
    [webView evaluateJavaScript:keystoreJs completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        BOOL isKeystore = self.exportType == kExportTypeKeystore;
        if (isKeystore) {
          [self.rightView setCodeViewIsKeystore:isKeystore data:response];
          [self.leftView setViewIsKeystore:isKeystore data:response];
        }
    }];
}
#pragma mark getter

- (ExportTopView *)topView{
    if (!_topView) {
        _topView = [[ExportTopView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, ScreenWidth, 48)];
        _topView.delegate = self;
    }
    return _topView;
}
- (ExportCopyTextView *)leftView{
    if (!_leftView) {
        _leftView = [[ExportCopyTextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.scrollView.height)];
    }
    return _leftView;
}
- (ExportCopyCodeView *)rightView{
    if (!_rightView) {
        _rightView = [[ExportCopyCodeView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.height)];
    }
    return _rightView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, ScreenWidth, SCREEN_HEIGHT-self.topView.bottom)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.canCancelContentTouches = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-kNavBarAndStatusBarHeight-48);
    }
    return _scrollView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
