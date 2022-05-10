//
//  NSString+PW_String.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "NSString+PW_String.h"
#import "NSDate+Helper.h"

@implementation NSString (PW_String)

+ (NSString *)emptyStr:(NSString *)str {
    return [str isNoEmpty] ? str : @"--";
}

+ (NSString *)timeStrTimeInterval:(NSTimeInterval)timeInterval {
    return [self timeStrTimeInterval:timeInterval format:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)timeStrTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    NSTimeInterval interval = timeInterval/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)deviceUUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (NSString *)currency {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:self];
    return [NSNumberFormatter localizedStringFromNumber:myNumber numberStyle:NSNumberFormatterDecimalStyle];
}

- (void)pasteboard {
    [self pasteboardToast:NO];
}
- (void)pasteboardToast:(BOOL)toast {
    if (![self isNoEmpty]) {
        return;
    }
    [UIPasteboard generalPasteboard].string = self;
    if (toast) {
        [PW_ToastTool showSucees:LocalizedStr(@"text_copySuccess")];
    }
}

- (BOOL)judgePassWordLegal {
    NSString *pass = self;
    // 验证密码长度
    if(![pass isNoEmpty]||pass.length < 8) {
        NSLog(@"请输入8位的密码");
        return NO;
    }
//    // 验证密码是否包含数字
//    NSString *numPattern = @".*\\d+.*";
//    NSPredicate *numPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPattern];
//    if (![numPred evaluateWithObject:pass]) {
//        NSLog(@"密码必须包含数字");
//        return NO;
//    }
//    NSString *charPattern = @".*[a-zA-Z]+.*";
//    NSPredicate *charPattern = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lowerPattern];
//    if (![charPattern evaluateWithObject:pass]) {
//        NSLog(@"密码必须包含小写字母");
//        return NO;
//    }
//    // 验证密码是否包含小写字母
//    NSString *lowerPattern = @".*[a-z]+.*";
//    NSPredicate *lowerPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lowerPattern];
//    if (![lowerPred evaluateWithObject:pass]) {
//        NSLog(@"密码必须包含小写字母");
//        return NO;
//    }
//    // 验证密码是否包含大写字母
//    NSString *upperPattern = @".*[A-Z]+.*";
//    NSPredicate *upperPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", upperPattern];
//    if (![upperPred evaluateWithObject:pass]) {
//        NSLog(@"密码必须包含大写字母");
//        return NO;
//    }
    return YES;
}

- (NSString *)showShortAddress {
    return [self showAddressHead:14 tail:4];
}
- (NSString *)showAddressHead:(NSInteger)head tail:(NSInteger)tail {
    if([self isNoEmpty]&&self.length>=18){
        NSString *headStr = [self substringToIndex:14];
        NSString *tailStr = [self substringFromIndex:self.length-4];
        return [NSString stringWithFormat:@"%@...%@",headStr,tailStr];
    }
    return self;
}

- (BOOL)isInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
- (BOOL)isFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
- (BOOL)isAllChinese {
    return [NSString isChinese:self];
}
- (BOOL)isAllAlpha {
    return [NSString isAlpha:self];
}
- (BOOL)isAlphaURL {
    return [NSString isAlphaURL:self];
}

- (BOOL)isURL {
    NSString *str = @"^((https|http)?://)[^\\s]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}
- (BOOL)isHttpsURL {
    NSString *str = @"^(https://)[^\\s]+.[^\\s]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [predicate evaluateWithObject:self];
}
- (NSString *)pw_firstChar {
    if (self.length == 0) return self;
    return [NSString stringWithFormat:@"%c", [self characterAtIndex:1]];
}
- (NSString *)pw_firstStr {
    if (self.length == 0) return self;
    return [NSString stringWithFormat:@"%@", [self substringToIndex:1]];
}
- (NSString *)pw_firstCharLower {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:1]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}
- (NSString *)pw_firstCharUpper {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:1]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}
- (NSString *)pw_firstStrLower {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%@", [self substringToIndex:1]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}
- (NSString *)pw_firstStrUpper {
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%@", [self substringToIndex:1]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

+ (BOOL)isChinese:(NSString *)str {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([str isNoEmpty]&&[pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isAlpha:(NSString *)str {
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([str isNoEmpty]&&[pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isAlphaURL:(NSString *)str {
    NSString *regex =@"[a-zA-Z:./]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([str isNoEmpty]&&[pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

- (BOOL)hasPrefixOx {
    if ([self hasPrefix:@"0x"]) {
        return YES;
    }
    return NO;
}
- (NSString *)strTo10{
    const char *hexChar = [self cStringUsingEncoding:NSUTF8StringEncoding];
    long long hexNumber;
    sscanf(hexChar, "%llx", &hexNumber);
    return [NSString stringWithFormat:@"%lld",hexNumber];
}
- (NSString *)strTo16{
    //10进制转换16进制（支持无穷大数）
    NSString *hex = @"";
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
    return hex.length > 0 ? hex.lowercaseString : @"0";
//    return hex.length > 0 ? [NSString stringWithFormat:@"0x%@",hex] : @"0x0";
}
- (NSString *)addOxPrefix {
    return [self isNoEmpty] ? [NSString stringWithFormat:@"0x%@",self] : @"0x0";
}
- (NSString *)getStrTo16 {
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSMutableString* resultStr = [[NSMutableString alloc]init];
    for(int i=0;i<[myD length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        [resultStr appendString:newHexStr];
    }
    return resultStr;
}
// 十六进制转换为普通字符串的。
- (NSString *)get16ToStr {
    NSString *hexString = self;
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if(hexString.length % 2 != 0) {
        return nil;
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];
    return unicodeString;
}

@end
