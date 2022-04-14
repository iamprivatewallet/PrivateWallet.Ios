//
//  PW_DappModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappModel.h"

@implementation PW_DappModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"dId":@"id",@"desc":@"description"};
}

@end
