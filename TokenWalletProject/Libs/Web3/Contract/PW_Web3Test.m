//
//  PW_Web3Test.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/11.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_Web3Test.h"

@implementation PW_Web3Test

+ (void)test {
    NSString *privateKey = @"";
    NSString *contract = @"0xc4ff1eb1dfc480754f86610763be446ff2e28827";
    NSString *toContract = @"";
    NSString *address = @"0xdb942296564963d49a21bc17cf764f82564856e9";
    NSString *toAddress = @"0x2093c44a1990fDdD1f2976A70e1B525510530401";
    NSString *tokenId = @"21000000001";
    [[PWWalletERC721ContractTool shared] estimateGasWithContract:contract to:toAddress completionHandler:^(NSString * _Nullable gas, NSString * _Nullable gasPrice, NSString * _Nullable errorDesc) {
        NSLog(@"%@==%@==%@",gas,gasPrice,errorDesc);
    }];
//    [[PWWalletERC721ContractTool shared] balanceOfContract:contract address:address completionHandler:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
//        NSLog(@"%@===%@",balance,errorDesc);
//    }];
//    [[PWWalletERC721ContractTool shared] approveWithPrivateKey:privateKey contract:contract to:toContract tokenId:tokenId gas:@"100000" gasPrice:@"5" completionHandler:^(NSString * _Nullable result, NSString * _Nullable errorDesc) {
//
//    }];
    [[PWWalletERC721ContractTool shared] getApprovedWithContract:contract tokenId:tokenId completionHandler:^(BOOL isApproved, NSString * _Nullable errorDesc) {

    }];
//    [[PWWalletERC721ContractTool shared] transferWithPrivateKey:privateKey contract:contract to:toAddress tokenId:tokenId gas:@"100000" gasPrice:@"5" completionHandler:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
//
//    }];
}

@end
