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
#include "sha3.h"
#include <string>
#include "sha256.h"

#include "brewchain.h"
 


KeyPair bc_genFromPrivKey(const char *hexpriv) {
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
    key = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
    priv = BN_new();
    
 
    char rehexpriv[65]={0};
    for(int i=0;i<63;i+=2){
        rehexpriv[i] = hexpriv[62-i];
        rehexpriv[i+1] = hexpriv[63-i];
    }

    
    BN_hex2bn(&priv, rehexpriv);//"f3c122d42251d761882f5a49d9ff1d5491e50a5add8f5886bb25a921f3379e24");
    
    
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
        for(int i=0;i<63;i+=2){
            [outStrg appendFormat:@"%c%c",strx[62-i],strx[63-i]];
        }
        for(int i=0;i<63;i+=2){ 
            [outStrg appendFormat:@"%c%c",stry[62-i],stry[63-i]];
        }
        strcpy(kp.hexPubkey ,[outStrg UTF8String]);
        BIGNUM *bn_addr = BN_new();
        BN_hex2bn(&bn_addr, [outStrg UTF8String]);
        //        const char* addrhex=[outStrg UTF8String];
        int bytesize=BN_num_bytes(bn_addr);
        unsigned char * bb_addr=new unsigned char[bytesize];
        BN_bn2bin(bn_addr, bb_addr);
        class SHA256 sha256;
        //sha256(jx,len,d.get(),dlen);
        unsigned char * dest_addr=new unsigned  char[bytesize];
        sha256(bb_addr,64,dest_addr,32);

        //        NSString *addr = [[FSOpenSSL sha256FromString:outStrg] substringToIndex:40];
        //        [outStrg appendFormat:@"%s",strx];
        //        [outStrg appendFormat:@"%s",stry];
//        NSLog(@"pubkey==%@",outStrg);
        BN_bin2bn(dest_addr, 20, bn_addr);
        char*  straddr=BN_bn2hex(bn_addr);
//        NSLog(@"address==%s",straddr);
        strcpy(kp.hexAddress,straddr);
        //address
        OPENSSL_free(strx);
        OPENSSL_free(stry);
        OPENSSL_free(straddr);
        free(bb_addr);
        free(dest_addr);
        
        BN_free(bn_addr);
    }
    
    
    //hexEnc(Arrays.copyOfRange(sha256Encode(pubKeyByte), 0, 20))
    
    BN_free(x);
    BN_free(y);
    EC_POINT_free(pub);
    BN_CTX_end(ctx);
    BN_CTX_free(ctx);
    BN_clear_free(priv);
    EC_KEY_free(key);

    
    return kp;
}

typedef struct ECDSA_SIGs
{
    BIGNUM *r;
    BIGNUM *s;
} ECDSA_SIG_ST;


