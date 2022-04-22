//
//  PW_DappMoreModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappMoreModel.h"

@implementation PW_DappMoreModel

+ (instancetype)ModelIconName:(NSString *)iconName title:(NSString *)title actionBlock:(void(^)(PW_DappMoreModel *model))actionBlock {
    PW_DappMoreModel *model = [[PW_DappMoreModel alloc] init];
    model.iconName = iconName;
    model.title = title;
    model.actionBlock = actionBlock;
    return model;
}

@end
