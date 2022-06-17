//
//  DSCallApi.m
//  DSWebViewDemo
//
//  Created by 张强 on 2020/10/11.
//

#import "MetaMaskCallApi.h"
#import <Web3WebView/MetaMaskRespModel.h>
#import <Web3WebView/MetaMaskRepModel.h>
#import "MOSWeb3NetManager.h"

@implementation MetaMaskCallApi

- (NSString *)getCurrentAddress {
    return User_manager.currentUser.chooseWallet_address;
}
/**
 * 统一回调方法 回调方法有js带的参数
 * @param model.method 通过此字段来区别js调用的方法
 * @param model js带过来的参数
 * @param completionHandler  需构造 MetaMaskRespModel 类对象回调给此方法
 */
- (void)rpcHandler:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    NSLog(@"rpc===%@-%@",model.method,model.params);
    if ([model.method isEqualToString:@"eth_accounts"]||[model.method isEqualToString:@"eth_requestAccounts"]) {
        [self ethAccounts:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_coinbase"]){
        [self ethCoinbase:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"net_version"]||[model.method isEqualToString:@"eth_chainId"]){
        [self netVersion:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"web3_clientVersion"]){
        [self web3ClientVersion:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_sign"]){
        [self ethSign:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"personal_sign"]){
        [self personalSign:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_signTypedData"]){
        [self ethSignTypeData:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_signTypedData_v3"]){
        [self ethSignTypeDataV3:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_signTypedData_v4"]){
        [self ethSignTypeDataV4:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_getBalance"]){
        [self ethGetBalance:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_blockNumber"]){
        [self ethBlockNumber:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_call"]){
        [self ethCall:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"eth_getTransactionReceipt"]){//根据hash查询交易信息
//        MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
//        respModel.id = model.id;
//        respModel.jsonrpc = model.jsonrpc;
//        respModel.rawResponse = @"";
//        respModel.result = @"";
//        if (completionHandler) {
//            completionHandler(respModel);
//        }
        [self requestWithModel:model completionHandler:completionHandler];
    }else if([model.method isEqualToString:@"wallet_addEthereumChain"]) {//切换链
        MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
        respModel.id = model.id;
        respModel.jsonrpc = model.jsonrpc;
        respModel.rawResponse = @"";
        respModel.result = @"";
        if (completionHandler) {
            completionHandler(respModel);
        }
    }else if([model.method isEqualToString:@"eth_sendTransaction"]){//发送交易
        void(^errorBlock)(NSString *) = ^(NSString *errorDesc){
            MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
            respModel.id = model.id;
            respModel.jsonrpc = model.jsonrpc;
            respModel.rawResponse = @"";
            respModel.result = nil;
            if (errorDesc!=nil&&errorDesc.length>0) {
                DSError *error = [[DSError alloc] init];
                error.message = errorDesc;
                error.code = -1;
                respModel.error = error;
            }
            if (completionHandler) {
                completionHandler(respModel);
            }
        };
        NSDictionary *dataDict = model.params.firstObject;
        if (dataDict==nil||[dataDict isKindOfClass:[NSDictionary class]]==NO) {
            if (errorBlock) {
                errorBlock(@"parameter error!");
            }
            return;
        }
        NSMutableDictionary *dataDictNew = [NSMutableDictionary dictionaryWithDictionary:dataDict];
        NSString *data = dataDict[@"data"];
        NSString *to = dataDict[@"to"];
        NSString *gasPrice = dataDict[@"gasPrice"];
        NSString *gas = dataDict[@"gas"];
        NSString *from = dataDict[@"from"];
        PW_DappPayModel *payModel = [[PW_DappPayModel alloc] init];
        payModel.value = @"0";
        payModel.symbol = [PW_GlobalData shared].mainTokenModel.tokenSymbol;
        payModel.paymentAddress = from;
        payModel.acceptAddress = to;
        payModel.gasToolModel.gas_price = [gasPrice strTo10];
        payModel.gasToolModel.gas = [gas strTo10];
        payModel.gasToolModel.price = [PW_GlobalData shared].mainTokenModel.price;
        if([data.lowercaseString hasPrefix:AuthorizationPrefix]){
            NSString *authCount = @"0";
            NSInteger authCountLength = 64;
            if (data.length>authCountLength) {
                authCount = [data substringFromIndex:data.length-authCountLength];
            }
            payModel.value = authCount;
            [SVProgressHUD showWithStatus:nil];
            [[PWWalletContractTool shared] symbolERC20WithContractAddress:to completionHandler:^(NSString * _Nullable symbol, NSString * _Nullable errorDesc) {
                [SVProgressHUD dismiss];
                payModel.symbol = symbol;
                [PW_DappAlertTool showDappAuthorizationConfirm:payModel sureBlock:^(PW_DappPayModel * _Nonnull payModel) {
//                    if (![payModel.value isEqualToString:authCount]) {
//                        NSMutableString *value = [NSMutableString stringWithString:[payModel.value strTo16]];
//                        if (value.length<authCountLength) {
//                            NSInteger count = authCountLength-value.length;
//                            for (int i=0; i<count; i++) {
//                                [value insertString:@"0" atIndex:0];
//                            }
//                        }
//                        dataDictNew[@"data"] = PW_StrFormat(@"%@%@",[data substringToIndex:data.length-authCountLength],value);
//                    }
                    dataDictNew[@"gasPrice"] = [[payModel.gasModel.gas_price strTo16] addOxPrefix];
                    dataDictNew[@"gas"] = [[payModel.gasModel.gas strTo16] addOxPrefix];
                    [PW_TipTool showPayPwdSureBlock:^(NSString * _Nonnull pwd) {
                        if (![pwd isEqualToString:User_manager.currentUser.user_pass]) {
                            if (errorBlock) {
                                errorBlock(LocalizedStr(@"text_pwdError"));
                            }
                            return;
                        }
                        [self callTransaction:model dataDictNew:dataDictNew completionHandler:completionHandler errorBlock:errorBlock];
                    } closeBlock:^{
                        if (errorBlock) {
                            errorBlock(@"cancel");
                        }
                    }];
                } closeBlock:^{
                    if (errorBlock) {
                        errorBlock(@"cancel");
                    }
                }];
            }];
        }else{
            [PW_DappAlertTool showDappConfirmPayInfo:payModel sureBlock:^(PW_DappPayModel * _Nonnull payModel) {
                dataDictNew[@"gasPrice"] = [[payModel.gasModel.gas_price strTo16]addOxPrefix];
                dataDictNew[@"gas"] = [[payModel.gasModel.gas strTo16]addOxPrefix];
                [PW_TipTool showPayPwdSureBlock:^(NSString * _Nonnull pwd) {
                    if (![pwd isEqualToString:User_manager.currentUser.user_pass]) {
                        if (errorBlock) {
                            errorBlock(LocalizedStr(@"text_pwdError"));
                        }
                        return;
                    }
                    [self callTransaction:model dataDictNew:dataDictNew completionHandler:completionHandler errorBlock:errorBlock];
                } closeBlock:^{
                    if (errorBlock) {
                        errorBlock(@"cancel");
                    }
                }];
            } closeBlock:^{
                if (errorBlock) {
                    errorBlock(@"cancel");
                }
            }];
        }
    }else{
        //TODO 其他更多Method 统一直接使用web3的rpc协议进行请求，参数都无需做修改
        NSLog(@"method:%@ 暂不支持",model.method);
        [self requestWithModel:model completionHandler:completionHandler];
    }
}
- (void)callTransaction:(MetaMaskRepModel *)model dataDictNew:(NSMutableDictionary *)dataDictNew completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler errorBlock:(void(^)(NSString *errorDesc))errorBlock {
    if(dataDictNew[@"value"]==nil){
        dataDictNew[@"value"] = dataDictNew[@"data"];
    }
    MetaMaskRepModel *tempModel = [[MetaMaskRepModel alloc] init];
    tempModel.id = model.id;
    tempModel.jsonrpc = model.jsonrpc;
    tempModel.method = @"eth_getTransactionCount";
    //pending latest
    [SVProgressHUD showWithStatus:nil];
    tempModel.params = [NSMutableArray arrayWithArray:@[[self getCurrentAddress],@"latest"]];
    [self requestWithModel:tempModel completionHandler:^(MetaMaskRespModel * _Nullable value) {
        [SVProgressHUD dismiss];
        if (value.result==nil) {
            if (completionHandler) {
                completionHandler(value);
            }
            return;
        }
        dataDictNew[@"nonce"] = value.result;
        [SVProgressHUD showWithStatus:nil];
        [self sendTransactionDict:dataDictNew completionHandler:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
            [SVProgressHUD dismiss];
            if (hash==nil) {
                if (errorBlock) {
                    errorBlock(errorDesc);
                }
                return;
            }
            MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
            respModel.id = model.id;
            respModel.jsonrpc = model.jsonrpc;
            respModel.rawResponse = @"";
            respModel.result = @[hash];
            if (completionHandler) {
                completionHandler(respModel);
            }
        }];
    }];
}
// 获取ETH 签名
- (void)sendTransactionDict:(NSDictionary *)dataDictNew completionHandler:(void (^ _Nullable)(NSString * _Nullable hash, NSString * _Nullable errorDesc))block {
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    NSDictionary *dic = @{
        @"nonce":dataDictNew[@"nonce"],
        @"to_addr":dataDictNew[@"to"],
        @"value":@"0x0",
        @"data":dataDictNew[@"data"],
        @"gas_price":dataDictNew[@"gasPrice"],
        @"gas":dataDictNew[@"gas"],
        @"prikey":wallet.priKey
    };
    [FchainTool genETHTransactionSign:dic isToken:NO block:^(NSString * _Nonnull result) {
        NSString *sign = NSStringWithFormat(@"0x%@",result);
        [self ETHTransferWithSign:sign completionHandler:block];
    }];
}
//ETH 转账
-(void)ETHTransferWithSign:(NSString *)sign completionHandler:(void (^ _Nullable)(NSString * _Nullable hash, NSString * _Nullable errorDesc))block {
    NSDictionary *parmDic = @{
                @"id":@"67",
                @"jsonrpc":@"2.0",
                @"method":@"eth_sendRawTransaction",
                @"params":@[sign]
                };
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        if (data) {
            if (data[@"error"]) {
                if(block){
                    block(nil,data[@"error"][@"message"]);
                }
            }else{
                if (block) {
                    block(data[@"result"],nil);
                }
            }
        }else{
            if(block){
                block(nil,error.localizedDescription);
            }
        }
    }];
}
- (void)requestWithModel:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler {
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    [MOSWeb3NetManager requestWithModel:model completionHandler:^(NSString * _Nullable rawResponse, id _Nullable result, NSError * _Nullable error) {
        respModel.rawResponse = rawResponse;
        respModel.result = result;
        if (error!=nil) {
            DSError *respError = [[DSError alloc] init];
            respError.message = error.domain;
            respError.code = error.code;
            respModel.error = respError;
        }
        if (completionHandler) {
            completionHandler(respModel);
        }
    }];
}
//签名
- (void)signDataWithMessage:(NSString *)message address:(NSString *)address respModel:(MetaMaskRespModel *)respModel completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler {
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    [FchainTool genSign:wallet.priKey content:message type:Ethereum block:^(NSString * _Nonnull result) {
        NSString *sign = NSStringWithFormat(@"0x%@",result);
        [self ETHTransferWithSign:sign completionHandler:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
            if (errorDesc!=nil&&errorDesc.length>0) {
                DSError *error = [[DSError alloc] init];
                error.message = errorDesc;
                error.code = -1;
                respModel.error = error;
            }
            if (hash!=nil) {
                respModel.result = @[hash];
            }
            if (completionHandler) {
                completionHandler(respModel);
            }
        }];
    }];
}
- (void)signDataWithDict:(NSDictionary *)dict address:(NSString *)address respModel:(MetaMaskRespModel *)respModel completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler {
    Wallet *wallet = [[SettingManager sharedInstance] getCurrentWallet];
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        data = [NSData new];
    }
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [FchainTool genSign:wallet.priKey content:message type:Ethereum block:^(NSString * _Nonnull result) {
        NSString *sign = NSStringWithFormat(@"0x%@",result);
        [self ETHTransferWithSign:sign completionHandler:^(NSString * _Nullable hash, NSString * _Nullable errorDesc) {
            if (errorDesc!=nil&&errorDesc.length>0) {
                DSError *error = [[DSError alloc] init];
                error.message = errorDesc;
                error.code = -1;
                respModel.error = error;
            }
            if (hash!=nil) {
                respModel.result = @[hash];
            }
            if (completionHandler) {
                completionHandler(respModel);
            }
        }];
    }];
}
/**
 * 方法示例  第一个方法注释 适用于下面所有方法
 */
/**
 * RpcReq类
 * id:long:请求ID与resp的ID一一对应
 * jsonrpc:string:请求协议 默认值无需处理
 * method:string:请求方法 根据此参数做处理
 * params:array(*):请求参数 一般为字符串数组 也有个别方法中会出现对象和字符串并存的情况 如果出现对象 则一定为NSDictionary
 * toNative:boolean:内部使用 无需理会
 *
 *
 *
 * RpcResp类
 * id:long:放置request中的id字段
 * jsonrpc:string:放置request中的jsonrpc字段
 * result:*:操作成功时的结果
 * error:RpcError:操作失败时的错误信息 参考eth的RPC协议（无错误时可以放置null）
 * rawResponse:string:原始response  具体请参考eth的RPC协议 可以传入空字符串
 *
 * RpcError
 * code:int:错误码 请不要赋值为 0 200 等常用正常状态码
 * message:string:错误信息(必填)
 * data:string:错误详情
 */

/**
 * 请求登录账号
 * 选择账号数组中只一个账号即可/没有则不放账号
 */
- (void)ethAccounts:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 如用户有多个钱包地址可以进行选择，或者拒绝登录
     * 如当前无账号 result中放置空数组
     * 拒绝登录为一种错误，请error传入错误信息
     * 获取当前地址 数组中仅放置一个地址
     */

    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;//此参数js带过来的 直接赋值
    respModel.jsonrpc = model.jsonrpc;//此参数js带过来的 直接赋值
    respModel.rawResponse = @"";
    respModel.result =@[[self getCurrentAddress]];
    respModel.error = nil;

    /**
     * 通过此方式回调给统一方法
     */
    if (completionHandler) {
        completionHandler(respModel);
    }
}
/**
 * 请求登录账号
 */
- (void)ethCoinbase:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 如用户有多个钱包地址可以进行选择，或者拒绝登录
     * 如当前无账号 result放置null
     * 拒绝登录为一种错误，请error传入错误信息
     */
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;//此参数js带过来的 直接赋值
    respModel.jsonrpc = model.jsonrpc;//此参数js带过来的 直接赋值
    respModel.rawResponse = @"";
    respModel.result = @[[self getCurrentAddress]];
    respModel.error = nil;
    if (completionHandler) {
        completionHandler(respModel);
    }
}
/**
 * 获取chainId
 */
