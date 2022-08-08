//
//  PW_NFTTokenModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/8.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTTokenModel.h"

@implementation PW_NFTTokenModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tId":@"id"};
}

@end
