//
//  CWVTool.m
//  FunnyProject
//
//  Created by jackygood on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "FchainTool.h"

#import "FSOpenSSL.h"
#import "brewchain.h"
#include <openssl/opensslv.h>
#import "Tx.pbobjc.h"
#import "JKBigDecimal.h"
@implementation FchainTool

//生成助记词
+ (NSString*)generateMnemonic{
    NSString * str = [Bip44 generateMnemonic:english];
    NSLog(@"str::%@",str);
    return str;
}

//根据助记词恢复身份
+ (NSString*)restoreWalletWithMnemonic:(NSString*)mnemonic password:(NSString *)password{
    NSString * mainPriKey = [Bip44 mnemonicToHDPrivateKey:mnemonic passwd:@""];
    NSLog(@"eth mainPriKey::%@",mainPriKey);
    NSString * addr = [Bip44 getAddress:mainPriKey index:0];
    NSLog(@"eth addr::%@",addr);
    NSString * prikey = [Bip44 getPrivateKey:mainPriKey index:0];

    NSString * ownerStr = @"identity_name";
    NSString * pubkey = @"eth";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *list = @[@"ETH"];
    
    for (int i = 0; i<list.count; i++) {
        NSDictionary *dic = @{
            @"type":list[i],
            @"walletName":list[i],
            @"walletPassword":password,
            @"owner":ownerStr,
            @"mnemonic":mnemonic,
            @"pubKey":pubkey,
            @"priKey":prikey,
            @"address":[addr formatToEth],
            @"isImport":@"0",
            @"totalBalance":@"0",
            @"coinCount":@(0),
            @"isOpenID":@"0",

        };
        Wallet * wallet = [Wallet mj_objectWithKeyValues:dic];
        [arr addObject:wallet];
    }
    [[WalletManager shareWalletManager] saveWallets:arr];
    
    return ownerStr;
}

//根据 助记词、用户名 生成 HECO & ETH & BSC 钱包
+ (void)genWalletsWithMnemonic:(NSString*)mnemonic createList:(NSArray *)list{
    NSString * mainPriKey = [Bip44 mnemonicToHDPrivateKey:mnemonic passwd:@""];
    NSLog(@"eth mainPriKey::%@",mainPriKey);
    NSString * addr = [Bip44 getAddress:mainPriKey index:0];
    NSLog(@"eth addr::%@",addr);
    NSString * prikey = [Bip44 getPrivateKey:mainPriKey index:0];
    NSLog(@"eth prikey::%@",prikey);
    NSString * pubkey = @"eth";

    NSString *cprikey = [Bip44 getCWVPrivateKey:mainPriKey index:0];
    NSDictionary *SPDTKey = [CWVChainUtils genFromPrikey:cprikey];
    NSString *cvn_address = SPDTKey[@"hexAddress"];
    NSString *cvn_priKey = SPDTKey[@"hexPrikey"];
    NSString *cvn_pubKey = SPDTKey[@"hexPubkey"];
    
    
    
    NSString *userName = User_manager.currentUser.user_name;
    NSString *userPw = User_manager.currentUser.user_pass;

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *addressStr= addr;
    NSString *prikeyStr= prikey;
    NSString *pubKeyStr= pubkey;
    for (int i = 0; i<list.count; i++) {
        NSString *typeStr = list[i];
        if([typeStr isEqualToString:@"CVN"]) {
            if([cvn_address isEmptyStr]){
                continue;
            }
            addressStr = cvn_address;
            prikeyStr = cvn_priKey;
            pubKeyStr = cvn_pubKey;
        }
        NSArray * array = [[WalletManager shareWalletManager] selctWalletWithAddr:addressStr type:typeStr];
        if (!array || array == nil || array.count>0) {
            continue;
        }
        if([typeStr isEqualToString:@"CVN"]){
            addressStr = [addressStr formatToCVN];
        }else{
            addressStr = [addressStr formatToEth];
        }
        NSDictionary *dic = @{
            @"type":list[i],
            @"walletName":list[i],
            @"walletPassword":userPw,
            @"owner":userName,
            @"mnemonic":mnemonic,
            @"pubKey":pubKeyStr,
            @"priKey":prikeyStr,
            @"address":addressStr,
            @"isImport":@"0",
            @"totalBalance":@"0",
            @"coinCount":@(0),
            @"isOpenID":@"0",
        };
        Wallet * wallet = [Wallet mj_objectWithKeyValues:dic];
        [arr addObject:wallet];
    }

    [[WalletManager shareWalletManager] saveWallets:arr];
    
}

