//
//  PW_DappModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappModel.h"

@implementation PW_DappModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"dId":@"id",@"desc":@"description"};
}
- (void)setAppUrl:(NSString *)appUrl {
    _appUrl = appUrl;
    if (![self.iconUrl isNoEmpty]) {
        NSURL *url = [NSURL URLWithString:appUrl];
        NSString *scheme = url.scheme;
        if(![scheme isNoEmpty]){
            scheme = @"https";
        }
        self.iconUrl = [NSString stringWithFormat:@"%@://%@/favicon.ico",scheme,url.host];
    }
}
- (NSString *)appName {
    if ([_appName isNoEmpty]) {
        return _appName;
    }
    return _appUrl;
}

@end
