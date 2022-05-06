//
//  PW_SolanaTest.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SolanaTest.h"

@implementation PW_SolanaTest

+ (void)test {
//    NSDictionary *newAccount = [PW_Solana createAccount];
//    NSLog(@"newAccount=%@",newAccount);
    NSDictionary *myAccount = [PW_Solana restoreAccountWithPhrase:@[@"road",@"skill",@"wing",@"guess",@"pull",@"chalk",@"trend",@"harvest",@"bargain",@"much",@"jacket",@"ivory"]];
    NSLog(@"myAccount=%@",myAccount);
    [PW_Solana getBalanceWithAccount:myAccount[@"publicKey"] completionBlock:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
        NSLog(@"myAccount balance==%@,error:%@",balance,errorDesc);
    }];
    [PW_Solana getAccountInfoWithAccount:myAccount[@"publicKey"] completionBlock:^(NSDictionary<NSString *,id> * _Nullable info, NSString * _Nullable errorDesc) {
        NSLog(@"myAccount info==%@,error:%@",info,errorDesc);
    }];
//    NSDictionary *account = [PW_Solana restoreAccountWithPhrase:@[@"know",@"general",@"memory",@"scheme",@"cotton",@"ship",@"knee",@"suit",@"rather",@"pet",@"donkey",@"way",@"maximum",@"similar",@"candy",@"indicate",@"blade",@"lunch",@"analyst",@"around",@"hockey",@"remove",@"nominee",@"benefit"]];
    NSDictionary *account = [PW_Solana restoreAccountWithSecretKey:@"46cp3plRjPYYlRhZnztmHY83tnBpknjAbvjJXRWWi6L2BZWejSvKlprtL8VhJ7CBjnGgjPy8ASt3sKFrhxIA0Q=="];
    NSLog(@"===%@",account);
//    [PW_Solana airdropWithAccount:@"84NyHf4EQo9mjxUdpiG1cxVd1qA6dFLYuA72cHzavqVo" completionBlock:^(NSString * _Nullable success, NSString * _Nullable errorDesc) {
//        NSLog(@"success=%@",success);
//    }];
    [PW_Solana getBalanceWithAccount:account[@"publicKey"] completionBlock:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
        NSLog(@"balance==%@,error:%@",balance,errorDesc);
    }];
//    [PW_Solana sendSOLWithSecretKey:myAccount[@"secretKey"] to:@"HZNEVMMCiukW8G85tNejcHApNimwtoJsUrNAzNnLwcnt" amount:1000000000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//        NSLog(@"hash==%@,error:%@",hash,errorDesc);
//    }];
    NSString *mintAddress = @"So11111111111111111111111111111111111111112";
//    [PW_Solana createTokenAccountWithMintAddress:mintAddress secretKey:account[@"secretKey"] completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//        NSLog(@"createTokenAccount:%@,error:%@",data,errorDesc);
//    }];
    [PW_Solana findSPLTokenDestinationAddressWithMintAddress:mintAddress destinationAddress:account[@"publicKey"] completionBlock:^(NSString * _Nullable address, NSString * _Nullable errorDesc) {
        NSLog(@"findSPLToken:%@,error:%@",address,errorDesc);
    }];
//    [PW_Solana getOrCreateAssociatedTokenAccountWithSecretKey:@"mZA9MuoYEdZNTrLTo6KWEeJFIgIxHOpGLJhBVIK1SY1o32SboB0j72n1qk1YFgbJNmsM2FCGBsWqT7ZR3cPrvg==" mintAddress:mintAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//        NSString *fromAddress = data[@"address"];
//        NSString *hash = data[@"hash"];
//        NSLog(@"fromAddress:%@,hash:%@,error:%@",fromAddress,hash,errorDesc);
//    }];
//    [PW_Solana getOrCreateAssociatedTokenAccountWithSecretKey:myAccount[@"secretKey"] mintAddress:mintAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//        NSLog(@"fromAddress:%@,error:%@",data,errorDesc);
//        [PW_Solana getOrCreateAssociatedTokenAccountWithSecretKey:account[@"secretKey"] mintAddress:mintAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//            NSString *toAddress = data[@"address"];
//            NSLog(@"toAddress:%@,error:%@",data,errorDesc);
//            [PW_Solana sendSPLWithMintAddress:mintAddress secretKey:myAccount[@"secretKey"] to:toAddress amount:10000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//                NSLog(@"spl hash:%@,error:%@",hash,errorDesc);
//            }];
//        }];
//    }];
}

@end