+ (void)genWalletWithMnemonic:(NSString*)mnemonic withWallet:(Wallet *)wallet{
    
    NSString * mainPriKey = [Bip44 mnemonicToHDPrivateKey:mnemonic passwd:@""];
    NSLog(@"eth mainPriKey::%@",mainPriKey);
    NSString * addr = [Bip44 getAddress:mainPriKey index:0];
    NSLog(@"eth addr::%@",addr);
    NSString * prikey = [Bip44 getPrivateKey:mainPriKey index:0];
    NSString * pubkey = @"eth";
        
    NSString *userName = User_manager.currentUser.user_name;
    
    NSString *addressStr;
    NSString *prikeyStr;
    NSString *pubKeyStr;
    if ([wallet.type isEqualToString:@"CVN"]) {
        NSString *cprikey = [Bip44 getCWVPrivateKey:mainPriKey index:0];
        NSDictionary *SPDTKey = [CWVChainUtils genFromPrikey:cprikey];
        addressStr = SPDTKey[@"hexAddress"];
        prikeyStr = SPDTKey[@"hexPrikey"];
        pubKeyStr = SPDTKey[@"hexPubkey"];
    }else{
        addressStr = addr;
        prikeyStr = prikey;
        pubKeyStr = pubkey;
    }
    
    NSArray * array = [[WalletManager shareWalletManager] selctWalletWithAddr:addressStr type:wallet.type];
    if (!array || array == nil || array.count>0) {
        return;
    }
    if([wallet.type isEqualToString:@"CVN"]){
        addressStr = [addressStr formatToCVN];
    }else{
        addressStr = [addressStr formatToEth];
    }
    NSDictionary *dic = @{
        @"type":wallet.type,
        @"walletName":wallet.walletName,
        @"walletPassword":wallet.walletPassword,
        @"walletPasswordTips":wallet.walletPasswordTips,
        @"owner":userName,
        @"mnemonic":mnemonic,
        @"pubKey":pubKeyStr,
        @"priKey":prikeyStr,
        @"address":addressStr,
        @"isImport":wallet.isImport,
        @"totalBalance":@"0",
        @"coinCount":@(0),
        @"isOpenID":@"0",
    };
    
    Wallet *w = [Wallet mj_objectWithKeyValues:dic];
    [[WalletManager shareWalletManager] saveWallet:w];
}

//根据私钥导入钱包
+ (void)importPriKey:(Wallet *)model errorBlock:(void(^)(NSString *errorType))block{
    
    NSArray * array = [[WalletManager shareWalletManager] selctWalletWithPrikey:model.priKey type:model.type];
    if (!array || array == nil || array.count>0) {
        block(@"1");
        return;
    }
    NSString *address = @"";
    NSString *priKey = model.priKey;
    NSString *pubKey = @"";
    if ([model.type isEqualToString:@"CVN"]) {
        NSDictionary *SPDTKey = [CWVChainUtils genFromPrikey:model.priKey];
        address = SPDTKey[@"hexAddress"];
        pubKey = SPDTKey[@"hexPubkey"];
    }else{
        KeyPair kp = [EthereumUtils genFromPrikey:model.priKey];
        address = [KeyPairHelper hexAddress:kp];
        pubKey = [KeyPairHelper hexPubkey:kp];
    }
    
    NSString * wName = [NSString stringWithFormat:@"%@-%@",model.type,[CATCommon getRandomStringWithNum:4]];

    if ([address isEqualToString:@"undefined"]) {
        block(@"2");
        return;
    }
    if([model.type isEqualToString:@"CVN"]){
        address = [address formatToCVN];
    }else{
        address = [address formatToEth];
    }
    NSDictionary *dic = @{
        @"type":model.type,
        @"walletName":wName,
        @"walletPassword":model.walletPassword,
        @"walletPasswordTips":model.walletPasswordTips,
        @"owner":User_manager.currentUser.user_name,
        @"mnemonic":@"nothing",
        @"pubKey":pubKey,
        @"priKey":priKey,
        @"address":address,
        @"isImport":@"1",
        @"totalBalance":@"0",
        @"coinCount":@(0),
        @"isOpenID":@"0",
    };
    Wallet * wallet = [Wallet mj_objectWithKeyValues:dic];
    [[WalletManager shareWalletManager] saveWallet:wallet];
    
    block(@"0");
    return;
}

