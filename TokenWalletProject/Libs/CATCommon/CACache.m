//
//  CACache.m
//  TokenWalletProject
//
//  Created by wang qiang on 2019/1/14.
//  Copyright © 2019 Zinkham. All rights reserved.
//

#import "CACache.h"
#import <CommonCrypto/CommonDigest.h>

#define url_key @"http://dev.icwv.co:12000/tx/mkt/pbqms.do"
#define situation_key @"situation_key"

@implementation NSString (NSString_Hashing)

- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
@implementation CACache

+ (instancetype)defaultManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    [AFNetworkClient  requestPostWithUrl:url_key withParameter:@{} withBlock:^(id data, NSError *error) {
        if (!error) {
            [[CACache defaultManager] saveData:data urlString:situation_key];
        }
    }];
    return self;
}

- (NSTimeInterval)validTime {
    if (_validTime) {
        return _validTime;
    }
    return 60.0 * 60.0;
}

-(void)saveData:(NSDictionary *)data urlString:(NSString *)urlString{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/DataCache/", NSHomeDirectory()];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *md5String = [urlString MD5Hash];
    
    NSString *newString = [NSString stringWithFormat:@"%@/%@.json",path,md5String];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    [jsonData writeToFile:newString atomically:YES];
    
}

//- (SituationModel*)getSData{
//    NSDictionary * data = [self getDataWithUrlString:situation_key];
//    SituationModel * model = [[SituationModel alloc] initWithDictionary:data error:nil];
//    return model;
//}
- (id)getDataWithUrlString:(NSString *)urlString{
    NSString *fileName = [NSString stringWithFormat:@"%@/Documents/DataCache/%@.json",NSHomeDirectory(), [urlString MD5Hash]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName] == NO) {
        return nil;
    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[self getLastmodefyTime:fileName]];

    if (interval > self.validTime) {
        [AFNetworkClient  requestPostWithUrl:url_key withParameter:@{} withBlock:^(id data, NSError *error) {
            if (!error) {
                [[CACache defaultManager] saveData:data urlString:situation_key];
            }
        }];
    }
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:fileName] options:NSJSONReadingAllowFragments error:nil];
}

- (NSDate *)getLastmodefyTime:(NSString *)filePath{
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return dic[@"NSFileModificationDate"];
}

- (id)getCacheDataWithParams:(NSDictionary*)params url:(NSString*)url{
    NSString *cacheKey = (params ? [NSString stringWithFormat:@"%@%@", url, [params description]] : url);
    id data = [self getDataWithUrlString:cacheKey];
    return data;
}

@end
