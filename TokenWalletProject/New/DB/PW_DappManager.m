//
//  PW_DappManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappManager.h"

static NSString * _Nonnull PW_TableName = @"wallet_dappRecentBrowse";

@implementation PW_DappManager

+ (instancetype)shared {
    static PW_DappManager *sharedInstance = nil;
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
        [db jq_createTable:PW_TableName dicOrModel:[PW_DappModel class]];
    }
}
- (void)saveModel:(PW_DappModel *)model {
    if (model==nil) {
        return;
    }
    if ([self isExistWithUrlStr:model.appUrl]) {
        return;
    }
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_TableName dicOrModel:model];
}
- (BOOL)updateModel:(PW_DappModel *)model {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_updateTable:PW_TableName dicOrModel:model whereFormat:[NSString stringWithFormat:@"where appUrl = '%@'",model.appUrl]];
}
- (BOOL)deleteWithUrlStr:(NSString *)urlStr {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_deleteTable:PW_TableName whereFormat:[NSString stringWithFormat:@"where appUrl = '%@'",urlStr]];
}
- (NSArray<PW_DappModel *> *)getList {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray *records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_DappModel class] whereFormat:nil];
    return [[records reverseObjectEnumerator] allObjects];
}
- (BOOL)deleteAll {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_deleteAllDataFromTable:PW_TableName];
}
- (nullable PW_DappModel *)isExistWithUrlStr:(NSString *)urlStr {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_DappModel class] whereFormat:@"where appUrl = '%@'",urlStr];
    if (records&&records.count>0) {
        return records.firstObject;
    }
    return nil;
}

@end
