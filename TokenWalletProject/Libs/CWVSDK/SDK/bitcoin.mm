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
#include "libbase58.h"
#include "sha256.h"
#include <openssl/ripemd.h>

#include "brewchain.h"
 


KeyPair btc_genFromPrivKey(const char *hexpriv) {
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
        [outStrg appendFormat:@"03%s",strx];
        strcpy(kp.hexPubkey ,[outStrg UTF8String]);
//        NSLog(@"pubkey==%@",outStrg)
        
        class SHA256 sha;
        unsigned char *pubkey_data = new unsigned char[33];
        BN_bn2bin(x, &pubkey_data[1]);
        pubkey_data[0]=0x03;
        
        unsigned char * pub_256hash=new unsigned  char[32];
        sha(pubkey_data,33,pub_256hash,32);
        free(pubkey_data);
//        {
//            //output hash256
//            BIGNUM *bn = BN_new();
//            BN_bin2bn(pub_256hash, 32, bn);//(bn_addr, pub_160ripemd);
//            char*  straddr=BN_bn2hex(bn);
//            NSLog(@"Hash256.1=%s",straddr);
//            OPENSSL_free(straddr);
//            BN_free(bn);
//        }
        unsigned char * pub_160ripemd=new unsigned  char[20];
        RIPEMD160(pub_256hash,32,pub_160ripemd);
        
//        BIGNUM *bn_addr = BN_new();
//        BN_bin2bn(v2, 20, bn_addr);//(bn_addr, pub_160ripemd);
//        char*  pubkeyhash=BN_bn2hex(bn_addr);
        //pubkey-hash
        unsigned char * addressBytes=new unsigned char[1 + 20 + 4];
        addressBytes[0]=0;//MainNet==0,TestNet=111
        memcpy(&addressBytes[1], pub_160ripemd, 20);
        memset(&addressBytes[21],0,4);
        addressBytes[0]=0;
//        {
//            BIGNUM *bn = BN_new();
//            BN_bin2bn(addressBytes, 25, bn);//(bn_addr, pub_160ripemd);
//            char*  straddr=BN_bn2hex(bn);
//            NSLog(@"160ripemd.e=%s",straddr);
//            OPENSSL_free(straddr);
//            BN_free(bn);
//        }
    
        class SHA256  sha_1;
        unsigned char * addressbyte_hash_1=new unsigned  char[32];
        sha_1(addressBytes, 21,addressbyte_hash_1,32);
        class SHA256  sha_2;
        unsigned char * addressbyte_hash_2=new unsigned  char[32];
        sha_2.add(addressBytes, 21);
        sha_2(addressbyte_hash_1,32,addressbyte_hash_2,32);
//        {
//            BIGNUM *bn = BN_new();
//            BN_bin2bn(addressbyte_hash_2, 32, bn);//(bn_addr, pub_160ripemd);
//            char*  straddr=BN_bn2hex(bn);
//            NSLog(@"hashtwice.1=%s",straddr);
//            OPENSSL_free(straddr);
//            BN_free(bn);
//        }
        memcpy(&addressBytes[21],addressbyte_hash_2,4);
        free(addressbyte_hash_2);
        free(addressbyte_hash_1);
//        {
//            BIGNUM *bn = BN_new();
//            BN_bin2bn(addressBytes, 25, bn);//(bn_addr, pub_160ripemd);
//            char*  straddr=BN_bn2hex(bn);
//            NSLog(@"address=%s",straddr);
//            OPENSSL_free(straddr);
//            BN_free(bn);
//        }
        char * b58=new   char[128];
        memset(b58, 0, 128);
        size_t b58sz = 100;
        b58enc(b58, &b58sz,(const void *)addressBytes, 25);
//        NSLog(@"base58=%ld:%s",b58sz,b58);
        strcpy(kp.hexAddress,b58);
        
//        System.arraycopy(bytes, 0, addressBytes, 1, bytes.length);
//        System.out.println("addressBytes.=="+Hex.toHexString(addressBytes));
        
//        byte[] checksum = Sha256Hash.hashTwice(addressBytes, 0, bytes.length + 1);
//        System.arraycopy(checksum, 0, addressBytes, bytes.length + 1, 4);
//        System.out.println("addressBytes.hash=="+Hex.toHexString(addressBytes));

        
        
        
//        strcpy(kp.hexAddress,pubkeyhash);
        free(b58);
        free(pub_256hash);
        free(pub_160ripemd);
        
        free(addressBytes);
        //address
        OPENSSL_free(strx);
        OPENSSL_free(stry);
//        OPENSSL_free(pubkeyhash);
        
        
//        BN_free(bn_addr);
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

int btcSign(KeyPair kp,const char *content,int length, char *hexsign,unsigned int &hexlen){
    
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
    
    class SHA256 sha;
    unsigned char hash[32]={0};
    sha(content,length,hash,32);
    {
        BIGNUM *bnhash = BN_new();
        BN_bin2bn(hash, 32, bnhash);
        char* strhash=BN_bn2hex(bnhash);
    
        NSLog(@"message.Hash=%s",strhash);
    
        BN_free(bnhash);
        OPENSSL_free(strhash);
    
    }
    
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
        [outStrg appendFormat:@"%s%s",strx,stry];
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

KeyPair  btc_genRandKey(){
    unsigned char buffer[64];
    RAND_bytes(buffer, 64);
    BIGNUM *priv = BN_new();
    BN_bin2bn(buffer, 32,priv);
    char *hexstr=BN_bn2hex(priv);
    KeyPair kp  = btc_genFromPrivKey(hexstr);
    BN_free(priv);
    OPENSSL_free(hexstr);
    return kp;
}

@implementation BitcoinUtils : NSObject
+ (KeyPair)genFromPrikey:(NSString *)hexPrikey {
    const char *key=[hexPrikey UTF8String];
    return btc_genFromPrivKey(key);
}
+ (KeyPair) genRandomKey{
    return btc_genRandKey();
}
+ (NSString*)ecSign:(KeyPair)kp content:(NSString*)msg{
    NSMutableString *outStrg = [NSMutableString string];
    
    char outstr[300]={0};
    unsigned int signlen=0;
    const char * strmsg=[msg cStringUsingEncoding:(NSASCIIStringEncoding)];
    int sigret=btcSign(kp,strmsg,strlen(strmsg),outstr,signlen);
//    NSLog(@"ecsign==%d==>%d::%s",sigret,signlen,outstr);
    [outStrg appendFormat:@"%s",outstr ];
    return outStrg;
}

@end

