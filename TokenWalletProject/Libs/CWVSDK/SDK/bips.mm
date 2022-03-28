//
//  bips.m
//  OpenSSL-for-iOS
//
//  Created by brew on 2018/12/25.
//  Copyright © 2018 Immobilienscout24. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <openssl/md5.h>
#include <openssl/sha.h>
#import <openssl/evp.h>
#include <openssl/bn.h>
#include <openssl/ec.h>
#include <openssl/obj_mac.h>
#include <openssl/ecdsa.h>
#include <openssl/rand.h>
#include "keccak.h"
#include <string>
#include "libbase58.h"
#include "sha256.h"
#include <openssl/ripemd.h>
#import <JavaScriptCore/JavaScriptCore.h>

#include "brewchain.h"


NSString *bip32Hex(const char *seed,int len){
    class SHA256 sha256;
    //sha256(jx,len,d.get(),dlen);
    unsigned char * dest_addr=new unsigned  char[32];
    sha256(seed,len,dest_addr,32);
    BIGNUM *bn=BN_new();
    BN_bin2bn(dest_addr, 32, bn);
    //    unsigned char * dest_addr=new unsidest_addrgned  char[32];
    char * hex_addr= BN_bn2hex(bn);
    
    NSMutableString *outStrg = [NSMutableString string];
    [outStrg appendFormat:@"%s",hex_addr];
    
    BN_free(bn);
    OPENSSL_free(hex_addr);
    free(dest_addr);
    return outStrg;
}
@implementation CWVChainUtils
+(NSString*)evalJS:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"brewchain" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"error:%@",exception);
    };
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}
+(NSDictionary*)evalJSd:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"brewchain" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"error:%@",exception);
    };
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    JSValue *value = [context evaluateScript:jsmethod];
    NSDictionary *dict = [value toDictionary];
    NSMutableDictionary *mDict = [NSMutableDictionary new];
    for (NSString *key in dict.allKeys) {
        id value = dict[key];
        if(![value isKindOfClass:[NSDictionary class]]){
            mDict[key] = value;
        }else if([value isKindOfClass:[NSNumber class]]&&[[NSString stringWithFormat:@"%@",value].lowercaseString isEqualToString:@"nan"]){
            mDict[key] = @0;
        }else{
            mDict[key] = value;
        }
    }
    return [mDict copy];
}

