//
//  ETHTokenCoin.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHTokenCoin : JSONModel

@property (strong, nonatomic) NSString<Optional> *contract_addr;
@property (strong, nonatomic) NSString<Optional> *channel_name;
@property (strong, nonatomic) NSString<Optional> *coin_name;
@property (strong, nonatomic) NSString<Optional> *coin_symbol;
@property (strong, nonatomic) NSString<Optional> *coin_decimals;
@property (strong, nonatomic) NSString<Optional> *coin_total_supply;
@property (strong, nonatomic) NSString<Optional> *coin_icon;
@property (strong, nonatomic) NSString<Optional> *single_max_amt;
@property (strong, nonatomic) NSString<Optional> *single_min_amt;
@property (strong, nonatomic) NSString<Optional> *dsc;
@property (assign, nonatomic) NSNumber<Optional> *isAdded;

@end

NS_ASSUME_NONNULL_END
