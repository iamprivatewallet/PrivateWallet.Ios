//
//  PW_WalletManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletManager.h"

static NSString * _Nonnull PW_TableName = @"wallet_walletList";

@implementation PW_WalletManager

+ (instancetype)shared{
    static PW_WalletManager *sharedInstance = nil;
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
    if (![db jq_isExistTable:PW_TableName]) {
        [db jq_createTable:PW_TableName dicOrModel:[Wallet class]];
        //旧数据
        NSArray *array = [[WalletManager shareWalletManager] getWallets];
        if (array&&array.count>0) {
            [db jq_insertTable:PW_TableName dicOrModelArray:array];
//            [[WalletManager shareWalletManager] deleteAllWallets];
        }
    }
}
//保存单个钱包
- (void)saveWallet:(Wallet*)wallet{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_TableName dicOrModel:wallet];
}
//保存多个钱包
- (void)saveWallets:(NSArray*)wallets {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * arrays = [db jq_insertTable:PW_TableName dicOrModelArray:wallets];
    NSLog(@"arrays::%@",arrays);
}
//查询名下所有钱包
- (NSArray*)getWallets {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:@"ORDER BY sortIndex ASC"];
    return wallets;
}
//查询对应类型的钱包
- (NSArray*)selectWalletWithType:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where type = '%@' ORDER BY sortIndex ASC",type]];
    
    return wallets;
}
- (NSInteger)getMaxIndex {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSString *column = [db jq_tableItemMax:PW_TableName column_name:@"sortIndex"];
    return column.integerValue;
}
//查询初始钱包
- (NSArray*)getOrignWallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:@"where isImport = '0' ORDER BY sortIndex ASC"];
    return wallets;
}
//查询后导入钱包
- (NSArray*)getImportWallets{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:@"where isImport = '1' ORDER BY sortIndex ASC"];
    return wallets;
}
- (Wallet *)getOriginWalletWithType:(NSString*)type {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where type = '%@' and isImport = '0'",type]];
    if (wallets && wallets.count>0) {
        Wallet * wallet = wallets[0];
        return wallet;
    }
    return nil;
}
- (BOOL)updateSortIndex:(NSInteger)sortIndex address:(NSString *)address type:(NSString *)type {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:@{@"sortIndex":@(sortIndex)} whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",address,type]];
}
//删除钱包
- (void)deleteWallet:(Wallet*)wallet{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:PW_TableName whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",wallet.address,wallet.type]];
}
- (void)deleteAll {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteAllDataFromTable:PW_TableName];
}
//修改钱包信息
- (void)updateWallet:(Wallet*)wallet{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_updateTable:PW_TableName dicOrModel:wallet whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",wallet.address,wallet.type]];
}
//更新用户名
- (void)updateWalletOwner:(NSString*)owner{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * array = [self getWallets];
    for (Wallet *wt in array) {
        wt.owner = owner;
        [db jq_updateTable:PW_TableName dicOrModel:wt whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",wt.address,wt.type]];
    }
}
- (BOOL)updateWalletName:(NSString *)name address:(NSString *)address type:(NSString *)type {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:@{@"walletName":name} whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",address,type]];
}
- (BOOL)updateWalletPwd:(NSString *)pwd address:(NSString *)address type:(NSString *)type {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:@{@"walletPassword":pwd} whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",address,type]];
}
//查询对应私钥的钱包
- (NSArray*)selctWalletWithPrikey:(NSString*)pKey type:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where priKey = '%@' and type = '%@'",pKey,type]];
    return wallets;
}
//查询对应地址的钱包
- (NSArray*)selctWalletWithAddr:(NSString*)addr type:(NSString*)type{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * wallets = [db jq_lookupTable:PW_TableName dicOrModel:[Wallet class] whereFormat:[NSString stringWithFormat:@"where address = '%@' and type = '%@'",addr,type]];
    return wallets;
}

@end
