//
//  WalletCoinListManager.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "WalletCoinListManager.h"
#import "JQFMDB.h"

#define table_name @"token_wallet_coinList"

@implementation WalletCoinListManager

+ (instancetype)shareManager{
    static WalletCoinListManager *sharedInstance = nil;
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
        [db jq_createTable:table_name dicOrModel:[AssetCoinModel class]];
    }
}
- (NSInteger)getMaxIndex {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSString *column = [db jq_tableItemMax:table_name column_name:@"sortIndex"];
    return column.integerValue;
}
//保存单个
- (void)saveCoin:(AssetCoinModel*)record{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:table_name dicOrModel:record];
}
- (BOOL)updateCoin:(AssetCoinModel*)record address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:table_name dicOrModel:record whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = '%@'",address,type,tokenAddress,chainId]];
}
- (BOOL)updateSortIndex:(NSInteger)sortIndex address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:table_name dicOrModel:@{@"sortIndex":@(sortIndex)} whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = '%@'",address,type,tokenAddress,chainId]];
}
- (AssetCoinModel *)isExit:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray *records = [db jq_lookupTable:table_name dicOrModel:[AssetCoinModel class] whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = '%@'",address,type,tokenAddress,chainId]];
    if(records&&records.count>0){
        return records.firstObject;
    }
    return nil;
}
- (void)deleteCoin:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSString *)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:table_name whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = '%@'",address,type,tokenAddress,chainId]];
}
//查询token_address 下的所有记录
- (NSArray*)getListWithWalletAddress:(NSString *)address type:(NSString *)type chainId:(NSString *)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:table_name dicOrModel:[AssetCoinModel class] whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenChain = '%@' ORDER BY sortIndex ASC",address,type,chainId]];
    return records;
}

@end
