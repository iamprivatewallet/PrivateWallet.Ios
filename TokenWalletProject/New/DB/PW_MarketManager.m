//
//  PW_MarketManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketManager.h"

static NSString * _Nonnull PW_TableName = @"wallet_market";

@implementation PW_MarketManager

+ (instancetype)shared {
    static PW_MarketManager *sharedInstance = nil;
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
        [db jq_createTable:PW_TableName dicOrModel:[PW_MarketModel class]];
    }
}
- (void)saveModel:(PW_MarketModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_TableName dicOrModel:model];
}
- (BOOL)updateModel:(PW_MarketModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:model whereFormat:[NSString stringWithFormat:@"where symbol = '%@'",model.symbol]];
}
- (void)deleteModel:(PW_MarketModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:PW_TableName whereFormat:[NSString stringWithFormat:@"where symbol = '%@'",model.symbol]];
}
- (NSArray<PW_MarketModel *> *)getList {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_AddressBookModel class] whereFormat:nil];
    return records;
}
- (nullable PW_MarketModel *)isExistWithSymbol:(NSString *)symbol {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_MarketModel class] whereFormat:@"where symbol = '%@'",symbol];
    if (records&&records.count>0) {
        return records.firstObject;
    }
    return nil;
}

@end
