//
//  PW_MoreModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreModel.h"

@implementation PW_MoreModel

+ (instancetype)MoreIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc actionBlock:(void(^)(PW_MoreModel *model))actionBlock {
    PW_MoreModel *model = [[PW_MoreModel alloc] init];
    model.iconName = iconName;
    model.title = title;
    model.desc = desc;
    model.actionBlock = actionBlock;
    return model;
}
+ (instancetype)MoreIconName:(NSString *)iconName title:(NSString *)title actionBlock:(void(^)(PW_MoreModel *model))actionBlock {
    return [self MoreIconName:iconName title:title desc:nil actionBlock:actionBlock];
}

@end
