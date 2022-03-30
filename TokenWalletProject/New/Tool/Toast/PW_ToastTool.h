//
//  PW_ToastTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/30.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_ToastTool : NSObject

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSucees:(NSString *)success toView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
