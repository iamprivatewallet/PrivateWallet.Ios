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
    if (![self isNoEmpty]&&self.length<=10) {
        return YES;
    }
    return NO;
}

@end
