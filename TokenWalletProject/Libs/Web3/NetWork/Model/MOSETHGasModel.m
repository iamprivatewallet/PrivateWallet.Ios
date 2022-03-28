//
//  MOSETHGasModel.m
//  MOS_Client_IOS
//
//  Created by mnz on 2020/12/7.
//  Copyright © 2020 WangQJ. All rights reserved.
//

#import "MOSETHGasModel.h"
#import "NSString+Caculate.h"

@implementation MOSETHGasModel

+ (NSString *)getGweiWithValue:(NSUInteger)value {
    return [@(value).stringValue stringByDividingBy:@"10" Decimals:0];
}
+ (NSString *)calcRMBGwei:(CGFloat)gwei gas:(CGFloat)gas ethRMBPrice:(NSString *)ethPrice {
    NSString *percentageStr = [self toEthPercentageWithValue:[@(gwei).stringValue stringByMultiplyingBy:@(gas).stringValue Decimals:2]];
    return [ethPrice stringByMultiplyingBy:percentageStr Decimals:2];
}
+ (NSString *)gasPriceHexWithGwei:(NSString *)gwei {
    NSString *gasPrice = [gwei stringByMultiplyingByGwei];
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:gasPrice];
    return [NSString stringWithFormat:@"0x%@",[NSString getHexByDecimal:decimalNumber]];
}
+ (NSString *)toEthPercentageWithValue:(NSString *)aString {
    NSDecimalNumber *value = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *one = [[NSDecimalNumber alloc] initWithString:@"1"];
    NSDecimalNumber *tenPower = [one decimalNumberByMultiplyingByPowerOf10:9];//10的9次方
    NSDecimalNumber *result = [value decimalNumberByDividingBy:tenPower];
    NSString *resultString = [NSString stringWithFormat:@"%@", result];
    return resultString;
}

@end
