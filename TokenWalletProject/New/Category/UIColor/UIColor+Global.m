//
//  UIColor+Global.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "UIColor+Global.h"

@implementation UIColor (Global)

- (UIColor *)alpha:(CGFloat)alpha {
    return [self colorWithAlphaComponent:alpha];
}

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
+ (UIColor *)g_randomColor {
    int R = (arc4random() % 256);
    int G = (arc4random() % 256);
    int B = (arc4random() % 256);
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

+ (UIColor *)g_successColor {
    return [UIColor g_hex:@"#1BD779"];
}
+ (UIColor *)g_errorColor {
    return [UIColor g_hex:@"#C1272D"];
}
+ (UIColor *)g_warnColor {
    return COLORFORRGB(0xD87948);
}
+ (UIColor *)g_warnBgColor {
    return [UIColor g_hex:@"#FFEEF1"];
}
+ (UIColor *)g_linkColor {
    return [UIColor g_hex:@"#1C6DF7"];
}

+ (UIColor *)g_roseColor {
    if ([PW_RedRoseGreenFellTool isOpen]) {
        return [UIColor g_hex:@"#C1272D"];
    }
    return [UIColor g_hex:@"#1BD779"];
}
+ (UIColor *)g_fallColor {
    if ([PW_RedRoseGreenFellTool isOpen]) {
        return [UIColor g_hex:@"#1BD779"];
    }
    return [UIColor g_hex:@"#C1272D"];
}

+ (UIColor *)g_bgColor {
    return [UIColor whiteColor];
}
+ (UIColor *)g_bgCardColor {
    return [self g_hex:@"#FAFAFA"];
}
+ (UIColor *)g_darkBgColor {
    return [self g_hex:@"#333333"];
}
+ (UIColor *)g_darkGradientStartColor {
    return [self g_hex:@"#4D4D4D"];
}
+ (UIColor *)g_darkGradientEndColor {
    return [self blackColor];
}
+ (UIColor *)g_grayBgColor {
    return [self g_hex:@"#F4F6F9"];
}
+ (UIColor *)g_primaryColor {
    return [self g_hex:@"#09EC87"];
}
+ (UIColor *)g_primaryTextColor {
    return [UIColor whiteColor];
}
+ (UIColor *)g_placeholderColor {
    return COLORFORRGB(0x919CAA);
}
+ (UIColor *)g_lineColor {
    return [UIColor g_hex:@"#F5F5F5"];
}
+ (UIColor *)g_shadowColor {
    return COLORFORRGBA(0xCCD0D6, 0.3);
}
+ (UIColor *)g_textColor {
    return [UIColor g_hex:@"#333333"];
}
+ (UIColor *)g_whiteTextColor {
    return [UIColor whiteColor];
}
+ (UIColor *)g_boldTextColor {
    return [self g_textColor];
}
+ (UIColor *)g_grayTextColor {
    return [UIColor g_hex:@"#999999"];
}
+ (UIColor *)g_lightTextColor {
    return [UIColor colorWithWhite:1.0 alpha:0.7];
}

+ (UIColor *)g_borderColor {
    return [self g_hex:@"#F2F2F2"];
}
+ (UIColor *)g_borderDarkColor {
    return [self g_hex:@"#999999"];
}
+ (UIColor *)g_borderGrayColor {
    return [self g_hex:@"#E6E6E6"];
}
+ (UIColor *)g_dottedColor {
    return COLORFORRGB(0xB0B8C4);
}
+ (UIColor *)g_maskColor {
    return [self g_hex:@"#000000" alpha:0.7];
}

@end
