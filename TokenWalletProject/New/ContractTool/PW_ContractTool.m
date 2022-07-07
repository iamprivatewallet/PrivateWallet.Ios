//
//  PW_ContractTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ContractTool.h"
#import "PW_WalletContractTool.h"

@implementation PW_ContractTool

+ (void)loadETHBalance:(PW_TokenModel *)model completion:(void (^)(NSString *amount))completion {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    if ([[model.tokenContract lowercaseString] isEqualToString:[walletAddress lowercaseString]]) {
        [PW_WalletContractTool getBalanceDecimals:model.tokenDecimals completionHandler:^(NSString * _Nullable balance, NSString * _Nullable errorDesc) {
            if(balance!=nil) {
                completion(balance);
            }
        }];
    }else{
        [PW_WalletContractTool balanceOfAddress:walletAddress contractAddress:model.tokenContract completionHandler:^(NSString * _Nonnull amount, NSString * _Nullable errMsg) {
            if(model.tokenDecimals>0){
                NSString *newAmount = [amount stringDownDividingBy10Power:model.tokenDecimals];
                completion(newAmount);
            }else{
                [PW_WalletContractTool decimalsContractAddress:model.tokenContract completionHandler:^(NSInteger decimals, NSString * _Nullable errMsg) {
                    if(errMsg==nil){
                        model.tokenDecimals = decimals;
                        NSString *newAmount = [amount stringDownDividingBy10Power:decimals];
                        completion(newAmount);
                    }
                }];
            }
        }];
    }
}

+ (void)loadCVNBalance:(PW_TokenModel *)model completion:(void (^)(NSString *amount))completion {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    if ([[model.tokenContract lowercaseString] isEqualToString:[walletAddress lowercaseString]]) {//主币
        [PW_ContractTool loadCVNMainBalanceDecimals:model.tokenDecimals completion:^(NSString * _Nonnull amount) {
            if(completion&&amount!=nil) {
                completion(amount);
            }
        }];
    }else{
        [PW_ContractTool loadCVNTokenBalance:model.tokenContract decimals:model.tokenDecimals completion:^(NSString * _Nonnull amount) {
            if(completion&&amount!=nil) {
                completion(amount);
            }
        }];
    }
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
