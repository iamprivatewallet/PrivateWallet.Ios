//
//  PW_GasModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
@class PW_GasModel;

NS_ASSUME_NONNULL_BEGIN

@interface PW_GasToolModel : PW_BaseModel

@property (nonatomic, copy) NSString *gas_price;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, copy) NSString *price;

@property (nonatomic, strong) PW_GasModel *slowModel;
@property (nonatomic, strong) PW_GasModel *recommendModel;
@property (nonatomic, strong) PW_GasModel *fastModel;
@property (nonatomic, strong) PW_GasModel *soonModel;

@end

@interface PW_GasModel : PW_BaseModel <NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSString *gas_price;
@property (nonatomic, readonly, copy) NSString *gas_gwei;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, readonly, copy) NSString *gas_amount;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, readonly, copy) NSString *gas_ut_amout;

@end

NS_ASSUME_NONNULL_END
