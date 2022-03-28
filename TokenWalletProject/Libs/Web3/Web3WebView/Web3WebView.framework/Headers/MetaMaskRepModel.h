//
//  DSRepModel.h
//  DSWKWebView
//
//  Created by 张强 on 2020/10/9.
//

#import <Web3WebView/MetaMaskPushConfigModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetaMaskRepModel : NSObject
{
NSString *_id;
}
@property (nonatomic, copy) NSString *jsonrpc;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, assign) BOOL toNative;
@end

NS_ASSUME_NONNULL_END