- (void)netVersion:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 获取当前地址所处的网络  主网是0x1
     * 如果不支持其他网络，则可以直接使用Demo中的示例
     */
    [self requestWithModel:model completionHandler:completionHandler];
}

/**
 * 获取客户端信息及版本号===>`MetaMask/${app_version}/Beta/Mobile`
 */
- (void)web3ClientVersion:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 获取客户端信息及版本号
     */
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    respModel.rawResponse = @"";
    NSString *version = @"";
    NSString *result = [NSString stringWithFormat:@"MetaMask/%@/Beta/Mobile",version];
    respModel.result = @[result];
//    respModel.result = @[@"此处传客户端获取的app版本号"];
    
    if (completionHandler) {
        completionHandler(respModel);
    }
}
/**
 * 请求对应账号的签名params["address","data"]
 */

- (void)ethSign:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 进行ETH的签名
     * 用户可以选择拒绝签名
     * 拒绝签名为一种错误，请error传入错误信息
     * 请求对应账号的签名params["address","data"]
     */
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc] init];
    NSString *address = model.params[0];
    NSString *data = model.params[1];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    respModel.rawResponse = @"";
    //TODO 业务逻辑
    [self signDataWithMessage:data address:address respModel:respModel completionHandler:completionHandler];
}
/**
 * 给特定的数据进行签名
 * params有两种情况 需要进行判断["address","data"] 和 ["data","address"]
 */
