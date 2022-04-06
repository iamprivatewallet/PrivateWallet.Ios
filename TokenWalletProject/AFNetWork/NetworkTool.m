//
//  NetworkTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/17.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (void)requestApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/%@",APPWalletBaseURL,path) withParameter:params?:@{} withBlock:^(id data, NSError *error) {
        if(error==nil){
            NSInteger code = [data[@"code"] integerValue];
            if(code==1){
                if(completeBlock) {
                    completeBlock(data[@"data"]);
                }
            }else{
                NSString *msg = data[@"msg"];
                if([msg isEmptyStr]) {
                    msg = data[@"message"];
                }
                if(errBlock) {
                    errBlock(msg);
                }
            }
        }else{
            if(errBlock) {
                errBlock(error.localizedDescription);
            }
        }
    }];
}
+ (void)requestWallet:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/%@",APPWalletBaseURL,path) withParameter:params?:@{} withBlock:^(id data, NSError *error) {
        if(error==nil){
            NSInteger code = [data[@"code"] integerValue];
            NSString *msg = data[@"message"];
            if(code==200){
                id dataDict = data[@"data"];
                if(completeBlock) {
                    completeBlock(dataDict[@"result"]);
                }
            }else{
                if(errBlock) {
                    errBlock(msg);
                }
            }
        }else{
            if(errBlock) {
                errBlock(error.localizedDescription);
            }
        }
    }];
}

@end
