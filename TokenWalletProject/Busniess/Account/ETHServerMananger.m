//
//  ETHServerMananger.m
//  TokenWalletProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "ETHServerMananger.h"
//https://dev.wallet.icwv.co
//https://api.wallet.icwv.co
static NSString * const  ETHServer = @"https://dev.wallet.icwv.co/eth";
static NSString * const  DAPPID = @"CWV";

@implementation ETHServerMananger

+(instancetype)sharedInstance
{
    static ETHServerMananger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString *)urlWithName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@/%@", ETHServer, name];
}

-(NSString *)nodeUrl
{
    return [[SettingManager sharedInstance] getNodeWithChainId:kETHChainId];
}
//查询更新
-(void)VersionUpdateResultBlock:(void(^)(id data, NSError * __nullable error))block{
    [AFNetworkClient requestGetWithUrl:@"http://cwv-wallet.oss-cn-hongkong.aliyuncs.com/cwv_wallet_h5/cwv_ios_version.json" withParameter:nil withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            block(rdata, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询地址Nonce
-(void)fetchAddressNonce:(NSString *)address resultBlock:(void(^)(ETHNoce * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqne.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         address?:@"",@"address",
                         nil];
    
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHNoce *model = [[ETHNoce alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询地址余额
-(void)fetchBalance:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHBalance * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqbe.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         address?:@"",@"address",
                        conaAddr?:@"",@"contract_addr",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            NSLog(@"data::%@",rdata);
            ETHBalance *model = [[ETHBalance alloc] initWithDictionary:rdata error:nil];
            
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询地址所有不为0余额
-(void)fetchBalanceNoZero:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHBalanceList * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqab.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         address?:@"",@"address",
                         conaAddr?:@"",@"contract_addr",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHBalanceList *model = [[ETHBalanceList alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询节点当前GAS
-(void)fetchNodeGas:(void(^)(ETHNodeGas * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqgs.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHNodeGas *model = [[ETHNodeGas alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询转账
-(void)fetchTransfer:(NSString *)txid resultBlock:(void(^)(ETHTransfer * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqtx.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         txid?:@"",@"tx_id",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTransfer *model = [[ETHTransfer alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询历史转账列表,parameter:contract_addr,from_addr,to_addr,tx_type,tx_status,start_timeend_time,
-(void)fetchTransferList:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferList * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqta.do"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setObject:DAPPID forKey:@"dapp_id"];
    [dic setObject:[self nodeUrl] forKey:@"node_url"];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTransferList *model = [[ETHTransferList alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询代币信息
-(void)fetchTockenCoinInfo:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHTokenCoinList * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqti.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         address?:@"",@"address",
                         conaAddr?:@"",@"contract_addr",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTokenCoinList *model = [[ETHTokenCoinList alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询节点信息
-(void)fetchNodeInfo:(NSString *)nodeNet resultBlock:(void(^)(ETHNodeList * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbqnl.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         nodeNet?:@"",@"node_net",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHNodeList *model = [[ETHNodeList alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//冷钱包主币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type
-(void)fetchColdMainCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbtxe.do"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setObject:DAPPID forKey:@"dapp_id"];
    [dic setObject:[self nodeUrl] forKey:@"node_url"];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTransferResult *model = [[ETHTransferResult alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//冷钱包代币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type,symbol,contract_addr
-(void)fetchColdTokenCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbtxt.do"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setObject:DAPPID forKey:@"dapp_id"];
    [dic setObject:[self nodeUrl] forKey:@"node_url"];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTransferResult *model = [[ETHTransferResult alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//热钱包主币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type
-(void)fetchHotMainCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbhtx.do"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setObject:DAPPID forKey:@"dapp_id"];
    [dic setObject:[self nodeUrl] forKey:@"node_url"];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTransferResult *model = [[ETHTransferResult alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//热钱包代币转账接口, parameter: nonce,from_addr,to_addr,value,signed_message,gas_price,gas_limit,tx_type,symbol,contract_addr
-(void)fetchHotTokenCoinTransfer:(NSDictionary *)parameter resultBlock:(void(^)(ETHTransferResult * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbhtt.do"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setObject:DAPPID forKey:@"dapp_id"];
    [dic setObject:[self nodeUrl] forKey:@"node_url"];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHTransferResult *model = [[ETHTransferResult alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//  热钱包创建账户
-(void)createHotAccount:(NSString *)password resultBlock:(void(^)(ETHCreateAccountResult * __nullable data, NSError * __nullable error))block
{
    NSString *url = [self urlWithName:@"pbhna.do"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         DAPPID,@"dapp_id",
                         [self nodeUrl],@"node_url",
                         password?:@"",@"password",
                         nil];
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            ETHCreateAccountResult *model = [[ETHCreateAccountResult alloc] initWithDictionary:rdata error:nil];
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

    
@end
