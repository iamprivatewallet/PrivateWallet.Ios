//
//  PW_TokenDetailModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenDetailModel.h"

@implementation PW_TokenDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"hashStr":@"hash",
             @"fromAddress":@"from",
             @"toAddress":@"to",
    };
}

@end
