//
//  DSControlManager.h
//  DSWebViewDemo
//
//  Created by 张强 on 2020/10/10.
//

#import <Foundation/Foundation.h>
@class Web3WebView;
@class MetaMaskPushConfigModel;
NS_ASSUME_NONNULL_BEGIN

@interface DSControlManager : NSObject
@property (nonatomic, strong) Web3WebView *webView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isFrame;

- (void)onChange;

@end

NS_ASSUME_NONNULL_END
