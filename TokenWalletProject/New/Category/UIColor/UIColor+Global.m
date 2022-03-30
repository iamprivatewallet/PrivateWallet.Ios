//
//  UIColor+Global.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "UIColor+Global.h"

@implementation UIColor (Global)

+ (UIColor *)g_successColor {
    return COLORFORRGB(0x1AC190);
}
+ (UIColor *)g_errorColor {
    return COLORFORRGB(0xDD4E41);
}
+ (UIColor *)g_warnColor {
    return COLORFORRGB(0xD87948);
}
+ (UIColor *)g_warnBgColor {
    return COLORFORRGB(0xFFEFE6);
}

+ (UIColor *)g_bgColor {
    return [UIColor whiteColor];
}
+ (UIColor *)g_primaryColor {
    return COLORFORRGB(0x12D674);
}
+ (UIColor *)g_primaryTextColor {
    return [UIColor whiteColor];
}
+ (UIColor *)g_placeholderColor {
    return COLORFORRGB(0x919CAA);
}
+ (UIColor *)g_lineColor {
    return COLORFORRGB(0xEDF0F3);
}
+ (UIColor *)g_shadowColor {
    return COLORFORRGBA(0xCCD0D6, 0.3);
}
+ (UIColor *)g_textColor {
    return COLORFORRGB(0x0A2140);
}
+ (UIColor *)g_boldTextColor {
    return COLORFORRGB(0x0B2241);
}
+ (UIColor *)g_grayTextColor {
    return COLORFORRGB(0x919CAA);
}

+ (UIColor *)g_borderColor {
    return COLORFORRGB(0xEEF0F3);
}

@end
