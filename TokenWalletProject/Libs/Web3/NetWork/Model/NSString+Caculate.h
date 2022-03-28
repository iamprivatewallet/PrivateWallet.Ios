//
//  NSString+Caculate.h
//  CoinXman
//
//  Created by liuxuan on 2018/5/14.
//  Copyright © 2018年 liuxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Caculate)

//行情的乘
- (NSString *)hangQingstringByMultiplyingBy:(NSString *)bString Decimals:(NSInteger)Decimals;
///加
- (NSString *)stringByAdding:(NSString *)bString Decimals:(NSInteger)Decimals;
///减
- (NSString *)stringBySubtracting:(NSString *)bString Decimals:(NSInteger)Decimals;
///乘
- (NSString *)stringByMultiplyingBy:(NSString *)bString Decimals:(NSInteger)Decimals;
///乘  四舍五入
- (NSString *)stringByMultiplyingBy1:(NSString *)bString Decimals:(NSInteger)Decimals;
- (NSString *)stringByMultiplyingBy1:(NSString *)bString Decimals:(NSInteger)Decimals holdZero:(BOOL)hold;

///除
- (NSString *)stringByDividingBy:(NSString *)bString Decimals:(NSInteger)Decimals;
- (NSString *)stringByDividingBy:(NSString *)bString Decimals:(NSInteger)Decimals holdZero:(BOOL)hold;

//转十六进制
+ (NSString *)getHexByDecimal:(NSDecimalNumber *)decimal;
///指数计算btc
- (NSString *)stringByMultiplyingBySatoshi;
///指数计算eth
- (NSString *)stringByMultiplyingByGwei;
- (NSString *)stringByMultiplyingBywei;
- (NSString *)stringByMultiplyingByDecimals:(NSInteger)Decimals;
///大于
- (BOOL)isBig:(NSString *)bString;
///小于
- (BOOL)isSmall:(NSString *)bString;
///大于等于
- (BOOL)isBigEqual:(NSString *)bString;
///小于等于
- (BOOL)isSmallEqual:(NSString *)bString;
///等于
- (BOOL)isEqualValue:(NSString *)bString;
///比较两个数大小
- (NSComparisonResult)ob_compare:(NSString *)bString;
///去掉尾巴是0或者.的位数(10.000 -> 10 // 10.100 -> 10.1)
- (NSString *)ridTail;
///保留数据类型2位小数(如果是10.000 -> 10 // 10.100 -> 10.1)
+ (NSString *)formatterNumber:(NSNumber *)number;

/// 小数不四舍五入转化字符串
/// @param num 需要舍弃保留,默认2位数
+ (NSString *)notRounding:(NSNumber *)num;
/// 小数不四舍五入转化字符串
/// @param num 需要舍弃保留的位数
/// @param point 位数
+ (NSString *)notRounding:(NSNumber *)num point:(NSInteger)point;

///保留数据类型fractionDigits位小数
+ (NSString *)formatterNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;

- (NSNumber*)numberFromString;

//格式化
//删0
- (NSString *)DecimalString:(NSInteger)decimal;
//补0
- (NSString *)DecimalString1:(NSInteger)decimal;

//补0
- (NSString *)patchZero:(NSInteger)decimal number:(NSString*)numb;
@end
