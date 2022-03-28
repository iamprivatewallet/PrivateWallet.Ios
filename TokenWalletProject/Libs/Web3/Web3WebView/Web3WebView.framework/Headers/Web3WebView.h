//
//  DSWebView.h
//  DSWKWebView
//
//  Created by 张强 on 2020/10/9.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@class MetaMaskPushConfigModel;
@class DSEvent;

@interface Web3WebView : WKWebView

@property (nonatomic, strong) MetaMaskPushConfigModel *config;

- (instancetype)initWithFrame:(CGRect)frame config:(MetaMaskPushConfigModel *)config;
//加载url
- (void)loadUrl: (NSString * _Nonnull) url;


- (void)postMessageWithModel:(DSEvent *)model;

/**
 * 调用javascript方法
 * @param methodName
 * 方法名
 * @param args
 * 参数名
 * @param completionHandler
 * 回调
 **/
-(void)callHandler:(NSString * _Nonnull) methodName arguments:(NSArray * _Nullable)args completionHandler:(void (^ _Nullable)(id _Nullable value))completionHandler;

/**
 * 收到关闭当前web回调
 **/
- (void)setJavascriptCloseWindowListener:(void(^_Nullable)(void))callback;

/**
 * 清理webview
 **/
+ (void)clearWebViewWithWebView:(Web3WebView *)webView;
/**
 * webvie登录状态改变
 **/
+ (void)changeState;
@end

NS_ASSUME_NONNULL_END
