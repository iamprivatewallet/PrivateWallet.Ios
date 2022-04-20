//
//  PW_WalletSetModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_WalletSetModel.h"

@implementation PW_WalletSetModel

+ (instancetype)ModelIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc actionBlock:(void(^)(PW_WalletSetModel *model))actionBlock {
    PW_WalletSetModel *model = [[PW_WalletSetModel alloc] init];
    model.iconName = iconName;
    model.title = title;
    model.desc = desc;
    model.actionBlock = actionBlock;
    return model;
}

@end