- (void)personalSign:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 进行ETH的签名
     * 用户可以选择拒绝签名
     * 拒绝签名为一种错误，请error传入错误信息
     * 请求对应账号的签名params["address","data"]或者["data","address"]
     */
    BOOL fistIsAddress = [self isAddress:model.params[0]];
    NSString *address = fistIsAddress? model.params[0]:model.params[1];
    NSString *data = fistIsAddress? model.params[1]:model.params[0];
    //TODO 业务逻辑
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    respModel.rawResponse = @"";
    [self signDataWithMessage:data address:address respModel:respModel completionHandler:completionHandler];
}
/**
 * 请求对应账号的签名params["address","data"]
 * v1版本
 */
- (void)ethSignTypeData:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 进行ETH的签名
     * data为类型化的数据
     * 数据示例
     * {"types":{"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}],"Person":[{"name":"name","type":"string"},{"name":"wallet","type":"address"}],"Mail":[{"name":"from","type":"Person"},{"name":"to","type":"Person"},{"name":"contents","type":"string"}]},"primaryType":"Mail","domain":{"name":"Ether Mail","version":"1","chainId":1,"verifyingContract":"0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"},"message":{"from":{"name":"Cow","wallet":"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"},"to":{"name":"Bob","wallet":"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"},"contents":"Hello, Bob!"}}
     * 用户可以选择拒绝签名
     * 拒绝签名为一种错误，请error传入错误信息
     * 请求对应账号的签名params["address",{data}]
     */
    NSString *address = model.params[0];
    NSDictionary *data = model.params[1];
    //TODO 业务逻辑
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    respModel.rawResponse = @"";
    [self signDataWithDict:data address:address respModel:respModel completionHandler:completionHandler];
}
/**
 * 请求对应账号的签名params["address","data"]
 * v3版本
 */
- (void)ethSignTypeDataV3:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 进行ETH的签名 V3版
     * data为类型化的数据
     * 数据示例
     * {"types":{"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}],"Person":[{"name":"name","type":"string"},{"name":"wallet","type":"address"}],"Mail":[{"name":"from","type":"Person"},{"name":"to","type":"Person"},{"name":"contents","type":"string"}]},"primaryType":"Mail","domain":{"name":"Ether Mail","version":"1","chainId":1,"verifyingContract":"0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"},"message":{"from":{"name":"Cow","wallet":"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"},"to":{"name":"Bob","wallet":"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"},"contents":"Hello, Bob!"}}
     * 用户可以选择拒绝签名
     * 拒绝签名为一种错误，请error传入错误信息
     * 请求对应账号的签名params["address",{data}]
     */
    NSString *address = model.params[0];
    NSDictionary *data = model.params[1];
    //TODO 业务逻辑
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    respModel.rawResponse = @"";
    [self signDataWithDict:data address:address respModel:respModel completionHandler:completionHandler];
}
/**
 * 请求对应账号的签名params["address","data"]
 * v4版本
 */
- (void)ethSignTypeDataV4:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 请务必根据自己的业务实现(这是特殊情况)
     * 进行ETH的签名 V4版
     * data为类型化的数据
     * 数据示例
     * {"types":{"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}],"Person":[{"name":"name","type":"string"},{"name":"wallet","type":"address"}],"Mail":[{"name":"from","type":"Person"},{"name":"to","type":"Person"},{"name":"contents","type":"string"}]},"primaryType":"Mail","domain":{"name":"Ether Mail","version":"1","chainId":1,"verifyingContract":"0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"},"message":{"from":{"name":"Cow","wallet":"0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"},"to":{"name":"Bob","wallet":"0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"},"contents":"Hello, Bob!"}}
     * 用户可以选择拒绝签名
     * 拒绝签名为一种错误，请error传入错误信息
     * 请求对应账号的签名params["address",{data}]
     */
    
    NSString *address = model.params[0];
    NSDictionary *data = model.params[1];
    //TODO 业务逻辑
    MetaMaskRespModel *respModel = [[MetaMaskRespModel alloc]init];
    respModel.id = model.id;
    respModel.jsonrpc = model.jsonrpc;
    respModel.rawResponse = @"";
    [self signDataWithDict:data address:address respModel:respModel completionHandler:completionHandler];
}
//====================================
//
//以下三个也都可以在else中实现
//
//====================================
/**
 * 获取用户当前eth余额
 */
- (void)ethGetBalance:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 如无特殊需求，可以直接转交给Eth rpc处理
     * 可以参考Web3 直接请求网络
     * 入参为[address,blockNumber]
     * 获取当前地址的eth余额 16进制 最低单位
     */
    [self requestWithModel:model completionHandler:completionHandler];
}

- (void)ethBlockNumber:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 如无特殊需求，可以直接转交给Eth rpc处理
     * 可以参考Web3 直接请求网络
     * 获取最新的区块号
     */
    [self requestWithModel:model completionHandler:completionHandler];
}
- (void)ethCall:(MetaMaskRepModel *)model completionHandler:(void (^ _Nullable)(MetaMaskRespModel * _Nullable value))completionHandler{
    /**
     * 如无特殊需求，可以直接转交给Eth rpc处理
     * 可以参考Web3 直接请求网络
     * 在当前钱包节点上立即执行/不创建交易
     * result 放置执行结果
     */
    [self requestWithModel:model completionHandler:completionHandler];
}
/**
 * 判断是否是地址
 */
- (BOOL)isAddress:(NSString *)address{
    return address.length == (2 + 20 * 2);
}
@end
