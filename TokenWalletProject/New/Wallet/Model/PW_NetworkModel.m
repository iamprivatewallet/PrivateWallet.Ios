//
//  PW_NetworkModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NetworkModel.h"

@implementation PW_NetworkModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nId":@"id"};
}

@end
