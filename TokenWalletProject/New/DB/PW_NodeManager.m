//
//  PW_NodeManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NodeManager.h"

static NSString * _Nonnull PW_NodeTableName = @"wallet_nodeList";

@implementation PW_NodeManager

+ (instancetype)shared{
    static PW_NodeManager *sharedInstance = nil;
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
    if (![db jq_isExistTable:PW_NodeTableName]) {
        [db jq_createTable:PW_NodeTableName dicOrModel:[PW_NetworkModel class]];
    }
}
- (void)saveNodeModel:(PW_NetworkModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_NodeTableName dicOrModel:model];
}
- (BOOL)updateNode:(PW_NetworkModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_NodeTableName dicOrModel:model whereFormat:[NSString stringWithFormat:@"where chainId = '%@' and symbol = '%@' and rpcUrl = '%@'",model.chainId,model.symbol,model.rpcUrl]];
}
- (void)deleteNodeModel:(PW_NetworkModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:PW_NodeTableName whereFormat:[NSString stringWithFormat:@"where chainId = '%@' and symbol = '%@' and rpcUrl = '%@'",model.chainId,model.symbol,model.rpcUrl]];
}
- (NSArray<PW_NetworkModel *> *)getNodeListWithChainId:(NSString *)chainId {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_NodeTableName dicOrModel:[PW_NetworkModel class] whereFormat:[NSString stringWithFormat:@"where chainId = '%@'",chainId]];
    return records;
}
- (nullable PW_NetworkModel *)getSelectedNodeWithChainId:(NSString *)chainId {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_NodeTableName dicOrModel:[PW_NetworkModel class] whereFormat:[NSString stringWithFormat:@"where chainId = '%@' and selected = 1",chainId]];
    return records.firstObject;
}

@end
