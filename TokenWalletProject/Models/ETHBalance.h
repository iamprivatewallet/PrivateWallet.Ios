//
//  ETHBalance.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHBalance : JSONModel
@property(nonatomic ,strong)NSString<Optional> * status;
@property(nonatomic ,strong)NSString<Optional> *nonce;
@property(nonatomic ,strong)NSString<Optional> *retCode;
@property(nonatomic ,strong)NSString<Optional> *address;
@property(nonatomic ,strong)NSString<Optional> *address_eth;

@property (strong, nonatomic) NSString<Optional> *balance;
@property (strong, nonatomic) NSString<Optional> *err_code;
@property (strong, nonatomic) NSString<Optional> *msg;
@property(nonatomic ,strong)NSString<Optional> *balanceNum;
@property(nonatomic ,strong)NSString<Optional> *showBalance;


@end

NS_ASSUME_NONNULL_END
