//
//  PW_NFTSearchManager.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/9.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTSearchManager.h"
static NSString * _Nonnull PW_TableName = @"wallet_nftSearch";

@implementation PW_NFTSearchManager

+ (instancetype)shared {
    static PW_NFTSearchManager *sharedInstance = nil;
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
        [db jq_createTable:PW_TableName dicOrModel:[PW_NFTSearchDBModel class]];
    }
}
- (void)saveModel:(PW_NFTSearchDBModel *)model {
    if (model==nil) {
        return;
    }
    if ([self isExistWithSearch:model.text]) {
        return;
    }
    JQFMDB * db = [JQFMDB shareDatabase];
    [db jq_insertTable:PW_TableName dicOrModel:model];
}
- (BOOL)deleteAll {
    JQFMDB * db = [JQFMDB shareDatabase];
    return [db jq_deleteAllDataFromTable:PW_TableName];
}
- (NSArray<PW_NFTSearchDBModel *> *)getList {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray *records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_NFTSearchDBModel class] whereFormat:nil];
    return [[records reverseObjectEnumerator] allObjects];
}
- (nullable PW_NFTSearchDBModel *)isExistWithSearch:(NSString *)search {
    JQFMDB * db = [JQFMDB shareDatabase];
    NSArray * records = [db jq_lookupTable:PW_TableName dicOrModel:[PW_NFTSearchDBModel class] whereFormat:@"where text = '%@'",search];
    if (records&&records.count>0) {
        return records.firstObject;
    }
    return nil;
}

@end

@implementation PW_NFTSearchDBModel

@end
