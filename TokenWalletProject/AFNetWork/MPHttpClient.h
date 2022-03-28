//
//  MPHttpClient.h
//  CommonFramework
//
//  Created by Mr.Marple on 2017/12/12.
//  Copyright © 2017年 com.maliping. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
/*
 测试环境
 */

/*
 生产环境
 */
//#define baseUrl @""


@interface MPHttpClient : AFHTTPSessionManager

+(instancetype)shareClient;

+(instancetype)appProgramClient;
//GET 请求
-(NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;
//POST 请求
- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;

//PUT 请求
- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion;

//DELETE 请求
- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completionk;


- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params mustResponse:(BOOL)isMust completion:( void (^)(id results, NSError *error) )completion;

-(void)relogin;
@end
