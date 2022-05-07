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

@end
