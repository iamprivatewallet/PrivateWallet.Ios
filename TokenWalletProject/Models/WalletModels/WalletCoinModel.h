//
//  WalletCoinModel.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/31.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletCoinModel : NSObject

@property (nonatomic, copy) NSString *tokenName;
@property (nonatomic, copy) NSString *tokenAddress;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *usableAmount;//可用余额
@property (nonatomic, copy) NSString *usdtPrice;//usdt价格
@property (nonatomic, copy) NSString *rmbAmount;//人民币金额
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, copy) NSString *gas_price;//矿工费
@property (nonatomic, copy) NSString *nonce;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, strong) Wallet *currentWallet;


@end

NS_ASSUME_NONNULL_END
