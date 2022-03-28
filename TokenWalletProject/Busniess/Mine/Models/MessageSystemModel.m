//
//  MessageSystemModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "MessageSystemModel.h"

@implementation MessageSystemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"mid":@"id"};
}

@end
