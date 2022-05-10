//
//  WalletManager.m
//  TokenWalletProject
//
//  Created by jackygood on 2018/12/24.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "WalletManager.h"
#import "JQFMDB.h"

#define table_name @"GCS_wallet"

@implementation WalletManager

+ (instancetype)shareWalletManager{
    static WalletManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    [self initTable];
    return self;
}

- (void)initTable{
    JQFMDB * db = [JQFMDB shareDatabase];
    if (![db jq_isExistTable:table_name]) {
        [db jq_createTable:table_name dicOrModel:[Wallet class]];
    }

}

- (Wallet *)currentWallet {
    return [self getWalletWithAddress: User_manager.currentUser.chooseWallet_address type:User_manager.currentUser.chooseWallet_type];
}

//保存单个钱包
- (void)saveWallet:(Wallet*)wallet{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:table_name dicOrModel:wallet];
}

//保存多个钱包
- (void)saveWallets:(NSArray*)wallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * arrays = [db jq_insertTable:table_name dicOrModelArray:wallets];
    NSLog(@"arrays::%@",arrays);
}
//查询名下所有钱包
- (NSArray*)getWallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where owner = '%@'",User_manager.currentUser.user_name]];
    return wallets;
}
//查询对应类型的钱包
- (NSArray*)selectWalletWithType:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where owner = '%@' and type = '%@'",User_manager.currentUser.user_name,type]];
    
    return wallets;
}
//查询初始钱包
- (NSArray*)getOrignWallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where owner = '%@' and isImport = '0'",User_manager.currentUser.user_name]];
    return wallets;
}
//查询后导入钱包
- (NSArray*)getImportWallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where owner = '%@' and isImport = '1'",User_manager.currentUser.user_name]];
    return wallets;
}
- (Wallet *)getOriginWalletWithType:(NSString*)type {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where owner = '%@' and type = '%@' and isImport = '0'",User_manager.currentUser.user_name,type]];
    if (wallets && wallets.count>0) {
        Wallet * wallet = wallets[0];
        return wallet;
    }
    return nil;
}

//删除钱包
- (void)deleteWallet:(Wallet*)wallet{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:table_name whereFormat:[NSString stringWithFormat:@"where owner = '%@' and address = '%@' and type = '%@'",User_manager.currentUser.user_name,wallet.address,wallet.type]];
}
//删除名下所有钱包
- (BOOL)deleteAllWallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    BOOL isDelete = [db jq_deleteAllDataFromTable:table_name];
    [db jq_deleteTable:table_name];
    return isDelete;
}

//查询对应私钥的钱包
- (NSArray*)selctWalletWithPrikey:(NSString*)pKey type:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where priKey = '%@' and type = '%@'",pKey,type]];
    return wallets;
}

//查询对应地址的钱包
- (NSArray*)selctWalletWithAddr:(NSString*)addr type:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",addr,type]];
    return wallets;
}

//修改钱包信息
- (void)updataWallet:(Wallet*)wallet{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_updateTable:table_name dicOrModel:wallet whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",wallet.address,wallet.type]];
}

//更新用户名
- (void)updataWalletOwnerTo:(NSString*)toO{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * array = [self getWallets];
    for (Wallet *wt in array) {
        wt.owner = toO;
        [db jq_updateTable:table_name dicOrModel:wt whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",wt.address,wt.type]];
    }
}
////更新价值
//- (void)updataWalletTotalValueTo:(NSString*)toO WalletType:(NSString *)type{
//    JQFMDB * db = [JQFMDB shareDatabase];
//    NSArray * array = [self getWallets];
//    for (Wallet *wt in array) {
//        if ([wt.type isEqualToString:type]) {
//            wt.totalValue = toO;
//            [db jq_updateTable:table_name dicOrModel:wt whereFormat:[NSString stringWithFormat:@"where address = '%@'",wt.address]];
//        }
//    }
//}
////更新隐藏状态
//- (void)updataWalletHiddenTo:(NSString*)hidden WalletType:(NSString *)type{
//    JQFMDB * db = [JQFMDB shareDatabase];
//    NSArray * array = [self getWallets];
//    for (Wallet *wt in array) {
//        if ([wt.type isEqualToString:type]) {
//            wt.hiddenBalance = hidden;
//            [db jq_updateTable:table_name dicOrModel:wt whereFormat:[NSString stringWithFormat:@"where address = '%@'",wt.address]];
//        }
//    }
//}
- (void)updataWalletOpenId:(NSString*)openId WalletType:(NSString *)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * array = [self getWallets];
    for (Wallet *wt in array) {
        if ([wt.type isEqualToString:type]) {
            wt.isOpenID = openId;
            [db jq_updateTable:table_name dicOrModel:wt whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",wt.address,wt.type]];
        }
    }
}
+ (NSString*)getPriWithAddress:(NSString*)address{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where address = '%@'",address]];
    if (wallets && wallets.count>0) {
        Wallet * wallet = wallets[0];
        return wallet.priKey;
    }
    return nil;
}
- (Wallet *)getWalletWithAddress:(NSString*)address type:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",address,type]];
    if (wallets && wallets.count>0) {
        Wallet * wallet = wallets[0];
        return wallet;
    }
    return nil;
}
- (Wallet *)getWalletWithPriKey:(NSString*)priKey{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where priKey = '%@'",priKey]];
    if (wallets && wallets.count>0) {
        Wallet * wallet = wallets[0];
        return wallet;
    }
    return nil;
}
//查询私钥对应信息
- (NSString*)selectUserPrikey:(NSString*)prikey{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:table_name dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where priKey = '%@'",prikey]];
    if (wallets && wallets.count>0) {
        Wallet * wallet = wallets[0];
        return wallet.owner;
    }
    return nil;
}


@end
