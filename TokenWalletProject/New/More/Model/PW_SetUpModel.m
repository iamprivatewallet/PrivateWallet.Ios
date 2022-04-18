//
//  PW_SetUpModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SetUpModel.h"

@implementation PW_SetUpModel
+ (instancetype)SetUpIconName:(NSString *)iconName title:(NSString *)title {
    PW_SetUpModel *model = [[PW_SetUpModel alloc] init];;
    model.iconName = iconName;
    model.title = title;
    return model;
}
+ (instancetype)SetUpIconName:(NSString *)iconName title:(NSString *)title desc:(NSString *)desc {
    PW_SetUpModel *model = [[PW_SetUpModel alloc] init];;
    model.iconName = iconName;
    model.title = title;
    model.desc = desc;
    return model;
}
+ (instancetype)SetUpIconName:(NSString *)iconName title:(NSString *)title isSwitch:(BOOL)isSwitch {
    PW_SetUpModel *model = [[PW_SetUpModel alloc] init];;
    model.iconName = iconName;
    model.title = title;
    model.isSwitch = isSwitch;
    return model;
}

@end
