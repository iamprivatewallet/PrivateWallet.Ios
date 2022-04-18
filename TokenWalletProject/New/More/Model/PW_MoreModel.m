//
//  PW_MoreModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreModel.h"

@implementation PW_GroupMoreModel

@end

@implementation PW_MoreModel

+ (instancetype)MoreIconName:(NSString *)iconName title:(NSString *)title actionBlock:(void(^)(PW_MoreModel *model))actionBlock {
    PW_MoreModel *model = [[PW_MoreModel alloc] init];
    model.iconName = iconName;
    model.title = title;
    model.actionBlock = actionBlock;
    return model;
}

@end
