//
//  ETHServerMananger.h
//  TokenWalletProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETHServerMananger : NSObject

+(instancetype)sharedInstance;
//查询更新
-(void)VersionUpdateResultBlock:(void(^)(id data, NSError * __nullable error))block;
///查询地址Nonce
-(void)fetchAddressNonce:(NSString *)address resultBlock:(void(^)(ETHNoce * __nullable data, NSError * __nullable error))block;

//查询地址余额
-(void)fetchBalance:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHBalance * __nullable data, NSError * __nullable error))block;

//查询地址所有不为0余额
-(void)fetchBalanceNoZero:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHBalanceList * __nullable data, NSError * __nullable error))block;

//查询节点当前GAS
-(void)fetchNodeGas:(void(^)(ETHNodeGas * __nullable data, NSError * __nullable error))block;

//查询转账
-(void)fetchTransfer:(NSString *)txid resultBlock:(void(^)(ETHTransfer * __nullable data, NSError * __nullable error))block;

//查询历史转账列表,parameter:contract_addr,from_addr,to_addr,tx_type,tx_status,start_timeend_time,
-(void)fetchTransferList:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferList * __nullable data, NSError * __nullable error))block;

//查询代币信息
-(void)fetchTockenCoinInfo:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHTokenCoinList * __nullable data, NSError * __nullable error))block;

//查询节点信息
-(void)fetchNodeInfo:(NSString *)nodeNet resultBlock:(void(^)(ETHNodeList * __nullable data, NSError * __nullable error))block;

//冷钱包主币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type
-(void)fetchColdMainCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block;

//冷钱包代币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type,symbol,contract_addr
-(void)fetchColdTokenCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block;

//热钱包主币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type
-(void)fetchHotMainCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block;

//热钱包代币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type,symbol,contract_addr
-(void)fetchHotTokenCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block;

//  热钱包创建账户
-(void)createHotAccount:(NSString *)password resultBlock:(void(^)(ETHCreateAccountResult * __nullable data, NSError * __nullable error))block;



@end

NS_ASSUME_NONNULL_END
