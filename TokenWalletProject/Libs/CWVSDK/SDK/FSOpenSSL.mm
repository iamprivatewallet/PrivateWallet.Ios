//
//  FSOpenSSL.m
//  OpenSSL-for-iOS
//
//  Created by Felix Schulze on 16.03.2013.
//  Copyright 2013 Felix Schulze. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "FSOpenSSL.h"
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

@implementation FSOpenSSL


EC_KEY *bbp_ec_new_keypair(const uint8_t *priv_bytes) {
    EC_KEY *key;
    BIGNUM *priv;
    BN_CTX *ctx;
    const EC_GROUP *group;
    EC_POINT *pub;
    
    /* init empty OpenSSL EC keypair */
    
    unsigned char buffer[64];
    RAND_bytes(buffer, 64);
    //f3c122d42251d761882f5a49d9ff1d5491e50a5add8f5886bb25a921f3379e24
    
    
    
    key = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
    
    /* set private key through BIGNUM */
    
    priv = BN_new();
//    BN_bin2bn(priv_bytes, 32, priv);
    BN_hex2bn(&priv, "f3c122d42251d761882f5a49d9ff1d5491e50a5add8f5886bb25a921f3379e24");
    EC_KEY_set_private_key(key, priv);
    
    /* derive public key from private key and group */
    
    ctx = BN_CTX_new();
    BN_CTX_start(ctx);
    
    group = EC_KEY_get0_group(key);
    pub = EC_POINT_new(group);
    EC_POINT_mul(group, pub, priv, NULL, NULL, ctx);
    EC_KEY_set_public_key(key, pub);
    
    /* release resources */
    
   
    BIGNUM *x = BN_new();
    BIGNUM *y = BN_new();
    
    if (EC_POINT_get_affine_coordinates_GFp(group, pub, x, y, NULL)) {
        BN_print_fp(stdout, x);
        putc('\n', stdout);
        BN_print_fp(stdout, y);
        putc('\n', stdout);
        
        NSMutableString *outStrg = [NSMutableString string];
        char* strx=BN_bn2hex(x);
        char* stry=BN_bn2hex(y);
        for(int i=0;i<63;i+=2){
            putc(strx[62-i],stdout);
            putc(strx[63-i],stdout);
            [outStrg appendFormat:@"%c%c",strx[62-i],strx[63-i]];
        }
        for(int i=0;i<63;i+=2){
            [outStrg appendFormat:@"%c%c",stry[62-i],stry[63-i]];
        }
        
        
        
        BIGNUM *bn_addr = BN_new();
        
        
        BN_hex2bn(&bn_addr, [outStrg UTF8String]);
//        const char* addrhex=[outStrg UTF8String];
        int bytesize=BN_num_bytes(bn_addr);
        
        unsigned char * bb_addr=new unsigned char[bytesize];
        BN_bn2bin(bn_addr, bb_addr);
        class SHA256 sha256;
        //sha256(jx,len,d.get(),dlen);
        unsigned char * dest_addr=new unsigned char[bytesize];

        sha256(bb_addr,64,dest_addr,32);
        
//        NSString *addr = [[FSOpenSSL sha256FromString:outStrg] substringToIndex:40];
//        [outStrg appendFormat:@"%s",strx];
//        [outStrg appendFormat:@"%s",stry];
        NSLog(@"pubkey==%@",outStrg);
        BN_bin2bn(dest_addr, 20, bn_addr);
        char*  straddr=BN_bn2hex(bn_addr);
        NSLog(@"address==%s",straddr);

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
    
    return key;
}


+ (NSString *)md5FromString:(NSString *)string {
    unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [string length];
    unsigned char result[MD5_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    MD5(inStrg, lngth, result);

    unsigned int i;
    for (i = 0; i < MD5_DIGEST_LENGTH; i++) {
       // [outStrg appendFormat:@"%02x", result[i]];
    }

    EC_KEY * key =bbp_ec_new_keypair(0);
    
    unsigned char keyoct[256];
    for (i = 0; i < 256; i++) {
        keyoct[i]=0;
    }
    EC_KEY_priv2oct(key,keyoct,32);
    
    EC_KEY_free(key);
    
    for (i = 0; i < 32; i++) {
         [outStrg appendFormat:@"%02x", keyoct[i]];
    }
    
    NSLog(@"key==%@",outStrg);
    
//    [outStrg appendFormat:@"%s", keyoct];

    
    return [outStrg copy];
}

+ (NSString *)sha256FromString:(NSString *)string {
    unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [string length];
    unsigned char result[SHA256_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, inStrg, lngth);
    SHA256_Final(result, &sha256);
    
    unsigned int i;
    for (i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

+ (NSString *)base64FromString:(NSString *)string encodeWithNewlines:(BOOL)encodeWithNewlines {
    BIO *mem = BIO_new(BIO_s_mem());
    BIO *b64 = BIO_new(BIO_f_base64());

    if (!encodeWithNewlines) {
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    }
    mem = BIO_push(b64, mem);

    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = stringData.length;
    void *buffer = (void *) [stringData bytes];
    int bufferSize = (int)MIN(length, INT_MAX);

    NSUInteger count = 0;

    BOOL error = NO;

    // Encode the data
    while (!error && count < length) {
        int result = BIO_write(mem, buffer, bufferSize);
        if (result <= 0) {
            error = YES;
        }
        else {
            count += result;
            buffer = (char*) [stringData bytes] + count;
            bufferSize = (int)MIN((length - count), INT_MAX);
        }
    }

    int flush_result = BIO_flush(mem);
    if (flush_result != 1) {
        return nil;
    }

    char *base64Pointer;
    NSUInteger base64Length = (NSUInteger) BIO_get_mem_data(mem, &base64Pointer);

    NSData *base64data = [NSData dataWithBytesNoCopy:base64Pointer length:base64Length freeWhenDone:NO];
    NSString *base64String = [[NSString alloc] initWithData:base64data encoding:NSUTF8StringEncoding];

    BIO_free_all(mem);
    return base64String;
}

@end
