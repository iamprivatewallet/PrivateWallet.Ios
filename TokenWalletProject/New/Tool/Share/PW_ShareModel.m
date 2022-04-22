//
//  PW_ShareModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ShareModel.h"

@implementation PW_ShareModel

+ (instancetype)modelWithShowIcon:(UIImage *)showIcon title:(NSString *)title subTitle:(NSString *)subTitle data:(id)data {
    PW_ShareModel *model = [[PW_ShareModel alloc] init];
    model.showIcon = showIcon;
    model.showTitle = title;
    model.showSubTitle = subTitle;
    model.data = data;
    return model;
}

@end
