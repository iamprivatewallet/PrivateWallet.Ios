//
//  PW_MarketMenuModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MarketMenuModel.h"

@implementation PW_MarketMenuModel

+ (instancetype)ModelTitle:(NSString *)title {
    PW_MarketMenuModel *model = [[PW_MarketMenuModel alloc] init];
    model.title = title;
    return model;
}

@end
