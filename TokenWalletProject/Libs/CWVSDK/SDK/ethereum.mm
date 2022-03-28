//
//  brewchain.m
//  OpenSSL-for-iOS
//
//  Created by brew on 2018/12/21.
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
#include "sha256.h"
#import <JavaScriptCore/JavaScriptCore.h>

#include "brewchain.h"
 


KeyPair eth_genFromPrivKey(const char *hexpriv) {
    KeyPair kp;
    
    memset(kp.hexPrikey,65,0);
    memset(kp.hexPubkey,129,0);
    memset(kp.hexAddress,41,0);
    memset(kp.hexBcuid,129,0);
    
    EC_KEY *key;
    BIGNUM *priv;
    BN_CTX *ctx;
    const EC_GROUP *group;
    EC_POINT *pub;
    key = EC_KEY_new_by_curve_name(NID_secp256k1);
    priv = BN_new();
    BN_hex2bn(&priv, hexpriv);//"f3c122d42251d761882f5a49d9ff1d5491e50a5add8f5886bb25a921f3379e24");
    EC_KEY_set_private_key(key, priv);
    
    ctx = BN_CTX_new();
    BN_CTX_start(ctx);
    group = EC_KEY_get0_group(key);
    pub = EC_POINT_new(group);
    EC_POINT_mul(group, pub, priv, NULL, NULL, ctx);
    EC_KEY_set_public_key(key, pub);
    
    
    BIGNUM *x = BN_new();
    BIGNUM *y = BN_new();
    
    if (EC_POINT_get_affine_coordinates_GFp(group, pub, x, y, NULL)) {
        
        strcpy(kp.hexPrikey,hexpriv);
//        kp.prikey = std::string((char*)hexpriv);

        NSMutableString *outStrg = [NSMutableString string];
        char* strx=BN_bn2hex(x);
        char* stry=BN_bn2hex(y);
        [outStrg appendFormat:@"%s%s",strx,stry];
        strcpy(kp.hexPubkey ,[outStrg cStringUsingEncoding:NSASCIIStringEncoding]);
        BIGNUM *bn_addr = BN_new();
        BN_hex2bn(&bn_addr, kp.hexPubkey);
        //        const char* addrhex=[outStrg UTF8String];
        int bytesize=BN_num_bytes(bn_addr);
        unsigned char * bb_addr=new unsigned char[bytesize];
        BN_bn2bin(bn_addr, bb_addr);
        class Keccak sha;
        //sha256(jx,len,d.get(),dlen);
        unsigned char * dest_addr=new unsigned  char[bytesize];
        sha(bb_addr,64,dest_addr,32);

        BN_bin2bn(dest_addr, 32, bn_addr);
        char*  straddr=BN_bn2hex(bn_addr);
        strcpy(kp.hexAddress,&straddr[24]);//64-40=24
        //address
        OPENSSL_free(strx);
        OPENSSL_free(stry);
        OPENSSL_free(straddr);
        free(bb_addr);
        free(dest_addr);
        
        BN_free(bn_addr);
    }
    
    BN_free(x);
    BN_free(y);
    EC_POINT_free(pub);
    BN_CTX_end(ctx);
    BN_CTX_free(ctx);
    BN_clear_free(priv);
    EC_KEY_free(key);

    
    return kp;
}

