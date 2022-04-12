//
//  UIColor+Global.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "UIColor+Global.h"

@implementation UIColor (Global)

+ (UIColor *)g_hex:(NSString *)hexStr {
    return [self g_hex:hexStr alpha:1];
}
+ (UIColor *)g_hex:(NSString *)hexStr alpha:(CGFloat)alpha {
    if([hexStr hasPrefix:@"0x"]){
        hexStr = [hexStr substringFromIndex:2];
    }else if ([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    if (hexStr.length != 6) {
        return [UIColor clearColor];
    }
    NSRange range = NSMakeRange(0, 2);
    NSString *redStr = [hexStr substringWithRange:range];
    range.location = 2;
    NSString *greenStr = [hexStr substringWithRange:range];
    range.location = 4;
    NSString *blueStr = [hexStr substringWithRange:range];
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redStr] scanHexInt:&red];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&green];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&blue];
    return [UIColor colorWithRed:red / 255.0f  green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

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
+ (UIColor *)g_lightTextColor {
    return [UIColor colorWithWhite:1.0 alpha:0.7];
}

+ (UIColor *)g_borderColor {
    return COLORFORRGB(0xEEF0F3);
}
+ (UIColor *)g_dottedColor {
    return COLORFORRGB(0xB0B8C4);
}
+ (UIColor *)g_maskColor {
    return COLORFORRGBA(0x112947,0.4);
}

@end
