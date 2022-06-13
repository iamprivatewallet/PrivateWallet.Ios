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
    if(![pass isNoEmpty]){
        return NO;
    }
    NSString *numPattern = @"^(?![0-9]+$)(?![A-Za-z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *numPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numPattern];
    if (![numPred evaluateWithObject:pass]) {
        return NO;
    }
    return YES;
}

@end
