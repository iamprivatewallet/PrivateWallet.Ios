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
//    [PW_Solana getBalanceWithAccount:myAccount[@"publicKey"] completionBlock:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
//        NSLog(@"myAccount balance==%@,error:%@",balance,errorDesc);
//    }];
//    [PW_Solana getAccountInfoWithAccount:myAccount[@"publicKey"] completionBlock:^(NSDictionary<NSString *,id> * _Nullable info, NSString * _Nullable errorDesc) {
//        NSLog(@"myAccount info==%@,error:%@",info,errorDesc);
//    }];
    NSDictionary *account = [PW_Solana restoreAccountWithPhrase:@[@"life",@"funny",@"speak",@"broom",@"relax",@"thought",@"across",@"conduct",@"media",@"web",@"common",@"skill"]];
    NSLog(@"account===%@",account);
//    [PW_Solana getAccountInfoWithAccount:account[@"publicKey"] completionBlock:^(NSDictionary<NSString *,id> * _Nullable info, NSString * _Nullable errorDesc) {
//        NSLog(@"account info==%@,error:%@",info,errorDesc);
//    }];
//    [PW_Solana getBalanceWithAccount:account[@"publicKey"] completionBlock:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
//        NSLog(@"account balance==%@,error:%@",balance,errorDesc);
//    }];
//    [PW_Solana sendSOLWithSecretKey:account[@"secretKey"] to:myAccount[@"publicKey"] amount:1000000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//        NSLog(@"sol hash==%@,error:%@",hash,errorDesc);
//    }];
//    NSString *tokenAddress = @"Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB";
//    [PW_Solana getOrCreateAssociatedTokenAccountWithOwner:myAccount[@"publicKey"] payerSecretKey:myAccount[@"secretKey"] mintAddress:tokenAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//        NSString *fromAddress = data[@"address"];
//        [PW_Solana getOrCreateAssociatedTokenAccountWithOwner:account[@"publicKey"] payerSecretKey:myAccount[@"secretKey"] mintAddress:tokenAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//            NSString *toAddress = data[@"address"];
//            if (toAddress != nil) {
//                [PW_Solana sendSPLWithMintAddress:tokenAddress source:fromAddress secretKey:myAccount[@"secretKey"] to:toAddress amount:10000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//                    NSLog(@"myAccount spl hash:%@,error:%@",hash,errorDesc);
//                }];
//            }
//        }];
//    }];
//    [PW_Solana findSPLTokenDestinationAddressWithMintAddress:tokenAddress destinationAddress:myAccount[@"publicKey"] completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//        NSLog(@"myAccount findSPLToken:%@,error:%@",data,errorDesc);
//        NSString *fromAddress = data[@"address"];
//        [PW_Solana getBlanceWithPubkey:fromAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//            NSLog(@"myAccount tokenBalance:%@,error:%@",data,errorDesc);
//        }];
//        [PW_Solana findSPLTokenDestinationAddressWithMintAddress:tokenAddress destinationAddress:account[@"publicKey"] completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//            NSLog(@"account findSPLToken:%@,error:%@",data,errorDesc);
//            NSString *toAddress = data[@"address"];
//            if (toAddress != nil) {
//                [PW_Solana getBlanceWithPubkey:toAddress completionBlock:^(NSDictionary<NSString *,NSString *> * _Nullable data, NSString * _Nullable errorDesc) {
//                    NSLog(@"account tokenBalance:%@,error:%@",data,errorDesc);
//                }];
//                [PW_Solana sendSPLWithMintAddress:tokenAddress source:fromAddress secretKey:myAccount[@"secretKey"] to:toAddress amount:10000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//                    NSLog(@"myAccount spl hash:%@,error:%@",hash,errorDesc);
//                }];
//                [PW_Solana sendSPLWithMintAddress:tokenAddress source:toAddress secretKey:account[@"secretKey"] to:fromAddress amount:10000 completionBlock:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//                    NSLog(@"account spl hash:%@,error:%@",hash,errorDesc);
//                }];
//            }
//        }];
//    }];
}

@end
