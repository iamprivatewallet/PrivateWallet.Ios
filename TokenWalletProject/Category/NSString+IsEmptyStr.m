//
//  NSString+IsEmptyStr.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/7.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "NSString+IsEmptyStr.h"

@implementation NSString (IsEmptyStr)
- (BOOL)isNoEmpty{
    if(self != nil && ![self isKindOfClass:[NSNull class]] && [self trim].length>0){
        return YES;
    }
    return NO;
}
@end
