//
//  AssetCoinModel.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/19.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AssetCoinModel.h"

@implementation AssetCoinModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"coinId":@"id"};
}
@end
