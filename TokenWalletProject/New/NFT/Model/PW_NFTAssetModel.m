//
//  PW_NFTAssetModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTAssetModel.h"

@implementation PW_NFTAssetModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"collections":[PW_NFTCollectionModel class],
        @"tokens":[PW_NFTTokenModel class],
    };
}

@end
