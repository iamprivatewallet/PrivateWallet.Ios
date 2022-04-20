//
//  PW_NetworkManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NetworkManager.h"

static NSString * _Nonnull PW_TableName = @"wallet_networkList";

@implementation PW_NetworkManager

+ (instancetype)shared {
    static PW_NetworkManager *sharedInstance = nil;
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
        [db jq_createTable:PW_TableName dicOrModel:[PW_NetworkModel class]];
    }
}
- (NSInteger)getMaxIndex {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSString *column = [db jq_tableItemMax:PW_TableName column_name:@"sortIndex"];
    return column.integerValue;
}
- (void)saveModel:(PW_NetworkModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_TableName dicOrModel:model];
}
- (BOOL)updateModel:(PW_NetworkModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:model whereFormat:[NSString stringWithFormat:@"where chainId = '%@' and symbol = '%@' and rpcUrl = '%@'",model.chainId,model.symbol,model.rpcUrl]];
}
- (BOOL)updateSortIndex:(NSInteger)sortIndex chainId:(NSString *)chainId {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:@{@"sortIndex":@(sortIndex)} whereFormat:[NSString stringWithFormat:@"where chainId = '%@'",chainId]];
}
- (void)deleteModel:(PW_NetworkModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:PW_TableName whereFormat:[NSString stringWithFormat:@"where chainId = '%@' and symbol = '%@' and rpcUrl = '%@'",model.chainId,model.symbol,model.rpcUrl]];
}
- (nullable PW_NetworkModel *)isExistWithChainId:(NSString *)chainId {
    NSArray *array = [self getListWithChainId:chainId];
    if(array&&array.count>0){
        return array.firstObject;
    }
    return nil;
}
- (NSArray<PW_NetworkModel *> *)getList {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_NetworkModel class] whereFormat:@"ORDER BY sortIndex ASC"];
    return records;
}
- (NSArray<PW_NetworkModel *> *)getListWithChainId:(NSString *)chainId {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_NetworkModel class] whereFormat:[NSString stringWithFormat:@"where chainId = '%@' ORDER BY sortIndex ASC",chainId]];
    return records;
}

@end
