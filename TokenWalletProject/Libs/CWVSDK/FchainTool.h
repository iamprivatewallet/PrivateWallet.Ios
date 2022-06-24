//
//  FunnyProject
//
//  Created by jackygood on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kFChainWalletType) {
    Ethereum,
    Bitcoin,
    CWVCoin
};

@interface FchainTool : NSObject

//async

//生成助记词
+ (void)generateMnemonicBlock:(void(^)(NSString *result))block;

//根据助记词恢复身份
+ (void)restoreWalletWithMnemonic:(NSString*)str password:(NSString*)password block:(void(^)(NSString *result))block;
+ (void)restoreWalletWithPrivateKey:(NSString*)privateKey password:(NSString*)password block:(void(^)(NSString *result))block;
+ (void)restoreWalletWithMnemonic:(NSString*)str walletName:(NSString *)walletName password:(NSString*)password block:(void(^)(NSString *result))block;
+ (void)restoreWalletWithPrivateKey:(NSString*)privateKey walletName:(NSString *)walletName password:(NSString*)password block:(void(^)(NSString *result))block;

//根据 助记词、用户名 生成  ETH && HECO && BSC 钱包
+ (void)genWalletsWithMnemonic:(NSString*)mnemonic createList:(NSArray *)list block:(void(^)(BOOL sucess))block;
+ (void)genWalletsWithPrivateKey:(NSString*)privateKey createList:(NSArray *)list block:(void(^)(BOOL sucess))block;
//根据 助记词 创建单个钱包
+ (void)genWalletWithMnemonic:(NSString*)mnemonic withWallet:(Wallet *)wallet block:(void(^)(BOOL sucess))block;

//根据私钥导入钱包
+ (void)importPrikeyFromModel:(Wallet *)model errorType:(void(^)(NSString *errorType, BOOL sucess))block;

//根据助记词导入钱包
+ (void)importMnemonicFromModel:(Wallet *)model errorType:(void(^)(NSString *errorType, BOOL sucess))block;

//生成签名
+ (void)genSign:(NSString*)privateKey content:(NSString*)content type:(kFChainWalletType)type block:(void(^)(NSString *result))block;

//数据签名
+ (void)ecSignAddress:(NSString*)address content:(NSString*)msg type:(kFChainWalletType)type block:(void(^)(NSString *result))block;



//ETH交易签名
+ (void)genETHTransactionSign:(NSDictionary*)dic isToken:(BOOL)isToken block:(void(^)(NSString *result))block;

@end

NS_ASSUME_NONNULL_END
