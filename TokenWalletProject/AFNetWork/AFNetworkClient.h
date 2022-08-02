//
//  AFNetworkClient.h
//  DemoApp
//
//  Created by Zinkham on 15/10/21.
//  Copyright © 2015年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Urls.h"

@interface AFNetworkClient : NSObject

+(NSURLSessionDataTask *)requestGetWithUrl:(NSString *)urlString
                                withParameter: (NSDictionary *)parameter
                                withBlock:(void(^)(id data, NSError *error))block;

+(NSURLSessionDataTask *)requestPostWithUrl:(NSString *)urlString
                                withParameter: (NSDictionary *)parameter
                                withBlock:(void(^)(id data, NSError *error))block;

+(NSURLSessionDataTask *)requestUploadWithUrl:(NSString *)urlString
                                    mediaData:(NSArray *)mediaDatas
                                withParameter:(NSDictionary *)parameter
                                withBlock:(void(^)(id data, NSError *error))block;

+(NSString *)signWithParmString:(NSDictionary *)parmDic;

@end
