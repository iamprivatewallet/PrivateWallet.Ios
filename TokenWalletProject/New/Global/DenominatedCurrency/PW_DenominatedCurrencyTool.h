//
//  PW_DenominatedCurrencyTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PW_DenominatedCurrencyType) {
    PW_DenominatedCurrencyRMB,
    PW_DenominatedCurrencyDollar,
};

NS_ASSUME_NONNULL_BEGIN

@interface PW_DenominatedCurrencyTool : NSObject

+ (void)setType:(PW_DenominatedCurrencyType)type;
+ (PW_DenominatedCurrencyType)getType;
+ (NSString *)typeStr;

@end

NS_ASSUME_NONNULL_END
