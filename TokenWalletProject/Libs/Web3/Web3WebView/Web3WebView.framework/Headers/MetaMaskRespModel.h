//
//  DSRespModel.h
//  DSWKWebView
//
//  Created by 张强 on 2020/10/9.
//

#import <Web3WebView/MetaMaskPushConfigModel.h>
#import <Web3WebView/DSError.h>
NS_ASSUME_NONNULL_BEGIN

@interface MetaMaskRespModel : NSObject
{
    NSString *_id;
}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *jsonrpc;
@property (nonatomic, strong) id result;
@property (nonatomic, copy) NSString *rawResponse;
@property (nonatomic, strong) DSError *error;
@end

NS_ASSUME_NONNULL_END
