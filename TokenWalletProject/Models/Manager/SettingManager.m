//
//  SettingManager.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/29.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "SettingManager.h"

@implementation SettingManager
@dynamic isUseTouchID;
@dynamic langage;
@dynamic money;


+(instancetype)sharedInstance
{
    static SettingManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString * _Nullable)getCurrentAddress {
    return User_manager.currentUser.chooseWallet_address;
}
- (Wallet * _Nullable)getCurrentWallet {
    User *user = User_manager.currentUser;
    Wallet *wallet = [[[PW_WalletManager shared] selctWalletWithAddr:user.chooseWallet_address type:user.chooseWallet_type] firstObject];
    return wallet;
}
-(BOOL)isUseTouchID{
    NSNumber *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"isUseTouchID"];
    return   obj ? [obj boolValue] : NO;
}
-(void)setIsUseTouchID:(BOOL)isUseTouchID {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isUseTouchID] forKey:@"isUseTouchID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isFirstTransfer {
    NSNumber *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTransfer"];
    return   obj ? [obj boolValue] : NO;
}
-(void)setIsUserFirstTransfer:(BOOL)isFirstTransfer {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isFirstTransfer] forKey:@"isFirstTransfer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)langage {
    NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"langage"];
    return   obj ? : @"简体中文";
}
-(void)setLangage:(NSString *)langage {
    [[NSUserDefaults standardUserDefaults] setObject:langage forKey:@"langage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)money {
    NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"money"];
    return obj ? : @"CNY";
}
-(void)setMoney:(NSString *)money {
    [[NSUserDefaults standardUserDefaults] setObject:money forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(int)getNodeChainId {
    NSString *chainId = User_manager.currentUser.current_chainId;
    return [chainId intValue];
}
-(NSString *)getChainType {
    NSString *chainId = User_manager.currentUser.current_chainId;
    if ([chainId isEqualToString:kETHChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kETHChainId]) {
        return @"ETH";
    } else if ([chainId isEqualToString:kHECOChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kHECOChainId]) {
        return @"HECO";
    } else if ([chainId isEqualToString:kBSCChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kBSCChainId]) {
        return @"BSC";
    } else if ([chainId isEqualToString:kCVNChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kCVNChainId]) {
        return @"CVN";
    } else if ([chainId isEqualToString:kWalletTypeTron]) {
        return @"Tron";
    } else {
        return @"ETH";
    }
}
-(NSString *)getChainCoinName {
    NSString *chainId = User_manager.currentUser.current_chainId;
    if ([chainId isEqualToString:kETHChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kETHChainId]) {
        return @"ETH";
    } else if ([chainId isEqualToString:kHECOChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kHECOChainId]) {
        return @"HT";
    } else if ([chainId isEqualToString:kBSCChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kBSCChainId]) {
        return @"BNB";
    } else if ([chainId isEqualToString:kCVNChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kCVNChainId]) {
        return @"CVNT";
    } else if ([chainId isEqualToString:kWalletTypeTron]) {
        return @"TRX";
    } else {
        return @"ETH";
    }
}
-(void)setNode:(NSString *)node chianId:(NSString *)chianId {
     [[NSUserDefaults standardUserDefaults] setObject:node forKey:chianId];
     [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)getNodeWithChainId:(NSString *)chainId {
    NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:chainId];
    NSString *obj1 = [[NSUserDefaults standardUserDefaults] objectForKey:chainId.hexString];
    return [obj isNoEmpty] ? obj : ([obj1 isNoEmpty] ? obj1 : [self getNodeArrayWithChainId:chainId].firstObject);
}
-(NSString *)getNodeNameWithChainId:(NSString *)chainId {
    if ([chainId isEqualToString:kETHChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kETHChainId]) {
        return @"Ethereum Mainnet";
    } else if ([chainId isEqualToString:kHECOChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kHECOChainId]) {
        return @"Huobi ECO Chain";
    } else if ([chainId isEqualToString:kBSCChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kBSCChainId]) {
        return @"Binance Smart Chain";
    } else if ([chainId isEqualToString:kCVNChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kCVNChainId]) {
        return @"CVN";
    } else if ([chainId isEqualToString:kWalletTypeTron]) {
        return @"Tron";
    } else {
        return @"";
    }
}
-(NSArray *)getNodeArrayWithChainId:(NSString *)chainId {
    if ([chainId isEqualToString:kETHChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kETHChainId]) {
        return @[kETHRPCUrl];
    } else if ([chainId isEqualToString:kHECOChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kHECOChainId]) {
        return @[kHECORPCUrl];
    } else if ([chainId isEqualToString:kBSCChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kBSCChainId]) {
        return @[kBSCRPCUrl];
    }else if ([chainId isEqualToString:kCVNChainId]||[@(chainId.stringTo10).stringValue isEqualToString:kCVNChainId]) {
        return @[kCVNRPCUrl];
    }else {
        return @[];
    }
}
- (void)getNodeChainIdWithCompletionHandler:(void (^ _Nullable)(NSString * _Nullable chainId))completionHandler {
    NSDictionary *parmDic = @{
                    @"id":@"67",
                    @"jsonrpc":@"2.0",
                    @"method":@"eth_chainId",
                    };
    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
        if (data&&completionHandler) {
            completionHandler(data[@"result"]);
        }
    }];
}
-(NSArray *)getCurrentNode {
    User *user = User_manager.currentUser;
    return @[user.current_Node];
}
-(void)setCustomNodeArray:(NSArray *)array
{
    if (array) {
        NSString *name = @"CustomNodeArray";
        NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
        [array writeToFile:path atomically:YES];
    }
}

