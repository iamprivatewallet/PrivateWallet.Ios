//
//  NSString+PW_String.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "NSString+PW_String.h"

@implementation NSString (PW_String)

- (BOOL)judgePassWordLegal {
    NSString *pass = self;
    // 验证密码长度
    if([pass isEmptyStr]||pass.length < 8) {
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

@end
