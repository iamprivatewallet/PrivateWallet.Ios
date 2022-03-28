//
//  MPHttpClient.m
//  CommonFramework
//
//  Created by Mr.Marple on 2017/12/12.
//  Copyright © 2017年 com.maliping. All rights reserved.
//

#import "MPHttpClient.h"

@implementation MPHttpClient
#pragma mark pulicMethod
+(instancetype)shareClient{
    static MPHttpClient *httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:User_manager.currentUser.current_Node];
        
        //设置配置
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        httpClient = [[MPHttpClient alloc] initWithBaseURL:url
                                          sessionConfiguration:config];
        httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
        [httpClient setRequestSerializer:[AFJSONRequestSerializer serializer]];
        
        
        httpClient.requestSerializer = [MPHttpClient setQuest];
        httpClient.requestSerializer.timeoutInterval = 60;
        httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
//        httpClient.securityPolicy = [MPHttpClient setHttps];
    });
    NSString *cookie = GetUserDefaultsForKey(kWalletCookieKey);
    NSString *value = NSStringWithFormat(@"_smid=%@",cookie);
    if (cookie != nil) {
        [httpClient.requestSerializer setValue:value forHTTPHeaderField:@"Cookie"];
    }
    
    return httpClient;
}




//- (NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSError * error))failureBlock{
//
//    NSURLSessionDataTask *task = [self GET:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        if (httpResponse.statusCode == 200) {
//            successBlock(responseObject);
//        }else {
//            NSError *error = [[NSError alloc]init];
//            failureBlock(error);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failureBlock(error);
//
//    }];
//    return task;
//}

//- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSError * error))failureBlock{
//    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        if (httpResponse.statusCode == 200) {
//            successBlock(responseObject);
//        }else {
//            NSError *error = [[NSError alloc]init];
//            failureBlock(error);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failureBlock(error);
//
//    }];
//    return task;
//}

//- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSError * error))failureBlock{
//    NSURLSessionDataTask *task = [self PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        if (httpResponse.statusCode == 200) {
//            successBlock(responseObject);
//        }else {
//            NSError *error = [[NSError alloc]init];
//            failureBlock(error);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failureBlock(error);
//    }];
//    return task;
//}

//- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock failureBlock:(void (^)(NSError * error))failureBlock{
//
//    //打印接口和请求参数
//    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
//
//    NSURLSessionDataTask *task = [self DELETE:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        if (httpResponse.statusCode == 200) {
//            successBlock(responseObject);
//        }else {
//            NSError *error = [[NSError alloc]init];
//            failureBlock(error);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failureBlock(error);
//    }];
//    return task;
//}


- (NSURLSessionDataTask *)getInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion {
    
    NSURLSessionDataTask *task = [self GET:requestUrl parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);

    }];
    return task;
}

- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params mustResponse:(BOOL)isMust completion:( void (^)(id results, NSError *error) )completion{
    NSURLSessionDataTask *task = [self POST:requestUrl parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"] integerValue] == 10000) {
            NSData *jsonData = [responseObject[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                              error:&err];
            completion(dic,nil);
        }else{
            completion(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);

    }];
    return task;
}


- (NSURLSessionDataTask *)postInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion {
    
    return [self postInfo:requestUrl requestArgument:params mustResponse:NO completion:completion];
}

//- (NSURLSessionDataTask *)putInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completion {
//
//    //打印接口和请求参数
//    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
//
//    NSURLSessionDataTask *task = [self PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        if (completion) {
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//            if (httpResponse.statusCode == 200) {
//                completion(responseObject, nil);
//            }else {
//                completion(nil, nil);
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            //Token失效
//        }
//        if (completion) {
//            completion(nil, error);
//        }
//    }];
//    return task;
//}
//
//- (NSURLSessionDataTask *)deleteInfo:(NSString *)requestUrl requestArgument:(NSDictionary *)params completion:( void (^)(id results, NSError *error) )completionk{
//
//    //打印接口和请求参数
//    NSLog(@"当前请求的接口%@,当前的参数字典%@",requestUrl,params);
//
//    NSURLSessionDataTask *task = [self DELETE:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        if (httpResponse.statusCode == 200) {
//            completionk(responseObject,nil);
//        }else {
//            completionk(nil,nil);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        completionk(nil,error);
//    }];
//    return task;
//}

+ (AFJSONRequestSerializer *)setQuest {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
//    APP 设备型号
    [requestSerializer setValue:[NSString stringWithFormat:@"IOS-P-%@",[[UIDevice currentDevice]model]] forHTTPHeaderField:@"DeviceModel"];
    //APP 设备分辨率
    //设备分辨率
//    int iWidth = [UIScreen mainScreen].bounds.size.width;
//    
//    int iHeight = [UIScreen mainScreen].bounds.size.height;
//    
//    NSString *strR = [NSString stringWithFormat:@"IOS-P-%d,%d",iWidth,iHeight];
//    if (strR && strR.length > 0) {
//        
//        [requestSerializer setValue:strR forHTTPHeaderField:@"DeviceResolution"];
//        
//    }
    return requestSerializer;
}

+ (AFSecurityPolicy *)setHttps {
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    // [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}


-(void)relogin{
//    [HyperUser logout];
//    LoginViewController *vc = [[LoginViewController alloc]init];
//    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
//    navc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navc animated:YES completion:^{
//        
//    }];
}
@end
