//
//  PW_SearchNFTModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/9.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchNFTModel.h"

@implementation PW_SearchNFTModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"collections":[PW_NFTCollectionModel class],
        @"accounts":[PW_NFTAccountModel class],
        @"items":[PW_NFTItemModel class],
    };
}

@end
