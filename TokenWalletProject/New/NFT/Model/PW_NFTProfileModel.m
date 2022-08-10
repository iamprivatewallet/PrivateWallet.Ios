//
//  PW_NFTProfileModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTProfileModel.h"

@implementation PW_NFTProfileModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"pId":@"id",@"desc":@"description"};
}

@end
