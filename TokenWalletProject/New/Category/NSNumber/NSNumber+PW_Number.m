//
//  NSNumber+PW_Number.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "NSNumber+PW_Number.h"

@implementation NSNumber (PW_Number)

- (NSString *)currencyStr {
    // 12,342,323.556
    return [NSNumberFormatter localizedStringFromNumber:self numberStyle:NSNumberFormatterDecimalStyle];
}

@end
