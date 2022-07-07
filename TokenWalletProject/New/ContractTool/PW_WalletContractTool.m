//
//  PW_WalletContractTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletContractTool.h"

static NSString * _Nonnull JsonRpcId = @"1";

@implementation PW_WalletContractTool

+ (void)baseMethod:(NSString *)method params:(NSArray *)params completionHandler:(void (^)(NSString * _Nullable result, NSString * _Nullable errorDesc))completionHandler {
    NSDictionary *paramsDict = @{
        @"id":JsonRpcId,
        @"jsonrpc":@"2.0",
        @"method":method,
        @"params":params,
    };
    NSString *urlStr = User_manager.currentUser.current_Node;
    [AFNetworkClient requestPostWithUrl:urlStr withParameter:paramsDict withBlock:^(id data, NSError *error) {
        if(error==nil){
            NSString *result = data[@"result"];
            if (completionHandler) {
                completionHandler(result,nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(nil,error.localizedDescription);
            }
        }
    }];
}
+ (void)estimateGasToAddress:(NSString *)address completionHandler:(void (^)(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc))completionHandler {
    NSDictionary *paramsDict = @{
        @"id":JsonRpcId,
        @"jsonrpc":@"2.0",
        @"method":@"eth_gasPrice",
        @"params":@[],
    };
    NSDictionary *estimateParamsDict = @{
        @"id":JsonRpcId,
        @"jsonrpc":@"2.0",
        @"method":@"eth_estimateGas",
        @"params":@[@{
            @"to":address ? address : @"0x0000000000000000000000000000000000000000",
        }],
    };
    NSString *urlStr = User_manager.currentUser.current_Node;
    [AFNetworkClient requestPostWithUrl:urlStr withParameter:paramsDict withBlock:^(id data, NSError *error) {
        if(error==nil){
            NSString *gasPrice = data[@"result"];
            [AFNetworkClient requestPostWithUrl:urlStr withParameter:estimateParamsDict withBlock:^(id data, NSError *error) {
                if(error==nil){
                    NSString *gas = data[@"result"];
                    if (completionHandler) {
                        completionHandler([gasPrice strTo10],[gas strTo10],error.localizedDescription);
                    }
                }else{
                    if (completionHandler) {
                        completionHandler(nil,nil,error.localizedDescription);
                    }
                }
            }];
        }else{
            if (completionHandler) {
                completionHandler(nil,nil,error.localizedDescription);
            }
        }
    }];
}
+ (void)estimateGasTokenToAddress:(NSString *)address token:(NSString *)token completionHandler:(void (^)(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc))completionHandler {
    [self estimateGasToAddress:address completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
        if (completionHandler) {
            NSString *newGas = nil;
            if ([gas isNoEmpty]) {
                newGas = [gas stringDownMultiplyingBy:@"3"];
            }
            completionHandler(gasPrice,newGas,errorDesc);
        }
    }];
}
+ (void)getBalanceDecimals:(NSUInteger)decimals completionHandler:(void (^)(NSString * _Nullable balance, NSString * _Nullable errorDesc))completionHandler {
    NSString *walletAddress = User_manager.currentUser.chooseWallet_address;
    [self baseMethod:@"eth_getBalance" params:@[walletAddress,@"latest"] completionHandler:^(NSString * _Nullable result, NSString * _Nullable errorDesc) {
        if(errorDesc==nil){
            NSString *amount = [UITools bigStringWith16String:result];
            amount = [amount stringDownDividingBy10Power:decimals>0?decimals:18];
            if (completionHandler) {
                completionHandler(amount,nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(nil,errorDesc);
            }
        }
    }];
}
+ (void)balanceOfAddress:(NSString *)address contractAddress:(NSString *)contractAddress completionHandler:(void (^)(NSString * _Nullable balance, NSString * _Nullable errorDesc))completionHandler {
    if (![address isNoEmpty]||![contractAddress isNoEmpty]) {
        if (completionHandler) {
            completionHandler(nil,@"error");
        }
        return;
    }
    NSDictionary *paramsDict = @{
        @"data":PW_StrFormat(@"0x70a08231000000000000000000000000%@",[address removeOxPrefix]),
        @"to":contractAddress,
    };
    [self baseMethod:@"eth_call" params:@[paramsDict,@"latest"] completionHandler:^(NSString * _Nullable result, NSString * _Nullable errorDesc) {
        if(errorDesc==nil){
            if (completionHandler) {
                completionHandler([PW_BigIntTool to10WithHex:result],nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(nil,errorDesc);
            }
        }
    }];
}
+ (void)symbolContractAddress:(NSString *)contractAddress completionHandler:(void (^)(NSString * _Nullable balance, NSString * _Nullable errorDesc))completionHandler {
    if (![contractAddress isNoEmpty]) {
        if (completionHandler) {
            completionHandler(nil,@"error");
        }
        return;
    }
    NSDictionary *paramsDict = @{
        @"data":@"0x95d89b41",
        @"to":contractAddress,
    };
    [self baseMethod:@"eth_call" params:@[paramsDict,@"latest"] completionHandler:^(NSString * _Nullable result, NSString * _Nullable errorDesc) {
        if(errorDesc==nil){
            if (completionHandler) {
                NSInteger start = 0;
                NSInteger len = 64;
                if (result.length>len) {
                    start = result.length-len;
                }else{
                    len = result.length;
                }
                completionHandler([[result substringWithRange:NSMakeRange(start, len)] get16ToStr],nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(nil,errorDesc);
            }
        }
    }];
}
+ (void)decimalsContractAddress:(NSString *)contractAddress completionHandler:(void (^)(NSInteger decimals, NSString * _Nullable errorDesc))completionHandler {
    if (![contractAddress isNoEmpty]) {
        if (completionHandler) {
            completionHandler(0,@"error");
        }
        return;
    }
    NSDictionary *paramsDict = @{
        @"data":@"0x313ce567",
        @"to":contractAddress,
    };
    [self baseMethod:@"eth_call" params:@[paramsDict,@"latest"] completionHandler:^(NSString * _Nullable result, NSString * _Nullable errorDesc) {
        if(errorDesc==nil){
            if (completionHandler) {
                completionHandler([[PW_BigIntTool to10WithHex:result] integerValue],nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(0,errorDesc);
            }
        }
    }];
}

@end
