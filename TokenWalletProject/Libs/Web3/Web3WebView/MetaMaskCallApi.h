//
//  DSCallApi.h
//  DSWebViewDemo
//
//  Created by 张强 on 2020/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MetaMaskRepModel;
@class MetaMaskRespModel;
@interface MetaMaskCallApi : NSObject

/**
 * 统一回调方法
 */
- (void)rpcHandler:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler;

@end

NS_ASSUME_NONNULL_END
