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
//    [PW_Solana airdropWithAccount:account[@"publicKey"] completionBlock:^(NSString * _Nullable success, NSString * _Nullable errorDesc) {
//        NSLog(@"success=%@",success);
//    }];
    [PW_Solana getBalanceWithAccount:account[@"publicKey"] completionBlock:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
        NSLog(@"balance==%@,error:%@",balance,errorDesc);
    }];
    [PW_Solana sendSOLWithSecretKey:myAccount[@"secretKey"] to:@"HZNEVMMCiukW8G85tNejcHApNimwtoJsUrNAzNnLwcnt" amount:1000000000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
        NSLog(@"hash==%@,error:%@",hash,errorDesc);
    }];
}

@end
