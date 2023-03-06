//
//  MOSWeb3NetManager.m
//  MOS_Client_IOS
//
//  Created by mnz on 2020/11/26.
//  Copyright © 2020 WangQJ. All rights reserved.
//

#import "MOSWeb3NetManager.h"

static NSString * _Nonnull ETHGasAPI = @"https://ethgasstation.info/json/ethgasAPI.json";
//static NSString * _Nonnull RPCUrl = @"https://mainnet.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161";

@interface MOSWeb3NetManager ()

@property (nonatomic, strong) NSMutableDictionary *retryCountDict;

@end

@implementation MOSWeb3NetManager

- (NSMutableDictionary *)retryCountDict {
    if(!_retryCountDict){
        _retryCountDict = [[NSMutableDictionary alloc] init];
    }
    return _retryCountDict;
}

+ (instancetype)shared{
    static MOSWeb3NetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MOSWeb3NetManager alloc] init];
    });
    return manager;
}

//const url = new Web3.providers.HttpProvider(
//'https://rinkeby.infura.io/v3/cadc6b0dc5c54720b973b3720eab5584'
//);
//web3 = new Web3(url);
+ (void)requestWithModel:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(NSString * _Nullable rawResponse, id _Nullable result, NSError * _Nullable error))completionHandler {
    id params = (model.params ? : @[]).mj_JSONObject;
    NSDictionary *dict = @{@"id":model.id?:@"",@"jsonrpc":model.jsonrpc?:@"",@"method":model.method?:@"",@"params":(params?:@"")};
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:dict withBlock:^(id data, NSError *error) {
        NSLog(@"===params:%@",dict);
        NSLog(@"===result:%@",data);
        NSDictionary *dataDict = data;
        if (!error) {
            if(data[@"result"]&&![data[@"result"] isEqual:[NSNull null]]){
                if (completionHandler) {
                    completionHandler(dataDict.mj_JSONString, data[@"result"], nil);
                }
            }else{
                NSString *hash = nil;
                if(model.params&&model.params.count>0){
                    hash = model.params[0];
                }
                if(hash&&[hash isKindOfClass:[NSString class]]){
                    NSNumber *count = [MOSWeb3NetManager shared].retryCountDict[hash];
                    if(count!=nil&&count.integerValue>10){
                        [[MOSWeb3NetManager shared].retryCountDict removeObjectForKey:hash];
                        if (completionHandler) {
                            completionHandler(dataDict.mj_JSONString,nil, [NSError errorWithDomain:@"no result" code:-1 userInfo:nil]);
                        }
                    }else{
                        [MOSWeb3NetManager shared].retryCountDict[hash] = @(count.integerValue+1);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self requestWithModel:model completionHandler:completionHandler];
                        });
                    }
                }else{
                    if (completionHandler) {
                        completionHandler(dataDict.mj_JSONString,nil, [NSError errorWithDomain:@"no result" code:-1 userInfo:nil]);
                    }
                }
            }
        }else{
            if (completionHandler) {
                completionHandler(dataDict.mj_JSONString,nil, error);
            }
        }
    }];
}

@end