+(NSString*)evalWebJSd:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"web3" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"error:%@",exception);
    };
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}
//SPDT地址，私钥，公钥
+(NSString *)base58ToHexStr:(NSString *)hexPrikey {
    NSString *cwvPrikey = [CWVChainUtils evalJS:[NSString stringWithFormat:
                                               @"cwv.base58ToHexStr('%@')"
                                               ,hexPrikey]];
    return cwvPrikey;
}
+(NSDictionary *)genFromPrikey:(NSString *)hexPrikey {
    NSDictionary *cwvjson = [CWVChainUtils evalJSd:[NSString stringWithFormat:
                                    @"chain.KeyPair.genCVNFromPrikey('%@')"
                                    ,hexPrikey]];
    return cwvjson;
}
+(NSString *)signTransferAddress:(NSString *)address prikey:(NSString *)prikey nonce:(NSString *)nonce exdata:(NSString *)exdata args:(NSString *)args{
    NSDictionary *from = @{@"keypair":@{@"hexAddress":address,@"hexPrikey":prikey,@"nonce":nonce}};
    NSString *str = [NSString stringWithFormat:
                     @"chain.rpc.signTransfer(%@,'%@',%@)"
                     ,[from mj_JSONString],exdata,args];
//    NSString *str = [NSString stringWithFormat:
//                     @"chain.default.signTransfer(%@,'%@','%@',%@)"
//                     ,nonce,prikey,exdata,args];
    NSDictionary *result = [CWVChainUtils evalJSd:str];
    return result[@"tx"];
}
+(NSString *)signTransferToken:(NSString *)nonce withPrikey:(NSString *)prikey withToken:(NSString *)token withArgs:(NSString *)args{
    NSDictionary *from = @{@"keypair":@{@"hexPrikey":prikey,@"nonce":nonce}};
    NSString *str = [NSString stringWithFormat:
                     @"chain.rpc.signTransferToken(%@,'%@',%@)"
                     ,[from mj_JSONString],token,args];
    NSString *cwvjson = [CWVChainUtils evalJS:str];
    return cwvjson;
}
+(NSString *)exportKeystore:(NSString *)kp{
    NSDictionary *keystore = [CWVChainUtils evalJSd:NSStringWithFormat(@"chain.keystore.exportJSON(JSON.parse('%@'),'000000')",kp)];
    NSString *str = [CATCommon convertToJsonData:keystore];
    return str;
}
+(NSString *)exportWebKeystore:(NSString *)account encrypt:(NSString *)encrypt{
//    NSString *keystore = [CWVChainUtils evalWebJSd:NSStringWithFormat(@"new Web3().eth.accounts.privateKeyToAccount('%@').encrypt('%@')",account,encrypt)];
//    NSString *str = [CATCommon convertToJsonData:keystore];
    
    NSString *keystore = [CWVChainUtils evalWebJSd:NSStringWithFormat(@"Web3.version")];
    return keystore;
}
//SPDT交易签名
+(NSString *)cwvecSignTransactionSignhexstring:(NSString *)hexstring{
    NSString *sign = [CWVChainUtils evalJS:[NSString stringWithFormat:
                                            @"chain.KeyPair.ecHexSign('%@')"
                                            ,hexstring]];
    return sign;
}

+(NSString *)cwvTest:(NSString *)str{
    NSString *sign = [CWVChainUtils evalJS:[NSString stringWithFormat:
                                            @"cwv.numToWord('%@')"
                                            ,str]];
    return sign;
}

+(NSString *)numberOperate:(NSString *)str{
    NSString *sign = [CWVChainUtils evalJS:[NSString stringWithFormat:
                                            @"chain.default.hexToBigIntString('%@',2)"
                                            ,str]];
    return sign;
}

@end


@implementation Bip44

NSString * const WordList_toString[] = {
    [EN]=@"EN",
    [JA]=@"JA" ,
    [chinese_simplified]=@"chinese_simplified",
    [chinese_traditional]=@"chinese_traditional",
    [english]=@"english",
    [french]=@"french",
    [italian]=@"italian",
    [japanese]=@"japanese",
    [korean]=@"korean",
    [spanish]=@"spanish"
};
+(NSString*)evalJS:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"bip44" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"error:%@",exception);
    };
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}
//生成助记词
+ (NSString*)generateMnemonic:(WordList)wordls{
    return [Bip44 evalJS:[NSString stringWithFormat:
                          @"bip44.generateMnemonic(null,null,bip44.wordlists.%@)",WordList_toString[wordls]]];
}
//生成主私钥
+ (NSString*)mnemonicToHDPrivateKey:(NSString*)mnemonic  passwd:(NSString*)passwd{
    return [Bip44 evalJS:[NSString stringWithFormat:
                          @"bip44.mnemonicToHDPrivateKey('%@','%@')"
                          ,mnemonic,passwd]];
    
}
//生成地址和私钥
+ (NSString*)getAddress:(NSString*)HDPrivateKey  index:(int)index{
    return [Bip44 evalJS:[NSString stringWithFormat:
                          @"bip44.getAddress('%@',%d)"
                          ,HDPrivateKey,index]];
    
}
+ (NSString*)getPrivateKey:(NSString*)HDPrivateKey  index:(int)index{
    return [Bip44 evalJS:[NSString stringWithFormat:
                          @"bip44.getPrivateKey('%@',%d)"
                          ,HDPrivateKey,index]];
    
}
+ (NSString*)getCWVPrivateKey:(NSString*)HDPrivateKey  index:(int)index{
    return [Bip44 evalJS:[NSString stringWithFormat:
                          @"bip44.getCWVPrivateKey('%@',%d)"
                          ,HDPrivateKey,index]];
}
@end