-(NSArray *)getCustomNodeArray
{
    NSString *name = @"CustomNodeArray";
    NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}
-(void)addNode:(NSDictionary *)dic
{
    BOOL has = NO;
    NSArray *array = [self getCustomNodeArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    NSString *addNode = [dic objectForKey:@"node_url"];

    for (NSDictionary *item in mArray) {
        NSString *node = [item objectForKey:@"node_url"];
        if ([addNode isEqualToString:node]) {
            has = YES;
            break;
        }
    }
    if (!has) {
        [mArray addObject:dic];
        [self setCustomNodeArray:mArray];
    }else{
        [[ToastHelper sharedToastHelper] toast:@"此节点已经存在"];
    }
}


-(void)setAddressArray:(NSArray *)array
{
    if (array) {
        NSString *name = @"AddressArray";
        NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
        [array writeToFile:path atomically:YES];
    }
}

-(NSArray *)getAddressArray
{
    NSString *name = @"AddressArray";
    NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (BOOL)isExistAddress:(NSString *)addr{
    NSArray *array = [self getAddressArray];
    for (NSDictionary *item in array) {
        NSString *address = [item objectForKey:@"address"];
        if ([addr isEqualToString:address]) {
            return YES;
            break;
        }
    }
    return NO;
}

-(void)addAddress:(NSDictionary *)dic
{
    BOOL has = NO;
    NSArray *array = [self getAddressArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    NSString *addAddress = [dic objectForKey:@"address"];

    for (NSDictionary *item in mArray) {
        NSString *address = [item objectForKey:@"address"];
        if ([addAddress isEqualToString:address]) {
            has = YES;
            break;
        }
    }
    if (!has) {
        [mArray addObject:dic];
        [self setAddressArray:mArray];
    }else{
        [[ToastHelper sharedToastHelper] toast:@"地址已经存在"];
    }
}

-(void)editOldAddress:(NSString *)addr forNewAddress:(NSDictionary *)dic
{
    [self deleteAddress:addr];
    [self addAddress:dic];
}

-(void)deleteAddress:(NSString *)address
{
    NSArray *array = [self getAddressArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *item in mArray) {
        NSString *addr = [item objectForKey:@"address"];
        if ([address isEqualToString:addr]) {
            [mArray removeObject:item];
            break;
        }
    }
    [self setAddressArray:mArray];
}

-(NSString *)documentPath
{
    NSArray *documents =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = documents.firstObject;
    return document;
}

@end
