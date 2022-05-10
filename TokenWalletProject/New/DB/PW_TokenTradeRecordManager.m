//
//  PW_TokenTradeRecordManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenTradeRecordManager.h"
#import "JQFMDB.h"

#define table_name @"wallet_token_trade_record"

@implementation PW_TokenTradeRecordManager

+ (instancetype)shared{
    static PW_TokenTradeRecordManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    [self initTable];
    return self;
}

- (void)initTable {
    JQFMDB * db = [JQFMDB shareDatabase];
    if (![db jq_isExistTable:table_name]) {
        [db jq_createTable:table_name dicOrModel:[PW_TokenDetailModel class]];
    }
}
- (void)saveRecord:(PW_TokenDetailModel *)record {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:table_name dicOrModel:record];
}
- (void)updateRecord:(PW_TokenDetailModel *)record {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_updateTable:table_name dicOrModel:record whereFormat:[NSString stringWithFormat:@"where fromAddress = '%@' and contractAddress = '%@' and hashStr = '%@'",record.fromAddress,record.contractAddress,record.hashStr]];
}
- (void)deleteRecord:(PW_TokenDetailModel *)record {
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:table_name whereFormat:[NSString stringWithFormat:@"where fromAddress = '%@' and contractAddress = '%@' and hashStr = '%@'",record.fromAddress,record.contractAddress,record.hashStr]];
}
//查询token_address 下的所有记录
- (NSArray*)getWalletsWithAddress:(NSString *)address tokenAddr:(NSString *)tokenAddr {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:table_name dicOrModel:[WalletRecord class] whereFormat:[NSString stringWithFormat:@"where fromAddress = '%@' and contractAddress = '%@'",address,tokenAddr]];
    return records;
}

@end