//根据助记词导入钱包
+ (void)importMnemonic:(Wallet *)model errorBlock:(void(^)(NSString *errorType))block{

    NSString * mainPriKey = [Bip44 mnemonicToHDPrivateKey:model.mnemonic passwd:@""];
    NSString * addr = [Bip44 getAddress:mainPriKey index:0];
    NSString * prikey = [Bip44 getPrivateKey:mainPriKey index:0];
    NSString * pubkey = @"eth";
    
    if ([model.type isEqualToString:@"CVN"]) {
        NSString *cprikey = [Bip44 getCWVPrivateKey:mainPriKey index:0];
        NSDictionary *SPDTKey = [CWVChainUtils genFromPrikey:cprikey];
        addr = SPDTKey[@"hexAddress"];
        prikey = SPDTKey[@"hexPrikey"];
        pubkey = SPDTKey[@"hexPubkey"];
    }
    
    if ([addr isEqualToString:@"undefined"]) {
        block(@"2");
        return;
    }
    NSArray * array = [[WalletManager shareWalletManager] selctWalletWithAddr:addr type:model.type];
    if (!array || array == nil || array.count>0) {
        block(@"1");
        return;
    }
    if([model.type isEqualToString:@"CVN"]){
        addr = [addr formatToCVN];
    }else{
        addr = [addr formatToEth];
    }
    NSString *wName = [NSString stringWithFormat:@"%@-%@",model.type,[CATCommon getRandomStringWithNum:4]];
    NSDictionary *dic = @{
        @"walletName":wName,
        @"walletPassword":model.walletPassword,
        @"walletPasswordTips":model.walletPasswordTips,
        @"type":model.type,
        @"coinCount":@(0),
        @"owner":User_manager.currentUser.user_name,
        @"mnemonic":model.mnemonic,
        @"pubKey":pubkey,
        @"priKey":prikey,
        @"address":addr,
        @"isImport":@"1",
        @"totalBalance":@"0",
        @"isOpenID":@"0",
    };
    Wallet * wallet = [Wallet mj_objectWithKeyValues:dic];
    [[WalletManager shareWalletManager] saveWallet:wallet];

    block(@"0");
}

//生成签名
+ (NSString*)genSign:(NSString*)privateKey content:(NSString*)content type:(WalletType)type{
    KeyPair kp = {};
    NSString * signStr = @"";
    if (type == CWVCoin) {
//        kp = [BrewChainUtils genFromPrikey:privateKey];
//        signStr = [BrewChainUtils ecHexSign:kp content:content];
        signStr = [CWVChainUtils cwvecSignTransactionSignhexstring:content];
    }else if (type == Ethereum){
        kp = [EthereumUtils genFromPrikey:privateKey];
        signStr = [EthereumUtils ecSign:kp content:content];
    }else if (type == Bitcoin){
        kp = [BitcoinUtils genFromPrikey:privateKey];
        signStr = [BitcoinUtils ecSign:kp content:content];
    }else{
        return @"";
    }

    NSLog(@"签名::%@",signStr);
    return signStr;
}

//ETH交易签名
+ (NSString*)genETHTransactionSign:(NSDictionary*)dic isToken:(BOOL)isToken{
    KeyPair kp = [EthereumUtils genFromPrikey:dic[@"prikey"]];
    NSLog(@"kp.prikey::%@",[KeyPairHelper hexPrikey:kp]);
    NSString * data = [self genETHTransactionData:dic];
    NSLog(@"data::%@",data);
    NSString *value;
    NSString *toAddr;
    if (isToken == YES) {
        value = @"0x0";
        toAddr = [dic objectForKey:@"contract_addr"];
    }else{
        toAddr = [dic objectForKey:@"to_addr"];
        value = [[dic objectForKey:@"value"] getHex];
    }
    NSString *price = [dic objectForKey:@"gas_price"];
    if([price isEmptyStr]){
        price = @"5000000000";
    }
    int chainId = [[SettingManager sharedInstance] getNodeChainId];
    NSString *gasLimit = @"0x7530";
    if (chainId==1) {
        gasLimit = @"0xea60";
    }
    NSString * sign = [EthereumUtils ecSignTransaction:kp
                               nonce:dic[@"nonce"]
                            gasPrice:[price getHex]
//                            gasLimit:@"0x61A80"
                            gasLimit:gasLimit
                                  to:toAddr
                            hexvalue:value
                                data:data
                             chainId:chainId];
    return sign;
}

