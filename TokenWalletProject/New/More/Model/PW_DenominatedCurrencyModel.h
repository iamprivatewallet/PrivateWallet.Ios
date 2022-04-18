//
//  PW_DenominatedCurrencyModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DenominatedCurrencyModel : PW_BaseModel

+ (instancetype)DenominatedCurrencyIconStr:(NSString *)iconStr title:(NSString *)title type:(PW_DenominatedCurrencyType)type;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) PW_DenominatedCurrencyType type;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
