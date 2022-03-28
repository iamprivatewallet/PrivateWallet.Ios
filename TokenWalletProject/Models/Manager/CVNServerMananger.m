//
//  CWVServerMananger.m
//  GCSWalletProject
//
//  Created by jackygood on 2018/12/24.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "CVNServerMananger.h"
#import "brewchain.h"

//https://dev.wallet.icwv.co
//https://api.wallet.icwv.co
static NSString * const  DAPPID = @"CWV";

@implementation CVNServerMananger

+(instancetype)sharedInstance
{
    static CVNServerMananger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString *)urlWithName:(NSString *)name
{
    NSArray *nodeUrls = [[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_NODES_LIST];
    NSInteger index = [[NSUserDefaults standardUserDefaults]integerForKey:USERDEFAULT_CURRENT_POINT];
    NSDictionary *dic = nodeUrls[index];
    NSString *serverUrl = [[SettingManager sharedInstance] getNodeWithChainId:kCVNChainId];
    return [NSString stringWithFormat:@"%@/%@", dic[@"node_url"]?dic[@"node_url"]:serverUrl,name];
}

-(NSString *)nodeUrl
{
    return [[SettingManager sharedInstance] getNodeWithChainId:kCVNChainId];
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


//搜索，不为3则失败

-(void)search:(NSString *)address resultBlock:(void(^)(id rdata, NSError *rerror))block
{
    NSString *url = [self urlWithName:@"browser/bca/pbser.do"];
    NSDictionary *dic = @{@"search_content":address};
    
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        if (!rerror) {
            block(rdata, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

//查询地址余额
-(void)fetchBalance:(NSString *)address contractAddr:(NSString *)conaAddr resultBlock:(void(^)(ETHBalance * __nullable data, NSError * __nullable error))block
{
//    fbs/act/pbgac.do

    NSString *url = [self urlWithName:@"fbs/act/pbgac.do"];
    url =  [url stringByReplacingOccurrencesOfString:@" " withString:@""];;

    NSDictionary *dic = @{@"address":address?[address formatDelEth]:@""};
    NSLog(@"请求参数：---------->%@",dic);
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        NSLog(@"rdata::%@",rdata);
        if (!rerror) {
            ETHBalance *model = [[ETHBalance alloc] initWithDictionary:rdata error:nil];
//            model.balanceNum =  [CWVChainUtils numberOperate:model.balance];
            if (model.balance) {
                JKBigInteger *bigNum = [[JKBigInteger alloc]initWithString:[model.balance formatDelEth] andRadix:16];
                NSString *ten = [bigNum stringValueWithRadix:10];
                JKBigInteger *bigNum1 = [[JKBigInteger alloc]initWithString:ten];
                NSString *sttr = [bigNum1 stringValue];
                if (sttr.length>18) {
                    NSString *str1 = [sttr substringToIndex:sttr.length-18];
                    NSString *str2 = [sttr substringFromIndex:sttr.length-18];
                    
                    sttr =[NSString stringWithFormat:@"%@.%@",str1,str2];
                }
                JKBigDecimal *bigd = [[JKBigDecimal alloc]initWithString: sttr];
                JKBigDecimal *bigNum2 = [bigd divide:[[JKBigDecimal alloc]initWithString:@"1000000000000000000"]];
                NSString *str2 = [bigNum2 stringValue];
                model.showBalance = [NSString stringWithFormat:@"%.8f",[sttr doubleValue]];
            }else{
                model.showBalance = @"0.00";
            }
//            model.showBalance = [NSString stringWithFormat:@"%.2f",[model.balanceNum doubleValue]/100.0] ;
            block(model, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}


-(void)transfer:(NSString *)tx resultBlock:(void(^)(id  __nullable data, NSError * __nullable error))block{
    NSString *url = [self urlWithName:@"fbs/tct/pbmtx.do"];
     
    NSDictionary *dic = @{@"tx":tx?tx:@""};
    NSLog(@"请求参数：---------->%@",dic);
    [AFNetworkClient requestPostWithUrl:url withParameter:dic withBlock:^(id rdata, NSError *rerror) {
        NSLog(@"rdata::%@",rdata);
        if (!rerror) {
            block(rdata, rerror);
        } else {
            block(nil, rerror);
        }
    }];
}

- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
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
    NSLog(@"url::%@",url);
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
        NSLog(@"主币转账 rdata::%@",rdata);
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
        NSLog(@"冷钱包代币转账 rdata::%@",rdata);
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
