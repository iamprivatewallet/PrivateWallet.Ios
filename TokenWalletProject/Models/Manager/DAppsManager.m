//
//  DAppsManager.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsManager.h"

@implementation DAppsManager

+(instancetype)sharedInstance
{
    static DAppsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)setDAppsCollectionArray:(NSArray *)array
{
    if (array) {
        NSString *name = @"DAppsCollectionArray";
        NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
        [array writeToFile:path atomically:YES];
    }
}

-(NSArray *)getDAppsCollectionArray
{
    NSString *name = @"DAppsCollectionArray";
    NSString *path = [[self documentPath] stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

- (NSDictionary *)getDAppsWithUrl:(NSString *)url{
    NSArray *array = [self getDAppsCollectionArray];
    for (NSDictionary *item in array) {
        NSString *app = [item objectForKey:@"appUrl"];
        if ([url isEqualToString:app]) {
            return item;
        }
    }
    return nil;
}

-(void)addDAppsCollection:(NSDictionary *)dic
{
    BOOL has = NO;
    NSArray *array = [self getDAppsCollectionArray];
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
        [self setDAppsCollectionArray:mArray];
    }else{

    }
}
-(void)deleteDApps:(NSString *)url
{
    NSArray *array = [self getDAppsCollectionArray];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *item in mArray) {
        NSString *str = [item objectForKey:@"appUrl"];
        if ([url isEqualToString:str]) {
            [mArray removeObject:item];
            break;
        }
    }
    [self setDAppsCollectionArray:mArray];
}
-(NSString *)documentPath{
    NSArray *documents =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *document = documents.firstObject;
    return document;
}
@end
