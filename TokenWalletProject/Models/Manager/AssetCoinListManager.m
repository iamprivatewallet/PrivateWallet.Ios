//
//  AssetCoinListManager.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetCoinListManager.h"

@implementation AssetCoinListManager

+(instancetype)sharedInstance
{
    static AssetCoinListManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)setArray:(NSArray *)array
{
    if (array) {
        NSString *name = @"AssetCoinsArray";
        NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
        [array writeToFile:path atomically:YES];
    }
}

-(NSArray *)getArray
{
    NSString *name = @"AssetCoinsArray";
    NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (NSDictionary *)getCoinWithID:(NSString *)idStr{
    NSArray *array = [self getArray];
    for (NSDictionary *item in array) {
        NSString *str = [item objectForKey:@"id"];
        if ([idStr isEqualToString:str]) {
            return item;
        }
    }
    return nil;
}

-(void)addCoin:(NSDictionary *)dic
{
    BOOL has = NO;
    NSArray *array = [self getArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    NSString *idStr = [dic objectForKey:@"id"];

    for (NSDictionary *item in mArray) {
        NSString *str = [item objectForKey:@"id"];
        if ([idStr isEqualToString:str]) {
            has = YES;
            break;
        }
    }
    if (!has) {
        [mArray addObject:dic];
        [self setArray:mArray];
    }else{
        [UITools showToast:@"相关资产已存在"];
    }
}
-(void)deleteCoin:(NSString *)idStr
{
    NSArray *array = [self getArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *item in mArray) {
        NSString *str = [item objectForKey:@"id"];
        if ([idStr isEqualToString:str]) {
            [mArray removeObject:item];
            break;
        }
    }
    [self setArray:mArray];
}

-(void)deleteAllCoins{
    NSArray *array = [self getArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    [mArray removeAllObjects];
    [self setArray:mArray];
}

-(NSString *)documentPath{
    NSArray *documents =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = documents.firstObject;
    return document;
}

@end
