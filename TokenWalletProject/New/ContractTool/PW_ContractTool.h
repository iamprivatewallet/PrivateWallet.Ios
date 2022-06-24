//
//  PW_ContractTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/3.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_ContractTool : NSObject

+ (void)loadETHBalance:(PW_TokenModel *)model completion:(void (^)(NSString *amount))completion;
+ (void)loadETHMainBalanceDecimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion;
+ (void)loadETHTokenBalance:(NSString *)tokenAddress decimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion;

+ (void)loadCVNBalance:(PW_TokenModel *)model completion:(void (^)(NSString *amount))completion;
+ (void)loadCVNMainBalanceDecimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion;
+ (void)loadCVNTokenBalance:(NSString *)tokenAddress decimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion;

@end

NS_ASSUME_NONNULL_END
