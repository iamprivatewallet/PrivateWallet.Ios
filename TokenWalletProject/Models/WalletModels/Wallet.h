//
//  Wallet.h
//  JQFMDB
//
//  Created by jackygood on 2018/12/24.
//  Copyright © 2018 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Wallet : NSObject
@property (nonatomic, copy)NSString *owner;
@property (nonatomic, copy)NSString *type;//ETH | HECO |BTC
@property (nonatomic, copy)NSString *pubKey;
@property (nonatomic, copy)NSString *priKey;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *isImport;//1:后导入的
@property (nonatomic, copy)NSString *mnemonic;
@property (nonatomic, copy)NSString *coinCount;
@property (nonatomic, assign)double totalValue;//总价值
@property (nonatomic, assign)double totalBalance;

@property (nonatomic, copy) NSString *walletName;
@property (nonatomic, copy) NSString *walletPassword;
@property (nonatomic, copy) NSString *walletPasswordTips;

@property (nonatomic, copy)NSString *isOpenID;//1:开启ID验证

@property (nonatomic, assign) NSInteger sortIndex;

@end

NS_ASSUME_NONNULL_END
