//
//  ETHBalanceInfo.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHBalanceInfo : JSONModel

@property (strong, nonatomic) NSString<Optional> *coin_symbol;
@property (strong, nonatomic) NSString<Optional> *balance;
@property (strong, nonatomic) NSString<Optional> *contract_addr;
@property (strong, nonatomic) NSString<Optional> *msg;
@end

NS_ASSUME_NONNULL_END
