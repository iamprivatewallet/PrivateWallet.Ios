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

+ (void)shareTitle:(NSString *)title subTitle:(NSString *)subTitle data:(nullable id)data;
+ (void)shareTitle:(NSString *)title subTitle:(NSString *)subTitle data:(nullable id)data completionBlock:(nullable void(^)(BOOL completed))completionBlock;
+ (void)shareIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle data:(nullable id)data completionBlock:(nullable void(^)(BOOL completed))completionBlock;

@end

NS_ASSUME_NONNULL_END