int ethSign(KeyPair kp,const char *content,int length, char *hexsign,unsigned int &hexlen){
    
    EC_KEY *key;
    BIGNUM *priv;
    BN_CTX *ctx;
    const EC_GROUP *group;
    EC_POINT *pub;
    key = EC_KEY_new_by_curve_name(NID_secp256k1);
    priv = BN_new();
    BN_hex2bn(&priv, kp.hexPrikey);
    EC_KEY_set_private_key(key, priv);
    
    ctx = BN_CTX_new();
    BN_CTX_start(ctx);
    group = EC_KEY_get0_group(key);
    pub = EC_POINT_new(group);
    EC_POINT_mul(group, pub, priv, NULL, NULL, ctx);
    EC_KEY_set_public_key(key, pub);
    
    class Keccak sha;
    unsigned char hash[32]={0};
    sha(content,length,hash,32);
//    {
//        BIGNUM *bnhash = BN_new();
//        BN_bin2bn(hash, 32, bnhash);
//        char* strhash=BN_bn2hex(bnhash);
//        
//        NSLog(@"Hash=%s",strhash);
//        
//        BN_free(bnhash);
//        OPENSSL_free(strhash);
//        
//    }
    
    ECDSA_SIG *sig = ECDSA_do_sign(hash, SHA256_DIGEST_LENGTH, key);

    if (sig == NULL) {
        printf("Failed to generate EC Signature\n");
        BN_CTX_end(ctx);
        BN_CTX_free(ctx);
        BN_clear_free(priv);
        EC_KEY_free(key);
        EC_POINT_free(pub);

        return -1;

    }
    NSMutableString *outStrg = [NSMutableString string];
//    [outStrg appendFormat:@"%s",kp.hexPubkey];
//    [outStrg appendFormat:@"%s",kp.hexAddress];
    {
        
        const BIGNUM *r;
        const BIGNUM *s;
        ECDSA_SIG_get0(sig,&r,&s);
        char* strx=BN_bn2hex(r);
        char* stry=BN_bn2hex(s);
        [outStrg appendFormat:@"1B%s%s",strx,stry];
//        NSLog(@"Sig=%@,size=%d,%d",outStrg,BN_num_bytes(r),BN_num_bytes(s));
    }
    
    hexlen = 296;
    strcpy(hexsign,[outStrg cStringUsingEncoding:NSASCIIStringEncoding]);
    EC_POINT_free(pub);
    BN_CTX_end(ctx);
    BN_CTX_free(ctx);
    BN_clear_free(priv);
    EC_KEY_free(key);
    ECDSA_SIG_free(sig);
   
    return 0;
}

KeyPair  eth_genRandKey(){
    unsigned char buffer[64];
    RAND_bytes(buffer, 64);
    BIGNUM *priv = BN_new();
    BN_bin2bn(buffer, 32,priv);
    char *hexstr=BN_bn2hex(priv);
    KeyPair kp  = eth_genFromPrivKey(hexstr);
    BN_free(priv);
    OPENSSL_free(hexstr);
    return kp;
}

@implementation EthereumUtils : NSObject
+ (KeyPair)genFromPrikey:(NSString *)hexPrikey {
    const char *key=[hexPrikey UTF8String];
    return eth_genFromPrivKey(key);
}
+ (KeyPair) genRandomKey{
    return eth_genRandKey();
}
+ (NSString*)ecSign:(KeyPair)kp content:(NSString*)msg{
    NSMutableString *outStrg = [NSMutableString string];
    
    char outstr[300]={0};
    unsigned int signlen=0;
    const char * strmsg=[msg cStringUsingEncoding:(NSASCIIStringEncoding)];
    int sigret=ethSign(kp,strmsg,strlen(strmsg),outstr,signlen);
//    NSLog(@"ecsign==%d==>%d::%s",sigret,signlen,outstr);
    [outStrg appendFormat:@"%s",outstr ];
    return outStrg;
}

+(NSString*)evalJS:(NSString*) jsmethod{
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"ethsign" ofType:@"js"];
    JSContext *context = [[JSContext alloc] init];
    NSError *error = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    [context evaluateScript:content];
    //    NSLog(@"calllMethod:%@",jsmethod);
    JSValue *value = [context evaluateScript:jsmethod];
    
    return [value toString];
}


+ (NSString*)ecSignTransaction:(KeyPair)kp nonce:(NSString*)hexnonce gasPrice:(NSString*)hexgasPrice
        gasLimit:(NSString*)hexgasLimit  to:(NSString*)toAddr  hexvalue:(NSString*)hexvalue data:(NSString*)data chainId:(int)chainid
{
    
    // EIP 155 chainId - mainnet: 1, ropsten: 3
    NSLog(@"hexnonce：%@   hexgasPrice：%@   hexgasLimit：%@   toAddr：%@    hexvalue：%@   data：%@   chainid：%d    hexPrikey：%s",hexnonce,hexgasPrice,hexgasLimit,toAddr,hexvalue,data,chainid,kp.hexPrikey);
    return [EthereumUtils evalJS:[NSString stringWithFormat:
                                  @"var tx = new ethsign({   \
                                  nonce: '%@',    \
                                  gasPrice: '%@',   \
                                  gasLimit: '%@',   \
                                  to: '%@', \
                                  value: '%@',    \
                                  data: '%@',   \
                                  chainId: %d    \
                                  });tx.sign('%s');tx.serialize().toString('hex')"
                          ,hexnonce,hexgasPrice,hexgasLimit,toAddr,hexvalue,data,chainid,
                                  kp.hexPrikey
                                  ]];
    
    
}


@end

