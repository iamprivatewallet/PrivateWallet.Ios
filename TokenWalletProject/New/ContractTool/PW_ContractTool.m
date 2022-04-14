//
//  PW_ContractTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ContractTool.h"

@implementation PW_ContractTool

+ (void)loadETHMainBalanceDecimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    NSDictionary *parmDic = @{
        @"id":@"67",
        @"jsonrpc":@"2.0",
        @"method":@"eth_getBalance",
        @"params":@[walletAddress,@"latest"],
    };
    NSString *urlStr = User_manager.currentUser.current_Node;
    //eth余额查询
    [AFNetworkClient requestPostWithUrl:urlStr withParameter:parmDic withBlock:^(id data, NSError *error) {
        if(error==nil){
            NSString *amount = [UITools bigStringWith16String:data[@"result"]];
            amount = [amount stringDownDividingBy10Power:18];
            completion(amount);
        }else{
            completion(nil);
        }
    }];
}
+ (void)loadETHTokenBalance:(NSString *)tokenAddress decimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    NSDictionary *parmDic = @{
        @"id":@"67",
        @"jsonrpc":@"2.0",
        @"method":@"eth_call",
        @"params":@[@{
                    @"data":NSStringWithFormat(@"0x70a08231000000000000000000000000%@",[walletAddress formatDelEth]),
                    @"from":walletAddress,
                    @"to":tokenAddress,
                    },@"latest"],
    };
    NSString *urlStr = User_manager.currentUser.current_Node;
    [AFNetworkClient requestPostWithUrl:urlStr withParameter:parmDic withBlock:^(id data, NSError *error) {
        if(error==nil){
            NSString *amount = [UITools bigStringWith16String:data[@"result"]];
            amount = [amount stringDownDividingBy10Power:18];
            completion(amount);
        }else{
            completion(nil);
        }
    }];
}

+ (void)loadCVNMainBalanceDecimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    NSDictionary *param = @{
        @"address":[walletAddress formatDelCVN],
    };
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/fbs/act/pbgac.do",kCVNRPCUrl) withParameter:param withBlock:^(id data, NSError *error) {
        if (!error) {
            NSString *amount = [UITools bigStringWith16String:data[@"balance"]];
            amount = [amount stringDownDividingBy10Power:decimals];
            completion(amount);
        } else {
            completion(nil);
        }
    }];
}
+ (void)loadCVNTokenBalance:(NSString *)tokenAddress decimals:(NSInteger)decimals completion:(void (^)(NSString *amount))completion {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    NSDictionary *param = @{
        @"to":tokenAddress,
        @"data":NSStringWithFormat(@"0x70a08231000000000000000000000000%@",[walletAddress formatDelCVN])
    };
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/fbs/cvm/pbcal.do",kCVNRPCUrl) withParameter:param withBlock:^(id data, NSError *error) {
        if (!error) {
            NSString *value = data[@"result"];
            if (!value) {
                completion(@"0");
            }else{
                NSString *amount = [UITools bigStringWith16String:value];
                amount = [amount stringDownDividingBy10Power:decimals];
                completion(amount);
            }
        } else {
            completion(nil);
        }
    }];
}

@end
