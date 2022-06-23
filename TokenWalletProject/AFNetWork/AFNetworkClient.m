//
//  AFNetworkClient.m
//  DemoApp
//
//  Created by Zinkham on 15/10/21.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import "AFNetworkClient.h"
#import <CommonCrypto/CommonCrypto.h>
#import "UserManager.h"

@interface AFNetworkClient()
{

}
@end


@implementation AFNetworkClient

+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/json", @"text/json", @"text/javascript", @"application/xml",@"text/plain", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    });
    return manager;
}


+(NSURLSessionDataTask *)requestGetWithUrl:(NSString *)urlString
                                withParameter: (NSDictionary *)parameter
                              withBlock:(void(^)(id data, NSError *error))block
{
    NSMutableDictionary *reParam = [AFNetworkClient repackageParamter:parameter];
    return [[AFNetworkClient sessionManager] GET:urlString parameters:reParam headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+(NSURLSessionDataTask *)requestPostWithUrl:(NSString *)urlString
                                 withParameter: (NSDictionary *)parameter
                              withBlock:(void(^)(id data, NSError *error))block
{
    NSMutableDictionary *reParam = [AFNetworkClient repackageParamter:parameter];
    NSString *languageCode = [LanguageTool currentLanguage].languageCode;
    reParam[@"languageCode"] = languageCode;
    NSDictionary *headers = @{@"languageCode":languageCode};
    return [[AFNetworkClient sessionManager] POST:urlString parameters:reParam headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

+(NSMutableDictionary *)repackageParamter:(NSDictionary *)parameter
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    // 增加UserManager信息，设备信息等公共参数,签名等
    //to do
    return result;
}

//生成签名
+(NSString *)signWithParmString:(NSDictionary *)parmDic
{
    NSString *signKey = @"616568ac65c14465872b6a77c47b3367";
    NSString *signString = @"";
    NSArray *allKeys = [parmDic allKeys];
    NSSortDescriptor*sd1 = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    allKeys = [allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    for (int i = 0; i < allKeys.count; i++) {
        signString = [NSString stringWithFormat:@"%@%@%@",signString,[allKeys objectAtIndex:i], [parmDic valueForKey:[allKeys objectAtIndex:i]]];
    }
    signString = [NSString stringWithFormat:@"%@%@",signString, signKey];
    NSString *urlEncode=(NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                             (CFStringRef)signString, nil,
                                                                                             (CFStringRef)@"~!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *mdString=[self md5:urlEncode];
    //[urlEncode release];
    return mdString;
}

+(NSString *)md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


@end
