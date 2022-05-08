//
//  PW_DappPayModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_GasModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappPayModel : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *paymentAddress;
@property (nonatomic, copy) NSString *acceptAddress;
@property (nonatomic, strong) PW_GasToolModel *gasToolModel;
@property (nonatomic, strong) PW_GasModel *gasModel;

@end

NS_ASSUME_NONNULL_END
