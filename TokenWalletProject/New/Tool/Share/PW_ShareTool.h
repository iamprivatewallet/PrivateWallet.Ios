//
//  PW_ShareTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_ShareTool : NSObject

+ (void)shareTitle:(nullable NSString *)title image:(nullable UIImage *)image urlStr:(nullable NSString *)urlStr;
+ (void)shareTitle:(nullable NSString *)title image:(nullable UIImage *)image urlStr:(nullable NSString *)urlStr completionBlock:(nullable void(^)(BOOL completed))completionBlock;

@end

NS_ASSUME_NONNULL_END
