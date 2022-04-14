//
//  PW_AddCurrencyModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddCurrencyModel : PW_BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isChecked;

@end

NS_ASSUME_NONNULL_END
