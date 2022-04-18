//
//  PW_DenominatedCurrencyTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DenominatedCurrencyTool.h"

static NSString * _Nonnull PW_DenominatedCurrencyTypeKey = @"DenominatedCurrencyTypeKey";

@implementation PW_DenominatedCurrencyTool

+ (void)setType:(PW_DenominatedCurrencyType)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:PW_DenominatedCurrencyTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (PW_DenominatedCurrencyType)getType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PW_DenominatedCurrencyTypeKey];
}
+ (NSString *)typeStr {
    PW_DenominatedCurrencyType type =[PW_DenominatedCurrencyTool getType];
    if (type==PW_DenominatedCurrencyRMB) {
        return @"RMB";
    }else if (type==PW_DenominatedCurrencyDollar) {
        return @"USD";
    }
    return @"";
}

@end
