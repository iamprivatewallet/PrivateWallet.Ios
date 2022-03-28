//
//  VisitDAppsRecordManager.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/15.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "VisitDAppsRecordManager.h"

@implementation VisitDAppsRecordManager

+(instancetype)sharedInstance
{
    static VisitDAppsRecordManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)setDAppsRecordArray:(NSArray *)array
{
    if (array) {
        NSString *name = @"DAppsRecordArray";
        NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
        [array writeToFile:path atomically:YES];
    }
}

-(NSArray *)getDAppsVisitArray
{
    NSString *name = @"DAppsRecordArray";
    NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (NSDictionary *)getDAppsWithUrl:(NSString *)url{
    NSArray *array = [self getDAppsVisitArray];
    for (NSDictionary *item in array) {
        NSString *app = [item objectForKey:@"appUrl"];
        if ([url isEqualToString:app]) {
            return item;
        }
    }
    return nil;
}

-(void)addDAppsRecord:(NSDictionary *)dic
{
    BOOL has = NO;
    NSArray *array = [self getDAppsVisitArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    NSString *addDApps = [dic objectForKey:@"appUrl"];

    for (NSDictionary *item in mArray) {
        NSString *app = [item objectForKey:@"appUrl"];
        if ([addDApps isEqualToString:app]) {
            has = YES;
            break;
        }
    }
    if (!has) {
        [mArray addObject:dic];
        [self setDAppsRecordArray:mArray];
    }else{

    }
}
-(void)deleteDAppsRecord:(NSString *)url
{
    NSArray *array = [self getDAppsVisitArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *item in mArray) {
        NSString *str = [item objectForKey:@"appUrl"];
        if ([url isEqualToString:str]) {
            [mArray removeObject:item];
            break;
        }
    }
    [self setDAppsRecordArray:mArray];
}
-(NSString *)documentPath{
    NSArray *documents =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = documents.firstObject;
    return document;
}

@end
