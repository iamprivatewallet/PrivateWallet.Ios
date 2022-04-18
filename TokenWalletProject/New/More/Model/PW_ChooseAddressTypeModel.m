//
//  PW_ChooseAddressTypeModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ChooseAddressTypeModel.h"

@implementation PW_ChooseAddressTypeModel

+ (instancetype)IconName:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle chainId:(NSString *)chainId selected:(BOOL)selected {
    PW_ChooseAddressTypeModel *model = [[PW_ChooseAddressTypeModel alloc] init];
    model.iconName = iconName;
    model.title = title;
    model.subTitle = subTitle;
    model.selected = selected;
    model.chainId = chainId;
    return model;
}

@end
