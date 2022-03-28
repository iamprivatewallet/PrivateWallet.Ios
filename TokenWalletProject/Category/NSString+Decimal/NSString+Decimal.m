//
//  NSString+Decimal.m
//  TokenWalletProject
//
//  Created by jackygood on 2018/12/25.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "NSString+Decimal.h"

@implementation NSString (Decimal)

- (NSString*)stringRaisingToPower18{
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:@"10"];
    NSDecimalNumber * result = [bigN decimalNumberByMultiplyingBy:[davN decimalNumberByRaisingToPower:18]];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownToPower18{
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:@"10"];
    NSDecimalNumber * result = [bigN decimalNumberByDividingBy:[davN decimalNumberByRaisingToPower:18]];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownPower:(short)power {
    return [self stringDownPower:power decimal:8];
}
- (NSString*)stringDownPower:(short)power decimal:(short)decimal {
    NSDecimalNumber *davN = [[NSDecimalNumber alloc] initWithString:@"10"];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *result = [davN decimalNumberByRaisingToPower:power withBehavior:handel];
    NSString *finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownDecimal:(short)decimal {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:@"1"];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberByMultiplyingBy:davN withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownAdding:(NSString *)other {
    return [self stringDownAdding:other decimal:8];
}
- (NSString*)stringDownAdding:(NSString *)other decimal:(short)decimal {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:other];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberByAdding:davN withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownSubtracting:(NSString *)other {
    return [self stringDownSubtracting:other decimal:8];
}
- (NSString*)stringDownSubtracting:(NSString *)other decimal:(short)decimal {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:other];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberBySubtracting:davN withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownMultiplyingBy:(NSString *)other {
    return [self stringDownMultiplyingBy:other decimal:8];
}
- (NSString*)stringDownMultiplyingBy:(NSString *)other decimal:(short)decimal {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:other];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberByMultiplyingBy:davN withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownDividingBy:(NSString *)other {
    return [self stringDownDividingBy:other decimal:8];
}
- (NSString*)stringDownDividingBy:(NSString *)other decimal:(short)decimal {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:other];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberByDividingBy:davN withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownMultiplyingBy10Power:(short)power {
    return [self stringDownMultiplyingBy10Power:power scale:8];
}
- (NSString*)stringDownMultiplyingBy10Power:(short)power scale:(short)scale {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:@"10"];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberByMultiplyingBy:[davN decimalNumberByRaisingToPower:power] withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownDividingBy10Power:(short)power {
    return [self stringDownDividingBy10Power:power scale:8];
}
- (NSString*)stringDownDividingBy10Power:(short)power scale:(short)scale {
    NSDecimalNumber * bigN = [[NSDecimalNumber alloc] initWithString:self];
    NSDecimalNumber * davN = [[NSDecimalNumber alloc] initWithString:@"10"];
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [bigN decimalNumberByDividingBy:[davN decimalNumberByRaisingToPower:power] withBehavior:handel];
    NSString * finalStr = [result stringValue];
    return finalStr;
}
- (NSString*)stringDownToPowerL:(NSUInteger)number{
    NSDecimalNumber*price = [NSDecimalNumber decimalNumberWithMantissa:1
                                                              exponent:number
                                                            isNegative:NO];
    NSDecimalNumber *gas_used = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num = [gas_used decimalNumberByDividingBy:price];
    return [NSString stringWithFormat:@"%@",num];
}
#pragma mark - 保留两位小数
-(NSString *)NSDecimalNumberHandler{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [NSDecimalNumber decimalNumberWithString:self];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
- (NSData *)toHexData{
    if (!self || [self length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([self length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}
-(NSString *)HexStringWithData:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1){
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    hexStr = [hexStr uppercaseString];
    return hexStr;
}
- (int)stringTo10{
    const char *hexChar = [self cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return hexNumber;
}
-  (NSString *)getHex{
    //10进制转换16进制（支持无穷大数）
    NSString *hex =@"";
    NSString *letter;
    NSDecimalNumber *lastNumber = [NSDecimalNumber decimalNumberWithString:self];
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
//    return hex.length > 0 ? hex : @"0";
    return hex.length > 0 ? [NSString stringWithFormat:@"0x%@",hex] : @"0x0";
}
- (BOOL)isTokenContract{
    NSString *number = @"^0x[0-9a-fA-F]{40}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}
- (NSString*)formatToEth{
    if ([self hasPrefix:@"0x"]) {
        return self;
    }
    NSString * str = [NSString stringWithFormat:@"0x%@",self];
    return str;
}
- (NSString*)formatToCVN{
    NSString * str;
    if ([self hasPrefix:@"0x"]) {
        str =  [self stringByReplacingOccurrencesOfString:@"0x" withString:@"CVN"];
    }else{
        if ([self hasPrefix:@"CVN"]) {
            return self;
        }else if ([self hasPrefix:@"cvn"]) {
            str =  [self stringByReplacingOccurrencesOfString:@"cvn" withString:@"CVN"];
        }else{
            str = [NSString stringWithFormat:@"CVN%@",self];
        }
    }
    return str;
}
- (NSString*)contractPrefix{
    if([[self lowercaseString] hasPrefix:@"0x"]){
        return [self substringToIndex:2];
    }else if([[self uppercaseString] hasPrefix:@"CVN"]){
        return [self substringToIndex:3];
    }
    return @"";
}
- (NSString*)formatDelCVN{
    NSString *str =  [self stringByReplacingOccurrencesOfString:@"CVN" withString:@""];
    return str;
}
- (NSString*)formatDelEth{
    if ([self hasPrefix:@"0x"]) {
        NSString *str = [self substringFromIndex:2];
        return str;
    }
    return self;
}
- (NSString*)toFloat0{
    if (self == nil || self.length<1) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%@",@(self.floatValue)];
}
- (NSString*)trim{
    if (self && ![self isEqualToString:@""]) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return self;
}
- (NSString *)hexString{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

@end
