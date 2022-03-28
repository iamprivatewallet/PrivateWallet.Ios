//
//  NetworkTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/17.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTool : NSObject

+ (void)requestWallet:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock;

@end

NS_ASSUME_NONNULL_END
