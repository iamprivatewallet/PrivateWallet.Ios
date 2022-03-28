//
//  TokenChainModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/17.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "TokenChainModel.h"

@implementation TokenChainModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dappList":[BrowseRecordsModel class]};
}

@end
