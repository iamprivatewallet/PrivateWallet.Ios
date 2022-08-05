//
//  PW_MoreAlertModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MoreAlertModel.h"

@implementation PW_MoreAlertModel

+ (instancetype)modelIconName:(NSString *)iconName title:(NSString *)title didClick:(void(^)(PW_MoreAlertModel *model))didClick {
    PW_MoreAlertModel *model = [[PW_MoreAlertModel alloc] init];
    model.iconName = iconName;
    model.title = title;
    model.didClick = didClick;
    return model;
}

@end
