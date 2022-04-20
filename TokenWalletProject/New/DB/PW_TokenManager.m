//
//  PW_TokenManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenManager.h"

#define table_name @"token_wallet_coinList"

@implementation PW_TokenManager

+ (instancetype)shareManager{
    static PW_TokenManager *sharedInstance = nil;
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
        [db jq_createTable:table_name dicOrModel:[PW_TokenModel class]];
    }
}
- (NSInteger)getMaxIndex {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSString *column = [db jq_tableItemMax:table_name column_name:@"sortIndex"];
    return column.integerValue;
}
//保存单个
- (void)saveCoin:(PW_TokenModel*)record{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:table_name dicOrModel:record];
}
- (BOOL)updateCoin:(PW_TokenModel*)record address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:table_name dicOrModel:record whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = %ld",address,type,tokenAddress,chainId]];
}
- (BOOL)updateSortIndex:(NSInteger)sortIndex address:(NSString *)address type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:table_name dicOrModel:@{@"sortIndex":@(sortIndex)} whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = %ld",address,type,tokenAddress,chainId]];
}
- (PW_TokenModel *)isExist:(NSString *)walletAddress type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray *records = [db jq_lookupTable:table_name dicOrModel:[PW_TokenModel class] whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = %ld",walletAddress,type,tokenAddress,chainId]];
    if(records&&records.count>0){
        return records.firstObject;
    }
    return nil;
}
- (void)deleteCoinWalletAddress:(NSString *)walletAddress type:(NSString *)type tokenAddress:(NSString *)tokenAddress chainId:(NSInteger)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:table_name whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenContract = '%@' and tokenChain = %ld",walletAddress,type,tokenAddress,chainId]];
}
//查询token_address 下的所有记录
- (NSArray*)getListWithWalletAddress:(NSString *)walletAddress type:(NSString *)type chainId:(NSInteger)chainId{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:table_name dicOrModel:[PW_TokenModel class] whereFormat:[NSString stringWithFormat:@"where walletAddress = '%@' and walletType = '%@' and tokenChain = %ld ORDER BY sortIndex ASC",walletAddress,type,chainId]];
    return records;
}


@end
