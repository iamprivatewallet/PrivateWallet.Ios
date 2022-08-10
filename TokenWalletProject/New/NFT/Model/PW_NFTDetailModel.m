//
//  PW_NFTDetailModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTDetailModel.h"

@implementation PW_NFTDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"traits":[PW_NFTTraitModel class],
        @"tokens":[PW_NFTTokenModel class],
    };
}

@end
