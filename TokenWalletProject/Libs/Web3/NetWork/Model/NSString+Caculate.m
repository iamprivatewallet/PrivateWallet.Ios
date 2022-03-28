
//
//  NSString+Caculate.m
//  CoinXman
//
//  Created by liuxuan on 2018/5/14.
//  Copyright © 2018年 liuxuan. All rights reserved.
//

#define IsValidString(string) (string && [string isKindOfClass:[NSString class]] && [string length])
#define IsEmptyString(string) (string && [string isKindOfClass:[NSString class]] && [string length] == 0)

#import "NSString+Caculate.h"

@implementation NSString (Caculate)

- (NSString *)stringByAdding:(NSString *)bString Decimals:(NSInteger)Decimals{
    NSString *aString = self;
    if (IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:bString];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:Decimals raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberByAdding:num_2 withBehavior:handel];
    NSString *rid = [num_3.stringValue ridTail];
    return rid;
}
- (NSString *)stringBySubtracting:(NSString *)bString Decimals:(NSInteger)Decimals{
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:bString];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:Decimals raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberBySubtracting:num_2 withBehavior:handel];
    NSString *rid = [num_3.stringValue ridTail];
    return rid;
}

- (NSString *)hangQingstringByMultiplyingBy:(NSString *)bString Decimals:(NSInteger)Decimals{
    NSString *aString = self;
    if (IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:bString];
    
    
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:Decimals raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberByMultiplyingBy:num_2 withBehavior:handel];
    NSString *rid = [num_3.stringValue ridTail];
    return rid;
}


- (NSString *)stringByMultiplyingBy:(NSString *)bString Decimals:(NSInteger)Decimals{
    NSString *aString = self;
    if (IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:bString];
    
    
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:Decimals raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberByMultiplyingBy:num_2 withBehavior:handel];
    NSString *rid = [num_3.stringValue ridTail];
    return rid;
}

//四舍五入
- (NSString *)stringByMultiplyingBy1:(NSString *)bString Decimals:(NSInteger)Decimals{
    return [self stringByMultiplyingBy1:bString Decimals:Decimals holdZero:NO];
}

- (NSString *)stringByMultiplyingBy1:(NSString *)bString Decimals:(NSInteger)Decimals holdZero:(BOOL)hold {
    
    NSString *aString = self;
    if (IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:bString];
    
    
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:Decimals raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *num_3 = [num_1 decimalNumberByMultiplyingBy:num_2 withBehavior:handel];
    NSString *rid = @"";
    if ( hold ){
        rid = [self patchZero:Decimals number:num_3.stringValue];
    }else {
        rid = [num_3.stringValue ridTail];
    }
    return rid;

}

- (NSString *)stringByDividingBy:(NSString *)bString Decimals:(NSInteger)Decimals {
    return [self stringByDividingBy:bString Decimals:Decimals holdZero:false];
}
- (NSString *)stringByDividingBy:(NSString *)bString Decimals:(NSInteger)Decimals holdZero:(BOOL)hold{
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    if ([[bString ridTail] isEqualToString:@"0"]) {
//        NSLog(@"除数为0");
        return @"0";
    }
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:aString];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:bString];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:Decimals raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberByDividingBy:num_2 withBehavior:handel];
    NSString *rid = @"";
    if ( hold ){
        rid = [self patchZero:Decimals number:num_3.stringValue];
    }else {
        rid = [num_3.stringValue ridTail];
    }
    return rid;
}


- (NSString *)stringByMultiplyingByGwei
{
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingByPowerOf10:9];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    return  cString;
}

- (NSString *)stringByMultiplyingBywei
{
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingByPowerOf10:18];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    return  cString;
}

- (NSString *)stringByMultiplyingByDecimals:(NSInteger)Decimals
{
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingByPowerOf10:Decimals];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    return  cString;
}

- (NSString *)stringByMultiplyingBySatoshi
{
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingByPowerOf10:8];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    return  cString;
}
+ (NSString *)getHexByDecimal:(NSDecimalNumber *)decimal {
    //10进制转换16进制（支持无穷大数）
    NSString *hex =@"";
    NSString *letter;
    NSDecimalNumber *lastNumber = decimal;
    for (int i = 0; i<999; i++) {
        NSDecimalNumber *tempShang = [lastNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"16"]];
        NSString *tempShangString = [tempShang stringValue];
        if ([tempShangString containsString:@"."]) {
            // 有小数
            tempShangString = [tempShangString substringToIndex:[tempShangString rangeOfString:@"."].location];
            //            DLog(@"%@", tempShangString);
            NSDecimalNumber *number = [[NSDecimalNumber decimalNumberWithString:tempShangString] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"16"]];
            NSDecimalNumber *yushu = [lastNumber decimalNumberBySubtracting:number];
            int yushuInt = [[yushu stringValue] intValue];
            switch (yushuInt) {
                case 10:
                    letter =@"A"; break;
                case 11:
                    letter =@"B"; break;
                case 12:
                    letter =@"C"; break;
                case 13:
                    letter =@"D"; break;
                case 14:
                    letter =@"E"; break;
                case 15:
                    letter =@"F"; break;
                default:
                    letter = [NSString stringWithFormat:@"%d", yushuInt];
            }
            lastNumber = [NSDecimalNumber decimalNumberWithString:tempShangString];
        } else {
            // 没有小数
            if (tempShangString.length <= 2 && [tempShangString intValue] < 16) {
                int num = [tempShangString intValue];
                if (num == 0) {
                    break;
                }
                switch (num) {
                    case 10:
                        letter =@"A"; break;
                    case 11:
                        letter =@"B"; break;
                    case 12:
                        letter =@"C"; break;
                    case 13:
                        letter =@"D"; break;
                    case 14:
                        letter =@"E"; break;
                    case 15:
                        letter =@"F"; break;
                    default:
                        letter = [NSString stringWithFormat:@"%d", num];
                }
                hex = [letter stringByAppendingString:hex];
                break;
            } else {
                letter = @"0";
            }
            lastNumber = tempShang;
        }
        
        hex = [letter stringByAppendingString:hex];
    }
    //    return hex;
    return hex.length > 0 ? hex : @"0";
}

