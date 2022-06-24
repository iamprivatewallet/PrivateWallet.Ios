//
//  PW_SDImageTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/24.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SDImageTool.h"
#import <SDWebImage/SDImageCache.h>

@implementation PW_SDImageTool

+ (void)setup {
    [SDImageCache sharedImageCache].config.maxDiskAge = 3*24*3600;//3 day
}
+ (void)clear {
//    float tmpSize = [[SDImageCache sharedImageCache] totalDiskSize];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}


@end