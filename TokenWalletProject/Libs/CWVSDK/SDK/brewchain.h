//
//  brewchain.h
//  OpenSSL-for-iOS
//
//  Created by brew on 2018/12/21.
//  Copyright © 2018 Immobilienscout24. All rights reserved.
//

#ifndef brewchain_h
#define brewchain_h
#import <Foundation/Foundation.h>
#pragma pack(1)


typedef struct KeyPairs{
    char  hexPrikey[65];
    char  hexPubkey[129];
    char  hexAddress[41];
    char  hexBcuid[129];
}KeyPair;

@interface KeyPairHelper : NSObject
//获取私钥
+ (NSString*)hexPrikey:(KeyPair)kp;
//获取公钥
+ (NSString*)hexPubkey:(KeyPair)kp;
//获取地址
+ (NSString*)hexAddress:(KeyPair)kp;
@end
@interface BrewChainUtils : NSObject
//根据私钥生成私钥对
+ (KeyPair)genFromPrikey:(NSString *)hexPrikey;
//生成随机密钥对
+ (KeyPair)genRandomKey;
//数据签名
+ (NSString*)ecSign:(KeyPair)kp content:(NSString*)msg;
//对hex编码的字符串数据进行签名
+ (NSString*)ecHexSign:(KeyPair)kp content:(NSString*)hexmsg;
@end

@interface EthereumUtils : NSObject
//根据私钥生成私钥对
+ (KeyPair)genFromPrikey:(NSString *)hexPrikey;
//生成随机密钥对
+ (KeyPair)genRandomKey;
//数据签名
+ (NSString*)ecSign:(KeyPair)kp content:(NSString*)msg;

+ (NSString*)ecSignTransaction:(KeyPair)kp nonce:(NSString*)hexnonce gasPrice:(NSString*)hexgasPrice
gasLimit:(NSString*)hexgasLimit  to:(NSString*)toAddr  hexvalue:(NSString*)hexvalue data:(NSString*)data chainId:(int)chainid;

+(NSString*)evalJS:(NSString*) jsmethod;

@end


@interface BitcoinUtils : NSObject
//根据私钥生成私钥对
+ (KeyPair)genFromPrikey:(NSString *)hexPrikey;
//生成随机密钥对
+ (KeyPair)genRandomKey;
//数据签名
+ (NSString*)ecSign:(KeyPair)kp content:(NSString*)msg;
@end



typedef enum WordLists {
    EN,
    JA,
    chinese_simplified,
    chinese_traditional,
    english,
    french,
    italian,
    japanese,
    korean,
    spanish
}WordList;

@interface CWVChainUtils : NSObject
//+(NSString *)base58ToHexStr:(NSString *)hexPrikey;
+(NSDictionary *)genFromPrikey:(NSString *)hexPrikey;
+(NSString *)signTransferAddress:(NSString *)address prikey:(NSString *)prikey nonce:(NSString *)nonce exdata:(NSString *)exdata args:(NSString *)args;
+(NSString *)signTransferToken:(NSString *)nonce withPrikey:(NSString *)prikey withToken:(NSString *)token withArgs:(NSString *)args;
+(NSString *)exportKeystore:(NSString *)kp;
+(NSString *)exportWebKeystore:(NSString *)account encrypt:(NSString *)encrypt;

+(NSString *)cwvecSignTransactionSignhexstring:(NSString *)hexstring;
+(NSString *)cwvTest:(NSString *)str;
+(NSString *)numberOperate:(NSString *)str;
@end


@interface Bip44 : NSObject
//生成助记词
+ (NSString*)generateMnemonic:(WordList)wordls;
//生成主私钥
+ (NSString*)mnemonicToHDPrivateKey:(NSString*)mnemonic  passwd:(NSString*)passwd;
//生成地址和私钥
+ (NSString*)getAddress:(NSString*)HDPrivateKey  index:(int)index;
+ (NSString*)getPrivateKey:(NSString*)HDPrivateKey  index:(int)index;
+ (NSString*)getCWVPrivateKey:(NSString*)HDPrivateKey  index:(int)index;

@end

@interface Bip39 : NSObject
+(NSString*)evalJS:(NSString*) jsmethod;

//随机生成助记词
+ (NSString*)generateMnemonic:(WordList)wordls;
//根据助记词返回种子
+ (NSString*)entropyFrom:(NSString*)mnemonic  wordlist:(WordList)wordls;
//根据助记词返回HDSeed
+ (NSString*)seedFrom:(NSString*)mnemonic  passwd:(NSString*)passwd;
//根种子返回助记词
+ (NSString*)mnemonicFrom:(NSString*)entropy  wordlist:(WordList)wordls;

//根据种子返回私钥串//brewchain的
+ (NSString*)cwvPrikeyFrom:(NSString*)mnemonic  password:(NSString*)password;



@end

@interface Bip32 : NSObject
+(NSString*)evalJS:(NSString*) jsmethod;

//根据种子返回私钥
+ (NSString*)hdkeyFrom:(NSString*)seed;


//根据种子和derivePath返回私钥
+ (NSString*)deriveKeyFrom:(NSString*)seed derivePath:(NSString*)derivePath;


+ (NSString*)testcwv:(NSString*)key;

@end

#endif /* brewchain_h */
