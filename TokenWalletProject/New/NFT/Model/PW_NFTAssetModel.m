//
//  PW_NFTAssetModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTAssetModel.h"

@implementation PW_NFTAssetModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"cId":@"id",@"desc":@"description"};
}

@end
