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

+ (NSString *)timeStrTimeInterval:(NSTimeInterval)timeInterval {
    return [self timeStrTimeInterval:timeInterval format:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)timeStrTimeInterval:(NSTimeInterval)timeInterval format:(NSString *)format {
    NSTimeInterval interval = timeInterval/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
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

- (BOOL)isFloat {
    NSString *number = @"^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:self];
}

@end
