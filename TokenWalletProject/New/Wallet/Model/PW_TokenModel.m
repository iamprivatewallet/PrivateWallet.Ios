//
//  PW_TokenModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/3.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_TokenModel.h"

@implementation PW_TokenModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tId":@"id"};
}

@end
