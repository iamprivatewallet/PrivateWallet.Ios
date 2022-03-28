//
//  NetworkTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/17.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (void)requestWallet:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock {
    [AFNetworkClient requestPostWithUrl:NSStringWithFormat(@"%@/%@",APPWalletBaseURL,path) withParameter:params?:@{} withBlock:^(id data, NSError *error) {
        if(error==nil){
            if([data[@"code"] integerValue] == 1){
                if(completeBlock) {
                    completeBlock(data[@"data"]);
                }
            }else{
                if(errBlock) {
                    errBlock(data[@"msg"]);
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