int ecSign(KeyPair kp,const char *hexcontent,int length, char *hexsign,unsigned int &hexlen){
    
    EC_KEY *key;
    BIGNUM *priv;
    BN_CTX *ctx;
    const EC_GROUP *group;
    EC_POINT *pub;
    key = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
    priv = BN_new();
//    BN_hex2bn(&priv, kp.hexPrikey);
    char rehexpriv[65]={0};
    for(int i=0;i<63;i+=2){
        rehexpriv[i] = kp.hexPrikey[62-i];
        rehexpriv[i+1] = kp.hexPrikey[63-i];
    }
    
    BN_hex2bn(&priv, rehexpriv);//"f3c122d42251d761882f5a49d9ff1d5491e50a5add8f5886bb25a921f3379e24");
    
    EC_KEY_set_private_key(key, priv);
    
    ctx = BN_CTX_new();
    BN_CTX_start(ctx);
    group = EC_KEY_get0_group(key);
    pub = EC_POINT_new(group);
    EC_POINT_mul(group, pub, priv, NULL, NULL, ctx);
    EC_KEY_set_public_key(key, pub);
    
    class SHA256 sha256;
    unsigned char hash[32]={0};
    
    sha256(hexcontent,length,hash,32);
    
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
    [outStrg appendFormat:@"%s",kp.hexPubkey];
    [outStrg appendFormat:@"%s",kp.hexAddress];
    {
        
        const BIGNUM *r;
        const BIGNUM *s;
        ECDSA_SIG_get0(sig,&r,&s);
        char* strx=BN_bn2hex(r);
        char* stry=BN_bn2hex(s);
        for(int i=0;i<63;i+=2){
            [outStrg appendFormat:@"%c%c",strx[62-i],strx[63-i]];
        }
        for(int i=0;i<63;i+=2){
            [outStrg appendFormat:@"%c%c",stry[62-i],stry[63-i]];
        }
        OPENSSL_free(strx);
        OPENSSL_free(stry);
        NSLog(@"Sig=%@,size=%d,%d",outStrg,BN_num_bytes(r),BN_num_bytes(s));
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

int ecHexSign(KeyPair kp,const char *hexContent,int length, char *hexsign,unsigned int &hexlen){
    BIGNUM *bn=BN_new();
    BN_hex2bn(&bn, hexContent);
    int bytesize=BN_num_bytes(bn);
    unsigned char *bytes=new unsigned char [bytesize];
    BN_bn2bin(bn,bytes);
    int ret = ecSign(kp,(const char *)bytes,bytesize,hexsign,hexlen);
    free(bytes);
    BN_clear_free(bn);
    return ret;
    
}

KeyPair  bc_genRandKey(){
    unsigned char buffer[64];
    RAND_bytes(buffer, 64);
    BIGNUM *priv = BN_new();
    BN_bin2bn(buffer, 32,priv);
    char *hexstr=BN_bn2hex(priv);
    KeyPair kp  = bc_genFromPrivKey(hexstr);
    BN_free(priv);
    OPENSSL_free(hexstr);
    return kp;
}

@implementation BrewChainUtils : NSObject
+ (KeyPair)genFromPrikey:(NSString *)hexPrikey {
    const char *key=[hexPrikey UTF8String];
    return bc_genFromPrivKey(key);
}
+ (KeyPair) genRandomKey{
    return bc_genRandKey();
}

+ (NSString*)ecSign:(KeyPair)kp content:(NSString*)msg{
    NSMutableString *outStrg = [NSMutableString string];
    
    char outstr[300]={0};
    unsigned int signlen=0;
    const char * strmsg=[msg cStringUsingEncoding:(NSASCIIStringEncoding)];
    int sigret=ecSign(kp,strmsg,strlen(strmsg),outstr,signlen);
    //    NSLog(@"ecsign==%d==>%d::%s",sigret,signlen,outstr);
    [outStrg appendFormat:@"%s",outstr ];
    return outStrg;
}

+ (NSString*)ecHexSign:(KeyPair)kp content:(NSString*)hexmsg{
    NSMutableString *outStrg = [NSMutableString string];
    
    char outstr[300]={0};
    unsigned int signlen=0;
    const char * strmsg=[hexmsg cStringUsingEncoding:(NSASCIIStringEncoding)];
    int sigret=ecHexSign(kp,strmsg,strlen(strmsg),outstr,signlen);
    //    NSLog(@"ecsign==%d==>%d::%s",sigret,signlen,outstr);
    [outStrg appendFormat:@"%s",outstr ];
    return outStrg;
}

@end

@implementation KeyPairHelper

+ (NSString*)hexPrikey:(KeyPair)kp {
    NSMutableString *outStrg = [NSMutableString string];
    [outStrg appendFormat:@"%s",kp.hexPrikey];
    return outStrg;
}
+ (NSString*)hexPubkey:(KeyPair)kp{
    NSMutableString *outStrg = [NSMutableString string];
    [outStrg appendFormat:@"%s",kp.hexPubkey];
    return outStrg;
}
+ (NSString*)hexAddress:(KeyPair)kp{
    NSMutableString *outStrg = [NSMutableString string];
    [outStrg appendFormat:@"%s",kp.hexAddress];
//    NSLog(@"address=%@::%s",outStrg,kp.hexAddress);
    return outStrg;
}



@end
