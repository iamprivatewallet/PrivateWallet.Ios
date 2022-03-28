//
//  WalletRecordManager.m
//  GCSWalletProject
//
//  Created by MM on 2020/10/28.
//  Copyright © 2020 Zinkham. All rights reserved.
//

#import "WalletRecordManager.h"
#import "JQFMDB.h"

#define table_name @"GCS_wallet_record"

@implementation WalletRecordManager

+ (instancetype)shareRecordManager{
    static WalletRecordManager *sharedInstance = nil;
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
        [db jq_createTable:table_name dicOrModel:[WalletRecord class]];
    }
}
//保存单个
- (void)saveRecord:(WalletRecord*)record{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:table_name dicOrModel:record];
}
- (void)updateRecord:(WalletRecord*)record{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_updateTable:table_name dicOrModel:record whereFormat:[NSString stringWithFormat:@"where from_addr = '%@' and token_address = '%@' and 'trade_id' = '%@'",record.from_addr,record.token_address,record.trade_id]];
}
- (void)deleteRecord:(WalletRecord*)record{
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_deleteTable:table_name whereFormat:[NSString stringWithFormat:@"where from_addr = '%@' and token_address = '%@' and 'trade_id' = '%@'",record.from_addr,record.token_address,record.trade_id]];
}
//查询token_address 下的所有记录
- (NSArray*)getWalletsWithAddress:(NSString *)address tokenAddr:(NSString *)tokenAddr{
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:table_name dicOrModel:[WalletRecord class] whereFormat:[NSString stringWithFormat:@"where from_addr = '%@' and token_address = '%@'",address,tokenAddr]];
    return records;
}

@end
