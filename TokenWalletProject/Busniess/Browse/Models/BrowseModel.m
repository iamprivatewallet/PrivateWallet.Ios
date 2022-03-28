//
//  BrowseModel.m
//  TokenWalletProject
//
//  Created by FChain on 2021/10/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BrowseModel.h"

@implementation BrowseModel

@end
@implementation BrowseRecordsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"appId":@"id",
             @"descriptionStr":@"description"
             
    };
}
@end