@implementation Bip39


NSString * const WordListType_toString[] = {
    [EN]=@"EN",
    [JA]=@"JA" ,
    [chinese_simplified]=@"chinese_simplified",
    [chinese_traditional]=@"chinese_traditional",
    [english]=@"english",
    [french]=@"french",
    [italian]=@"italian",
    [japanese]=@"japanese",
    [korean]=@"korean",
    [spanish]=@"spanish"
};
+(NSString*)evalJS:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"bip39" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}



+ (NSString*)generateMnemonic:(WordList)wordls{
    //    NSMutableString *outStrg = [NSMutableString string];
    //    NSLog(@"wordls=%@",WordListType_toString[wordls]);
    return [Bip39 evalJS:[NSString stringWithFormat:
                          @"bip39.generateMnemonic(null,null,bip39.wordlists.%@)",WordListType_toString[wordls]]];
    
}
//根据助记词返回随机种子
+ (NSString*)entropyFrom:(NSString*)mnemonic  wordlist:(WordList)wordls{
    return [Bip39 evalJS:[NSString stringWithFormat:
                          @"bip39.mnemonicToEntropy('%@',bip39.wordlists.%@)"
                          ,mnemonic,WordListType_toString[wordls]]];
    
}

//根据助记词返回随机种子
+ (NSString*)seedFrom:(NSString*)mnemonic  passwd:(NSString*)passwd{
    return [Bip39 evalJS:[NSString stringWithFormat:
                          @"bip39.mnemonicToSeedHex('%@',bip39.wordlists.%@)"
                          ,mnemonic,passwd]];
    
}

//根据种子返回助记词
+ (NSString*)mnemonicFrom:(NSString*)entropy  wordlist:(WordList)wordls{
    return [Bip39 evalJS:[NSString stringWithFormat:
                          @"bip39.entropyToMnemonic('%@',bip39.wordlists.%@)"
                          ,entropy,WordListType_toString[wordls]]];
}

//根据种子返回助记词
+ (NSString*)cwvPrikeyFrom:(NSString*)mnemonic  password:(NSString*)password{
    NSString *seed= [Bip39 evalJS:[NSString stringWithFormat:
                                   @"bip39.mnemonicToSeedHex('%@',bip39.wordlists.%@)"
                                   ,mnemonic,password]];
    
    
    const char * strmsg=[seed cStringUsingEncoding:(NSASCIIStringEncoding)];
    
//    NSLog(@"seed=%@",seed);
    return bip32Hex(strmsg,strlen(strmsg));
}

@end

@implementation Bip32

+(NSString*)evalJS:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"bip32" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
//    NSLog(@"calllMethod:%@",jsmethod);
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}

//根据种子返回私钥
+ (NSString*)hdkeyFrom:(NSString*)seed{
    return [Bip32 evalJS:[NSString stringWithFormat:
                                   @"bip32.privateKeyFromSeedHex('%@')"
                                   ,seed]];
}


+ (NSString*)deriveKeyFrom:(NSString*)seed derivePath:(NSString*)derivePath;
{
    return [Bip32 evalJS:[NSString stringWithFormat:
                          @"var bip=bip32.fromSeedHex('%@');bip.derivePath(\"%@\").privateKey.toString('hex')"
                          ,seed,derivePath]];
}


+(NSString*)testevalJS:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"cwvbundle" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"var window={}"];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"error:%@",exception);
    };
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}

+ (NSString*)testcwv:(NSString*)key{
    return [Bip32 testevalJS:[NSString stringWithFormat:@"'hello:%@::'+JSON.stringify(cwv.KeyPair.genRandomKey())",key]];
}

@end

