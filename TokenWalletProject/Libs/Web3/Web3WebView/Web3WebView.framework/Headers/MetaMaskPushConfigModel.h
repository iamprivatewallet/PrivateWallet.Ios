//
//  DSPushConfigModel.h
//  DSWKWebView
//
//  Created by 张强 on 2020/10/9.
//

#import <Foundation/Foundation.h>
#import <Web3WebView/MetaMaskEvent.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetaMaskPushConfigModel : MetaMaskEvent
@property (nonatomic, assign) BOOL isUnlocked;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy) NSString *selectedAddress;
@property (nonatomic, copy) NSString *networkVersion;
@property (nonatomic, copy) NSString *chainId;


@end

NS_ASSUME_NONNULL_END
