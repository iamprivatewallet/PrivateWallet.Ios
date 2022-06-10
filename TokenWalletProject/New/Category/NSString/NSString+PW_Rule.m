//
//  NSString+PW_Rule.m
//  TokenWalletProject
//
//  Created by mnz on 2022/5/10.
//  Copyright © 2022 . All rights reserved.
//

#import "NSString+PW_Rule.h"

@implementation NSString (PW_Rule)

- (BOOL)judgeWalletName {
    if ([self isNoEmpty]&&self.length<=10) {
        return YES;
    }
    return NO;
}
- (BOOL)judgePassWordLegal {
    NSString *pass = self;
    // 验证密码长度
    if(![pass isNoEmpty]||pass.length < 8) {
        NSLog(@"请输入8位的密码");
        return NO;
    }
    NSString *numPattern = @"^[0-9]+$";
    NSPredicate *numPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPattern];
    if (![numPred evaluateWithObject:pass]) {
        return NO;
    }
    NSString *charPattern = @"^[A-Za-z]+$";
    NSPredicate *charPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", charPattern];
    if (![charPred evaluateWithObject:pass]) {
        return NO;
    }
    return YES;
}

@end
