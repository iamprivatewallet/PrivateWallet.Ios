//
//  PW_NFTMarketModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTMarketModel.h"

@implementation PW_NFTMarketModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"collections":[PW_NFTCollectionModel class],
        @"assets":[PW_NFTTokenModel class],
        @"banners":[PW_NFTBannerModel class],
    };
}

@end
