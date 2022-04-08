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

+ (void)shareTitle:(nullable NSString *)title iamge:(nullable UIImage *)image urlStr:(nullable NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
