//
//  PW_NFTCollectionModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTCollectionModel.h"

@implementation PW_NFTCollectionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"cId":@"id",@"desc":@"description"};
}

@end
