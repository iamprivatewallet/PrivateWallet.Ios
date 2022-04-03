//
//  UIColor+Global.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Global)

+ (UIColor *)g_hex:(NSString *)hexStr;
+ (UIColor *)g_hex:(NSString *)hexStr alpha:(CGFloat)alpha;

+ (UIColor *)g_successColor;
+ (UIColor *)g_errorColor;
+ (UIColor *)g_warnColor;
+ (UIColor *)g_warnBgColor;

+ (UIColor *)g_bgColor;
+ (UIColor *)g_primaryColor;
+ (UIColor *)g_primaryTextColor;
+ (UIColor *)g_placeholderColor;
+ (UIColor *)g_lineColor;
+ (UIColor *)g_shadowColor;
+ (UIColor *)g_textColor;
+ (UIColor *)g_boldTextColor;
+ (UIColor *)g_grayTextColor;

+ (UIColor *)g_borderColor;
+ (UIColor *)g_maskColor;

@end

NS_ASSUME_NONNULL_END
