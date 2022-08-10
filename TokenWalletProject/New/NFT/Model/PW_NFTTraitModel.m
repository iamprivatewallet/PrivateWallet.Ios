//
//  PW_NFTTraitModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTTraitModel.h"

@implementation PW_NFTTraitModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tId":@"id"};
}

@end
