//
//  PW_AddressBookManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddressBookManager.h"

static NSString * _Nonnull PW_TableName = @"wallet_addressBook";

@implementation PW_AddressBookManager

+ (instancetype)shared {
    static PW_AddressBookManager *sharedInstance = nil;
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
        [db jq_createTable:PW_TableName dicOrModel:[PW_AddressBookModel class]];
    }
}
- (void)saveModel:(PW_AddressBookModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_TableName dicOrModel:model];
}
- (BOOL)updateModel:(PW_AddressBookModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:model whereFormat:[NSString stringWithFormat:@"where time = %lf",model.time]];
}
- (void)deleteModel:(PW_AddressBookModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:PW_TableName whereFormat:[NSString stringWithFormat:@"where time = %lf",model.time]];
}
- (void)deleteAll {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteAllDataFromTable:PW_TableName];
}
- (NSArray<PW_AddressBookModel *> *)getList {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_AddressBookModel class] whereFormat:@"ORDER BY time DESC"];
    return records;
}
- (NSArray<PW_AddressBookModel *> *)getListWithChainId:(NSString *)chainId {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_AddressBookModel class] whereFormat:[NSString stringWithFormat:@"where chainId = '%@' ORDER BY time DESC",chainId]];
    return records;
}

@end
