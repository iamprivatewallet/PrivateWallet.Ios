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

- (UIColor *)alpha:(CGFloat)alpha;

+ (UIColor *)g_hex:(NSString *)hexStr;
+ (UIColor *)g_hex:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (UIColor *)g_randomColor;

+ (UIColor *)g_successColor;
+ (UIColor *)g_errorColor;
+ (UIColor *)g_warnColor;
+ (UIColor *)g_warnBgColor;
+ (UIColor *)g_linkColor;
+ (UIColor *)g_wrongColor;

+ (UIColor *)g_roseColor;
+ (UIColor *)g_fallColor;

+ (UIColor *)g_bgColor;
+ (UIColor *)g_bgCardColor;
+ (UIColor *)g_darkBgColor;
+ (UIColor *)g_darkGradientStartColor;
+ (UIColor *)g_darkGradientEndColor;
+ (UIColor *)g_grayBgColor;
+ (UIColor *)g_primaryColor;
+ (UIColor *)g_primaryTextColor;
+ (UIColor *)g_placeholderColor;
+ (UIColor *)g_placeholderWhiteColor;
+ (UIColor *)g_lineColor;
+ (UIColor *)g_shadowColor;
+ (UIColor *)g_shadowGrayColor;
+ (UIColor *)g_shadowPrimaryColor;
+ (UIColor *)g_textColor;
+ (UIColor *)g_whiteTextColor;
+ (UIColor *)g_boldTextColor;
+ (UIColor *)g_grayTextColor;
+ (UIColor *)g_lightTextColor;

+ (UIColor *)g_primaryNFTColor;

+ (UIColor *)g_segmentedColor;

+ (UIColor *)g_borderColor;
+ (UIColor *)g_borderDarkColor;
+ (UIColor *)g_borderGrayColor;
+ (UIColor *)g_dottedColor;
+ (UIColor *)g_maskColor;

@end

NS_ASSUME_NONNULL_END
