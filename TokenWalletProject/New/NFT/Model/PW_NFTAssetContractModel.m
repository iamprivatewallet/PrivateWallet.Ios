//
//  PW_NFTAssetContractModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/10.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTAssetContractModel.h"

@implementation PW_NFTAssetContractModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"cId":@"id"};
}

@end