+ (NSString*)genETHTransactionData:(NSDictionary*)dic{
    NSString * contractAddr = [dic objectForKey:@"contract_addr"];
    if (contractAddr && ![contractAddr isEqualToString:@""]) {
        NSString * methodName = @"0xa9059cbb000000000000000000000000";
        NSString * toAddr = [[dic objectForKey:@"to_addr"] formatDelEth];
        NSString * amount = [dic objectForKey:@"value"];
        amount = [[amount getHex] stringByReplacingOccurrencesOfString:@"0x"withString:@""];
        amount = [CATCommon hexString:amount minLength:64];
        NSString * str = [NSString stringWithFormat:@"%@%@%@",methodName,toAddr,amount];
        return str;
    }
    return @"0x0";
}



//async

//生成助记词
+ (void)generateMnemonicBlock:(void(^)(NSString *result))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * str = [self generateMnemonic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(str);
            }
        });
    });
}

//根据助记词恢复身份
+ (void)restoreWalletWithMnemonic:(NSString*)str password:(NSString*)password block:(void(^)(NSString *result))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *username = [self restoreWalletWithMnemonic:str password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(username);
            }
        });
    });
}

//根据 助记词、用户名 生成 钱包
+ (void)genWalletsWithMnemonic:(NSString*)mnemonic createList:(NSArray *)list block:(void(^)(BOOL sucess))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self genWalletsWithMnemonic:mnemonic createList:list];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    });
}

//根据助记词新创建钱包
+ (void)genWalletWithMnemonic:(NSString*)mnemonic withWallet:(Wallet *)wallet block:(void(^)(BOOL sucess))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self genWalletWithMnemonic:mnemonic withWallet:wallet];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    });
}

//根据私钥导入钱包
+ (void)importPrikeyFromModel:(Wallet *)model errorType:(void(^)(NSString *errorType, BOOL sucess))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self importPriKey:model errorBlock:^(NSString *errorType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorStr;
                BOOL sucess;
                if ([errorType isEqualToString:@"0"]) {
                    errorStr = @"导入成功";
                    sucess = YES;
                }else if ([errorType isEqualToString:@"1"]) {
                    errorStr = @"相应的钱包已存在";
                    sucess = NO;
                }else {
                    errorStr = @"导入失败";
                    sucess = NO;
                }
                block(errorStr, sucess);
            });
        }];
        
    });
    
}

//根据助记词导入钱包
+ (void)importMnemonicFromModel:(Wallet *)model errorType:(void(^)(NSString *errorType, BOOL sucess))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self importMnemonic:model errorBlock:^(NSString *errorType) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorStr;
                BOOL sucess;
                if ([errorType isEqualToString:@"0"]) {
                    errorStr = @"导入成功";
                    sucess = YES;
                }else if ([errorType isEqualToString:@"1"]) {
                    errorStr = @"相应的钱包已存在";
                    sucess = NO;
                }else {
                    errorStr = @"导入失败";
                    sucess = NO;
                }
                block(errorStr, sucess);
            });
        }];
        
    });
    
}

//ETH交易签名
+ (void)genETHTransactionSign:(NSDictionary*)dic isToken:(BOOL)isToken block:(void(^)(NSString *result))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sign = [self genETHTransactionSign:dic isToken:isToken];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(sign);
            }
        });
    });
}

+ (void)genETHTransactionData:(NSDictionary*)dic block:(void(^)(NSString *result))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = [self genETHTransactionData:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(str);
            }
        });
    });
    
}

//生成签名
+ (void)genSign:(NSString*)privateKey content:(NSString*)content type:(WalletType)type block:(void(^)(NSString *result))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *signStr = [self genSign:privateKey content:content type:type];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(signStr);
            }
        });
    });
}


@end