- (BOOL)isBig:(NSString *)bString {
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return NO;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return YES;
    } else {//相等
        return NO;
    }
}

- (BOOL)isSmall:(NSString *)bString {
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return YES;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return NO;
    } else {//相等
        return NO;
    }
}
///大于等于
- (BOOL)isBigEqual:(NSString *)bString {
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return NO;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return YES;
    } else {//相等
        return YES;
    }
}
///小于等于
- (BOOL)isSmallEqual:(NSString *)bString {
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return YES;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return NO;
    } else {//相等
        return YES;
    }
}
- (BOOL)isEqualValue:(NSString *)bString {
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return NO;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return NO;
    } else {//相等
        return YES;
    }
}

- (NSComparisonResult)ob_compare:(NSString *)bString {
    NSString *aString = self;
    if ( IsEmptyString(self) ) {
        aString = @"0";
    }
    if (IsEmptyString(bString)) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    return [a compare:b];
}

- (NSString *)ridTail {
    NSString *string = self;
    if (![string containsString:@"."]) {
        return string;
    }
    if ([string hasSuffix:@"0"]) {
        string = [string substringToIndex:string.length - 1];
        string = [string ridTail];
    } else if ([string hasSuffix:@"."]) {
        string = [string substringToIndex:string.length - 1];
        return string;
    } else {
        return string;
    }
    return string;
}

+ (NSString *)formatterNumber:(NSNumber *)number {
    return [self formatterNumber:number fractionDigits:2];
}

+ (NSString *)notRounding:(NSNumber *)num {
    return [self notRounding:num point:2];
}
/// 小数不四舍五入转化字符串
/// @param num 需要舍弃保留的位数
/// @param point 位数
+ (NSString *)notRounding:(NSNumber *)num point:(NSInteger)point {
    if (num==nil) {
        return @"";
    }
    if (point >= 0) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundDown;
        formatter.minimumIntegerDigits = 1;             // 最少一位整数部分
        formatter.minimumFractionDigits = point;        // 最少xx位小数部分
        formatter.maximumFractionDigits = point;        // 最多xx位小数部分
        return [formatter stringFromNumber:num];
    }else {
        return num.stringValue;
    }
}

+ (NSString *)formatterNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMinimumIntegerDigits:1];
    
    return [numberFormatter stringFromNumber:number];
}


- (NSNumber *)numberFromString
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = [numberFormatter numberFromString:self];
    return number;
}


- (NSString *)DecimalString:(NSInteger)decimal
{
    
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberByAdding:num_2 withBehavior:handel];
    NSString *rid = [num_3.stringValue ridTail];
    
    return rid;
}

- (NSString *)DecimalString1:(NSInteger)decimal
{
        
    NSDecimalNumber *num_1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *num_2 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *num_3 = [num_1 decimalNumberByAdding:num_2 withBehavior:handel];
    NSString *rid = num_3.stringValue;
    if (decimal > 0){
        NSString *murid = [[NSMutableString alloc]initWithString:rid];
        if (![rid containsString:@"."]){
            murid = [murid stringByAppendingString:@"."];
        }
        NSArray *arr = [murid componentsSeparatedByString:@"."];
        if (arr.count > 1){
            NSInteger count = decimal - [arr[1] length];
            if (count > 0){
                for (int i = 0 ; i < count ; i++){
                    murid = [murid stringByAppendingString:@"0"];
                }
            }else{
                NSInteger c = [arr[0] length] + decimal + 1;
                murid = [murid substringToIndex:c];
            }
        }
        rid = murid;
    }
    return rid;
}

- (NSString *)patchZero:(NSInteger)decimal number:(NSString*)numb {
    if (decimal > 0){
        NSString *murid = [[NSMutableString alloc]initWithString:numb];
        if (![numb containsString:@"."]){
            murid = [murid stringByAppendingString:@"."];
        }
        NSArray *arr = [murid componentsSeparatedByString:@"."];
        if (arr.count > 1){
         NSInteger count = decimal - [arr[1] length];
         if (count > 0){
             for (int i = 0 ; i < count ; i++){
                 murid = [murid stringByAppendingString:@"0"];
             }
         }else{
             NSInteger c = [arr[0] length] + decimal + 1;
             murid = [murid substringToIndex:c];
         }
        }
        numb = murid;
    }
    return numb;
}


@end
