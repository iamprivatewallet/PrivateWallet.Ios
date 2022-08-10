//
//  PW_NFTWalletAssetModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTWalletAssetModel.h"

@implementation PW_NFTWalletAssetModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"collections":[PW_NFTCollectionModel class],
        @"tokens":[PW_NFTTokenModel class],
    };
}

@end
