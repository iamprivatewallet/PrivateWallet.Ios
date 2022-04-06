//
//  WebViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "WebViewController.h"
#import "DAppsWebAlertView.h"
#import "DAppsShowAlertView.h"
#import <Web3WebView/Web3WebView.h>
#import "CustomActivity.h"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>
//@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) Web3WebView *webView;

@property (nonatomic, assign) NSInteger index;//记录加载的页数
@property (nonatomic, assign) BOOL pageBack;//判断是否点击了返回
@property (nonatomic, strong) UIButton *navLeftNavBtn;
@property (nonatomic, strong) CALayer *progresslayer;
@property (nonatomic, copy) NSDictionary *dappsDic;

@property (nonatomic, strong) BrowseRecordsModel *dataModel;

@end

@implementation WebViewController
+(instancetype)loadWebViewWithData:(BrowseRecordsModel *)data{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.dataModel = data;
    [vc setNavTitle:data.appName?:@"" isNoLine:YES];
    [vc.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:data.appUrl]]];
    return vc;
}

- (NSString *)faviconURL {
    NSString *scheme = self.webView.URL.scheme;
    if([scheme isEmptyStr]){
        scheme = @"http";
    }
    NSString *faviconURL = [NSString stringWithFormat:@"%@://%@/favicon.ico",scheme,self.webView.URL.host];
    return faviconURL;
}
- (NSString *)appName {
    return [self.dataModel.appName isEmptyStr]?self.webView.URL.absoluteString:self.dataModel.appName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeViews];
    
    NSDictionary *appRecordDic = [[VisitDAppsRecordManager sharedInstance] getDAppsWithUrl:self.dataModel.appUrl];
    if (![appRecordDic[@"noAlertAgain"] boolValue]) {
        [DAppsShowAlertView showAlertViewIsVisitExplain:YES netUrl:nil action:^(NSInteger index, BOOL isNoAlert) {
            if (index == 0) {
                //退出
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //确认
                NSDictionary *dic;
                if (isNoAlert) {
                    //不再提示
                    [[VisitDAppsRecordManager sharedInstance] deleteDAppsRecord:self.dataModel.appUrl];
                    dic = @{
                        @"noAlertAgain":@"1",
                        @"appUrl":self.dataModel.appUrl,
                        @"appName":[self appName],
                        @"description":self.dataModel.descriptionStr,
                        @"iconUrl":[self faviconURL],
                    };
                }else{
                    dic = @{
                        @"noAlertAgain":@"0",
                        @"appUrl":self.dataModel.appUrl,
                        @"appName":[self appName],
                        @"description":self.dataModel.descriptionStr,
                        @"iconUrl":[self faviconURL],
                    };
                }
                [[VisitDAppsRecordManager sharedInstance] addDAppsRecord:dic];

            }
            
        }];
    }
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeNavItem];
}
- (void)makeNavItem{
    UIView *navBgView = [ZZCustomView viewInitWithView:self.naviBar bgColor:[UIColor navAndTabBackColor]];
    navBgView.layer.cornerRadius = 17;
    navBgView.layer.borderColor = COLORFORRGB(0xd1d2d2).CGColor;
    navBgView.layer.borderWidth = 1;
    [navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar).offset(-10);
        make.bottom.equalTo(self.naviBar).offset(-10);
        make.height.equalTo(@33);
        make.width.equalTo(@85);
    }];
    
    UIButton *moreBtn = [ZZCustomView buttonInitWithView:navBgView imageName:@"detailDark"];
    [moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(navBgView);
        make.right.equalTo(navBgView.mas_centerX);
    }];
   
    UIButton *closeBtn = [ZZCustomView buttonInitWithView:navBgView imageName:@"close"];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(navBgView);
        make.left.equalTo(navBgView.mas_centerX);
    }];
    [closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [closeBtn setImageEdgeInsets: UIEdgeInsetsMake(7, 10, 7, 10)];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    UIView *line = [ZZCustomView viewInitWithView:navBgView bgColor:COLORFORRGB(0xd1d2d2)];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navBgView).offset(8);
        make.bottom.equalTo(navBgView).offset(-8);
        make.centerX.equalTo(navBgView);
        make.width.equalTo(@1);
    }];
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[Web3WebView alloc] init];
//    self.webView = [[WKWebView alloc] init];
    // UI代理
//    self.webView .UIDelegate = self;
//    // 导航代理
//    self.webView .navigationDelegate = self;
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
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)moreBtnAction{
    
    [DAppsWebAlertView showWebAlertViewWithUrl:self.dataModel.appUrl action:^(NSInteger index) {
        
        switch (index) {
            case 0:{
                //分享
                [self activityShare];
            }
                break;
            case 1:{
                //复制链接
                [UITools pasteboardWithStr:self.dataModel.appUrl toast:@"复制链接成功"];
            }
                break;
            case 2:{
                //刷新
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dataModel.appUrl]]];
            }
                break;
            case 3:{
                //切换钱包
                
            }
                break;
            case 4:{
                //收藏
                NSDictionary *dic = [[DAppsManager sharedInstance] getDAppsWithUrl:self.dataModel.appUrl];
                BOOL isCheck = [dic[@"isCollection"] boolValue];
                if (isCheck) {
                    //已收藏
                    [[DAppsManager sharedInstance] deleteDApps:self.dataModel.appUrl];
                }else{
                    //未收藏
                    NSDictionary *dic = @{
                        @"isCollection":@"1",
                        @"appUrl":self.dataModel.appUrl,
                        @"appName":[self appName],
                        @"description":self.dataModel.descriptionStr,
                        @"iconUrl":[self faviconURL],
                    };
                    [[DAppsManager sharedInstance] addDAppsCollection:dic];
                }
            }
                break;
            
            default:
                break;
        }
    }];
}

- (void)closeBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    if (!_pageBack) {//是新页面 index 就+1
//           ++_index;
//       }
//       _pageBack = NO;
//       if (_index >=2 ) {//页数大于等于2 关闭按钮就显示
//           self.leftBtn.alpha = 1;
//       }else{
//           self.leftBtn.alpha = 0;
//       }
//}
// 观察者
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
        self.titleLable.text = title;
        self.dataModel.appName = self.webView.title;
    }else if([keyPath isEqualToString:@"canGoBack"]){
        BOOL canGoBack = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.leftBtn.hidden = !canGoBack;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
}
- (void)activityShare{
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = self.webView.title;
    UIImage *shareImage = [UIImage imageNamed:@"logo"];
    NSURL *shareUrl = self.webView.URL;
    NSArray *activityItemsArray = @[shareText,shareImage,shareUrl];
    
    // 自定义的CustomActivity，继承自UIActivity
    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:shareText ActivityImage:[UIImage imageNamed:@"logo"] URL:shareUrl ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    // 3、设置回调
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        NSLog(@"activityType == %@",activityType);
        if (completed == YES) {
            NSLog(@"completed");
        }else{
            NSLog(@"cancel");
        }
    };
    activityVC.completionWithItemsHandler = itemsBlock;
    
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
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
