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

@implementation MOSWeb3NetManager

//const url = new Web3.providers.HttpProvider(
//'https://rinkeby.infura.io/v3/cadc6b0dc5c54720b973b3720eab5584'
//);
//web3 = new Web3(url);
+ (void)requestWithModel:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(NSString * _Nullable rawResponse, id _Nullable result, NSError * _Nullable error))completionHandler {
    id params = (model.params ? : @[]).mj_JSONObject;
    NSDictionary *dict = @{@"id":model.id?:@"",@"jsonrpc":model.jsonrpc?:@"",@"method":model.method?:@"",@"params":(params?:@"")};
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:dict withBlock:^(id data, NSError *error) {
        NSDictionary *dataDict = data;
        if (!error) {
            if (completionHandler) {
                completionHandler(dataDict.mj_JSONString, data[@"result"], nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(dataDict.mj_JSONString,nil, error);
            }
        }
    }];
}
//请求gas
+ (void)requestETHgasCompletionHandler:(void (^ _Nullable)(MOSETHGasModel * _Nullable gasModel, NSError * _Nullable error))completionHandler {
    [AFNetworkClient requestPostWithUrl:ETHGasAPI withParameter:nil withBlock:^(id data, NSError *error) {
        if (!error) {
            MOSETHGasModel *model = [MOSETHGasModel mj_objectWithKeyValues:data];
            if (completionHandler) {
                completionHandler(model, nil);
            }
        }else{
            if (completionHandler) {
                completionHandler(nil, error);
            }
        }
    }];
}

@end
