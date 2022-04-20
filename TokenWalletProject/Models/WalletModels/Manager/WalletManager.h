//
//  WalletManager.h
//  TokenWalletProject
//
//  Created by jackygood on 2018/12/24.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletManager : NSObject

@property (nonatomic, strong) Wallet * currentWallet;

+ (instancetype)shareWalletManager;

- (void)saveWallet:(Wallet*)wallet;
- (void)saveWallets:(NSArray*)wallets;

//查询所有钱包
- (NSArray*)getWallets;
//查询初始钱包
- (NSArray*)getOrignWallets;
//查询后导入钱包
- (NSArray*)getImportWallets;
- (Wallet *)getOriginWalletWithType:(NSString*)type;
//查询对应类型的钱包
- (NSArray*)selectWalletWithType:(NSString*)type;
//删除钱包
- (void)deleteWallet:(Wallet*)wallet;
- (BOOL)deleteAllWallets;
//修改钱包信息
- (void)updataWallet:(Wallet*)wallet;

//更新用户名
- (void)updataWalletOwnerTo:(NSString*)toO;
//更新价值
//- (void)updataWalletTotalValueTo:(NSString*)toO WalletType:(NSString *)type;
//- (void)updataWalletHiddenTo:(NSString*)hidden WalletType:(NSString *)type;
- (void)updataWalletOpenId:(NSString*)openId WalletType:(NSString *)type;
+ (NSString*)getPriWithAddress:(NSString*)address;
- (Wallet *)getWalletWithAddress:(NSString*)address type:(NSString*)type;
- (Wallet *)getWalletWithPriKey:(NSString*)priKey;

//查询私钥对应信息
- (NSString*)selectUserPrikey:(NSString*)prikey;

- (NSArray*)selctWalletWithAddr:(NSString*)addr type:(NSString*)type;

- (NSArray*)selctWalletWithPrikey:(NSString*)pKey type:(NSString*)type;

//- (void)deleteToken:(Token*)token;
//- (void)saveToken:(Token*)token;
- (NSArray*)getTokenWithAddress:(NSString*)address;

@end

NS_ASSUME_NONNULL_END
