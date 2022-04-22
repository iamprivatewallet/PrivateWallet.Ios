//
//  PW_DappBrowserModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappBrowserModel.h"

@implementation PW_DappBrowserModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dapp_1":[PW_DappModel class],
        @"dapp_56":[PW_DappModel class],
        @"dapp_128":[PW_DappModel class],
        @"dappTop":[PW_DappModel class],
        @"banner_1_1":[PW_BannerModel class],
        @"banner_2_2":[PW_BannerModel class],
        @"banner_2_3":[PW_BannerModel class],
    };
}

@end
