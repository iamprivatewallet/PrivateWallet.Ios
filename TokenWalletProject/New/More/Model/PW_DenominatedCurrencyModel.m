//
//  PW_DenominatedCurrencyModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DenominatedCurrencyModel.h"

@implementation PW_DenominatedCurrencyModel

+ (instancetype)DenominatedCurrencyIconStr:(NSString *)iconStr title:(NSString *)title type:(PW_DenominatedCurrencyType)type {
    PW_DenominatedCurrencyModel *model = [PW_DenominatedCurrencyModel new];
    model.iconStr = iconStr;
    model.title = title;
    model.type = type;
    return model;
}

@end
