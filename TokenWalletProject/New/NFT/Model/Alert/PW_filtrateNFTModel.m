//
//  PW_filtrateNFTModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_filtrateNFTModel.h"

@implementation PW_filtrateNFTModel

+ (instancetype)modelImageName:(NSString *)imageName title:(NSString *)title clickBlock:(void(^)(void))clickBlock {
    PW_filtrateNFTModel *model = [PW_filtrateNFTModel new];
    model.imageName = imageName;
    model.title = title;
    model.clickBlock = clickBlock;
    return model;
}

@end
