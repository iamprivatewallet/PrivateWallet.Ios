//
//  PW_WalletManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletManager : NSObject

+ (instancetype)shared;
- (void)saveWallet:(Wallet *)wallet;
//保存多个钱包
- (void)saveWallets:(NSArray *)wallets;
//查询名下所有钱包
- (NSArray*)getWallets;
//查询对应类型的钱包
- (NSArray*)selectWalletWithType:(NSString*)type;
- (NSInteger)getMaxIndex;
//查询初始钱包
- (NSArray*)getOrignWallets;
//查询后导入钱包
- (NSArray*)getImportWallets;
- (Wallet *)getOriginWalletWithType:(NSString*)type;
- (BOOL)updateSortIndex:(NSInteger)sortIndex address:(NSString *)address type:(NSString *)type;
//删除钱包
- (void)deleteWallet:(Wallet*)wallet;
//修改钱包信息
- (void)updateWallet:(Wallet*)wallet;
//更新用户名
- (void)updateWalletOwner:(NSString*)owner;
- (BOOL)updateWalletName:(NSString *)name address:(NSString *)address type:(NSString *)type;
- (BOOL)updateWalletPwd:(NSString *)pwd address:(NSString *)address type:(NSString *)type;
//查询对应私钥的钱包
- (NSArray*)selctWalletWithPrikey:(NSString*)pKey type:(NSString*)type;
//查询对应地址的钱包
- (NSArray*)selctWalletWithAddr:(NSString*)addr type:(NSString*)type;


@end

NS_ASSUME_NONNULL_END
