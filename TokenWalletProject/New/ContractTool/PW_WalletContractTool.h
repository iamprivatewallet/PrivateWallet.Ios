//
//  PW_WalletContractTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/7.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletContractTool : NSObject

+ (void)estimateGasToAddress:(nullable NSString *)address completionHandler:(void (^)(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc))completionHandler;
+ (void)estimateGasTokenToAddress:(nullable NSString *)address token:(nullable NSString *)token completionHandler:(void (^)(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc))completionHandler;
+ (void)getBalanceDecimals:(NSUInteger)decimals completionHandler:(void (^)(NSString * _Nullable balance, NSString * _Nullable errorDesc))completionHandler;
+ (void)balanceOfAddress:(nullable NSString *)address contractAddress:(NSString *)contractAddress completionHandler:(void (^)(NSString * _Nullable balance, NSString * _Nullable errorDesc))completionHandler;
+ (void)symbolContractAddress:(nullable NSString *)contractAddress completionHandler:(void (^)(NSString * _Nullable balance, NSString * _Nullable errorDesc))completionHandler;
+ (void)decimalsContractAddress:(nullable NSString *)contractAddress completionHandler:(void (^)(NSInteger decimals, NSString * _Nullable errorDesc))completionHandler;

@end

NS_ASSUME_NONNULL_END
