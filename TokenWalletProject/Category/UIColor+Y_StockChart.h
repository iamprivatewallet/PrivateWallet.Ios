//
//  UIColor+Y_StockChart.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIColor (Y_StockChart)


/*
 16进制颜色
 */
+(UIColor *)UIColorWithHexColorString:(NSString *)hexColorString AndAlpha:(CGFloat)alpha;

/*
 rgb颜色
 */
+ (UIColor *)UIColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/**
 *  根据十六进制转换成UIColor
 *
 *  @param hex UIColor的十六进制
 *
 *  @return 转换后的结果
 */


+(UIColor *)colorWithRGBHex:(UInt32)hex;


+(UIColor *)themeColor;

+(UIColor *)lightThemeColorAlpha:(CGFloat)alpha;

+(UIColor *)navAndTabBackColor;

+(NSArray *)yellowGradualChange;

+(UIColor *)monies_BrownColor;

+(UIColor *)monies_heavyYellowColor;

+(UIColor *)monies_lightYellowColor;

+(UIColor *)monies_greenColor;


+(UIColor *)monies_blueGrayColor1;

+(UIColor *)monies_blueGrayColor2;

+(UIColor *)monies_blueGrayColor3;

+(UIColor *)monies_blueGrayColor4;

+(UIColor *)monies_blueGrayColor5;

+(UIColor *)monies_buttonUnusableGrayColor;

+(UIColor *)monies_buttonUnusableBackGrayColor;

+(UIColor *)monies_unusableGrayColor;

+(UIColor *)monies_placeholderColor;

+(UIColor *)mp_payTopPinkColor;

+(UIColor *)mp_mineBackGrayColor;

+(UIColor *)mp_unusableGrayColor;

+(UIColor *)mp_homeBackColor;

+(UIColor *)supportGrayColor;

+(UIColor *)mp_separatorLinelightGrayColor;

+(UIColor *)mp_tfBackGrayColor;

+(UIColor *)im_bgViewLightGray;
+(UIColor *)im_borderLineColor;
+(UIColor *)im_textColor_nine;
+(UIColor *)im_textColor_three;
+(UIColor *)im_textColor_six;
+(UIColor *)im_btnSelectColor;
+(UIColor *)im_btnUnSelectColor;
+(UIColor *)im_textBlueColor;
+(UIColor *)im_inputBgColor;
+(UIColor *)im_inputPlaceholderColor;
+(UIColor *)im_textLightGrayColor;
+(UIColor *)im_lightGrayColor;
+(UIColor *)mp_tradePSBackGrayColor;

+(UIColor *)mp_tipGrayColor;

+(UIColor *)mp_lineLightGrayColor;

+(UIColor *)mp_tipBlueGrayColor;

+(UIColor *)mo_remarkGrayColor;

+(UIColor *)mp_detailBlueGrayColor;

+(UIColor *)im_bgBlueColor;
+(UIColor *)im_yellowColorAlpha:(CGFloat)alpha;
+(UIColor *)im_redColor;
+(UIColor *)im_blueColor;
+(UIColor *)im_grayColor;
+(UIColor *)im_tagViewColor;
+(UIColor *)im_tableBgColor;

+(UIColor *)mp_lineGrayColor;

+(UIColor *)mp_rechargeRemarkGrayColor;

+(UIColor *)mp_rateGaryColor;

+(UIColor *)mp_rechargeLightGrayColor;

+(UIColor *)mp_tradepsTitleBlueGrayColor;
+(UIColor *)mp_goodLightGrayColor;

+(UIColor *)mp_swithBackGrayColor;

+(UIColor *)mp_blueGrayColor;

+(UIColor *)mp_swithUnSelectColor;

+(UIColor *)mp_grthringUnselectGaryColor;
+(UIColor *)lucencyGrayColor;

/**
 *  所有图表的背景颜色
 */
+(UIColor *)backgroundColor;

/**
 *  辅助背景色
 */
+(UIColor *)assistBackgroundColor;

/**
 *  涨的颜色
 */
+(UIColor *)increaseColor;


/**
 *  跌的颜色
 */
+(UIColor *)decreaseColor;

+(UIColor *)timelineColor;

/**
 *  主文字颜色
 */
+(UIColor *)mainTextColor;

/**
 *  辅助文字颜色
 */
+(UIColor *)assistTextColor;

/**
 *  分时线下面的成交量线的颜色
 */
+(UIColor *)timeLineVolumeLineColor;

/**
 *  分时线界面线的颜色
 */
+(UIColor *)timeLineLineColor;

/**
 *  长按时线的颜色
 */
+(UIColor *)longPressLineColor;

/**
 *  ma5的颜色
 */
+(UIColor *)ma7Color;

/**
 *  ma30颜色
 */
+(UIColor *)ma30Color;

/**
 *  BOLL_MB颜色
 */
+(UIColor *)BOLL_MBColor;

/**
 *  BOLL_UP颜色
 */
+(UIColor *)BOLL_UPColor;

/**
 *  BOLL_DN颜色
 */
+(UIColor *)BOLL_DNColor;

@end
