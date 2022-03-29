//
//  UIColor+Y_StockChart.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "UIColor+Y_StockChart.h"

@implementation UIColor (Y_StockChart)

+(UIColor *)UIColorWithHexColorString:(NSString *)hexColorString AndAlpha:(CGFloat)alpha {
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:alpha];
}

+ (UIColor *)UIColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red / 255.0f)
                           green:(green / 255.0f)
                            blue:(blue / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+(UIColor *)lucencyGrayColor{
    return [UIColor UIColorWithHexColorString:@"#D0D3D3" AndAlpha:0.2];
}

#pragma mark 主题色
+(UIColor *)themeColor{
    return [UIColor colorWithRGBHex:0xFDB200];
}


+(UIColor *)lightThemeColorAlpha:(CGFloat)alpha{
    return [UIColor UIColorWithHexColorString:@"#EC125E" AndAlpha:alpha];
}

+(UIColor *)navAndTabBackColor{
    return COLORFORRGB(0xfafcfc);
}
+(UIColor *)im_blueColor{
    return COLORFORRGB(0x12D674);
}
+(UIColor *)im_redColor{
    return COLORFORRGB(0xf37678);
}
+(UIColor *)im_tagViewColor{
    return COLOR(250, 250, 251);
}
+(UIColor *)im_grayColor{
    return COLOR(134, 146, 154);
}
+(UIColor *)im_tableBgColor{
    return COLOR(242, 243, 245);
}
+(NSArray *)yellowGradualChange{
    return @[COLORFORRGB(0xFFD200),COLORFORRGB(0xF5A309)];
}

+(UIColor *)monies_BrownColor{
    return COLORFORRGB(0x4C3000);
}

+(UIColor *)monies_heavyYellowColor{
    return COLORFORRGB(0xFDB200);
}

+(UIColor *)monies_lightYellowColor{
    return COLORFORRGB(0xFDDF01);
}

+(UIColor *)monies_greenColor{
    return COLORFORRGB(0x21D987);
}


+(UIColor *)monies_blueGrayColor1{
    return COLORFORRGB(0x424857);
}

+(UIColor *)monies_blueGrayColor2{
    return COLORFORRGB(0x5B616F);
}

+(UIColor *)monies_blueGrayColor3{
    return COLORFORRGB(0x717684);
}

+(UIColor *)monies_blueGrayColor4{
    return COLORFORRGB(0xB2BACE);
}

+(UIColor *)monies_blueGrayColor5{
    return COLORFORRGB(0xCED5E5);
}

+(UIColor *)monies_buttonUnusableGrayColor{
    return COLORFORRGB(0x7C653D);
}

+(UIColor *)monies_buttonUnusableBackGrayColor{
    return COLORFORRGB(0x474235);
}

+(UIColor *)monies_unusableGrayColor{
    return COLORFORRGB(0x80899F);
}

+(UIColor *)monies_placeholderColor{
    return COLORFORRGB(0x5B616F);
}

+(UIColor *)mp_payTopPinkColor{
    return COLORFORRGB(0xF5E2EB);
}

+(UIColor *)mp_mineBackGrayColor{
    return COLORFORRGB(0xFAFAFC);
}

+(UIColor *)mp_unusableGrayColor{
    return [UIColor colorWithRGBHex:0xA8B5D2];
}

+(UIColor *)mp_homeBackColor{
    return [UIColor colorWithRGBHex:0xF7F7FA];
}

+(UIColor *)supportGrayColor
{
    return [UIColor colorWithRGBHex:0xA8B5D2];
}

+(UIColor *)mp_separatorLinelightGrayColor{
    return [UIColor colorWithRGBHex:0xF6F3F3];
}

+(UIColor *)mp_tfBackGrayColor{
    return [UIColor colorWithRGBHex:0xF4F4F4];
}
+(UIColor *)im_borderLineColor{
    return COLOR(241, 242, 248);
}
+(UIColor *)im_bgBlueColor{
    return COLORFORRGB(0x10d574);
}
+(UIColor *)im_yellowColorAlpha:(CGFloat)alpha{
    return COLORFORRGBA(0xf6bc5f, alpha);
}
+(UIColor *)im_bgViewLightGray{
    return COLORFORRGB(0xfbfcfc);
}
+(UIColor *)im_textLightGrayColor{
    return COLORFORRGB(0x75798a);
}
+(UIColor *)im_textColor_nine{
    return COLORFORRGB(0x999999);
}
+(UIColor *)im_textColor_three{
    return COLORFORRGB(0x333333);
}
+(UIColor *)im_textColor_six{
    return COLORFORRGB(0x666666);
}
+(UIColor *)im_btnUnSelectColor{
    return COLORA(234, 235, 245,0.8);
}
+(UIColor *)im_lightGrayColor{
    return COLORFORRGB(0xc2c7cb);
}
+(UIColor *)im_btnSelectColor{
    return COLORFORRGB(0x10d574);
}
+(UIColor *)im_textBlueColor{
    return COLORFORRGB(0x1a82fb);
}
+(UIColor *)im_inputBgColor{
    return COLORA(250, 250, 252,0.8);
}
+(UIColor *)im_inputPlaceholderColor{
    return COLORFORRGB(0xbcc3c6);
}
+(UIColor *)mp_tradePSBackGrayColor{
    return [UIColor colorWithRGBHex:0xF5F5F5];
}

+(UIColor *)mp_tipGrayColor{
    return [UIColor colorWithRGBHex:0x9095B5];
}

+(UIColor *)mp_lineLightGrayColor{
    return [UIColor colorWithRGBHex:0xF5F3F3];
}

+(UIColor *)mp_tipBlueGrayColor{
    return [UIColor colorWithRGBHex:0x212C68];
}

+(UIColor *)mo_remarkGrayColor{
    return COLORFORRGB(0x8D8B8B);
}

+(UIColor *)mp_detailBlueGrayColor{
    return COLORFORRGB(0xAEBAD5);
}



+(UIColor *)mp_lineGrayColor{
    return [UIColor UIColorWithHexColorString:@"EAE6E6" AndAlpha:1];
}

+(UIColor *)mp_rechargeRemarkGrayColor{
     return COLORFORRGB(0xC6C6C6);
}

+(UIColor *)mp_rateGaryColor{
    return COLORFORRGB(0x949494);
}

+(UIColor *)mp_rechargeLightGrayColor{
    return COLORFORRGB(0xF7F7F7);
}


+(UIColor *)mp_tradepsTitleBlueGrayColor{
    return COLORFORRGB(0x061F53);
}


+(UIColor *)mp_goodLightGrayColor{
    return COLORFORRGB(0x5A5A5A);
}
+(UIColor *)mp_swithBackGrayColor{
    return COLORFORRGB(0xC7C7C7);
}

+(UIColor *)mp_blueGrayColor{
    return [UIColor UIColorWithHexColorString:@"#4D5078" AndAlpha:1];
}


+(UIColor *)mp_swithUnSelectColor{
    return [UIColor UIColorWithHexColorString:@"#374177" AndAlpha:1];
}


+(UIColor *)mp_grthringUnselectGaryColor{
    return [UIColor UIColorWithHexColorString:@"#A2A2A2" AndAlpha:1];
}

#pragma mark 所有图表的背景颜色
+(UIColor *)backgroundColor
{
//    return [UIColor colorWithRGBHex:0x181c20];
    return [UIColor whiteColor];
}

#pragma mark 辅助背景色
+(UIColor *)assistBackgroundColor
{
//    return [UIColor colorWithRGBHex:0x1d2227];
    return [UIColor whiteColor];
}

#pragma mark 涨的颜色
+(UIColor *)increaseColor
{
    return [UIColor colorWithRGBHex:0xF96B46];
}

#pragma mark 跌的颜色
+(UIColor *)decreaseColor
{
    return [UIColor colorWithRGBHex:0x28AC8E];
}

#pragma mark 主文字颜色
+(UIColor *)mainTextColor
{
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark 辅助文字颜色
+(UIColor *)assistTextColor
{
    return [UIColor colorWithRGBHex:0x565a64];
}

#pragma mark 分时线下面的成交量线的颜色
+(UIColor *)timeLineVolumeLineColor
{
    return [UIColor colorWithRGBHex:0x2d333a];
}

#pragma mark 分时线界面线的颜色
+(UIColor *)timeLineLineColor
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor
{
//    return [UIColor colorWithRGBHex:0xff5353];
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark ma5的颜色
+(UIColor *)ma7Color
{
    return [UIColor colorWithRGBHex:0xff783c];
}

#pragma mark ma30颜色
+(UIColor *)timelineColor
{
    return [UIColor colorWithRGBHex:0xE7B448];
}

+(UIColor *)ma30Color
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark BOLL_MB的颜色
+(UIColor *)BOLL_MBColor
{
    return [UIColor whiteColor];
}

#pragma mark BOLL_UP的颜色
+(UIColor *)BOLL_UPColor
{
    return [UIColor purpleColor];
}

#pragma mark BOLL_DN的颜色
+(UIColor *)BOLL_DNColor
{
    return [UIColor greenColor];
}





@end
