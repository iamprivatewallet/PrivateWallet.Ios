//
//  PW_ShareTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ShareTool.h"
#import "PW_ShareViewModel.h"

@implementation PW_ShareTool

+ (void)shareTitle:(NSString *)title subTitle:(NSString *)subTitle data:(nullable id)data {
    [self shareIcon:[UIImage imageNamed:@"icon_logo"] title:title subTitle:subTitle data:data completionBlock:nil];
}
+ (void)shareTitle:(NSString *)title subTitle:(NSString *)subTitle data:(nullable id)data completionBlock:(nullable void(^)(BOOL completed))completionBlock {
    [self shareIcon:[UIImage imageNamed:@"icon_logo"] title:title subTitle:subTitle data:data completionBlock:completionBlock];
}
+ (void)shareIcon:(UIImage *)icon title:(NSString *)title subTitle:(NSString *)subTitle data:(nullable id)data completionBlock:(nullable void(^)(BOOL completed))completionBlock {
    PW_ShareModel *model = [PW_ShareModel modelWithShowIcon:icon title:title subTitle:subTitle data:data];
    PW_ShareViewModel *viewModel = [PW_ShareViewModel viewModelWithModel:model];
    NSArray *activityArray = @[viewModel];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completionBlock) {
            completionBlock(completed);
        }
        if (completed) {
            NSLog(@"completed");
            [PW_ToastTool showSucees:LocalizedStr(@"text_shareSuccess")];
        } else  {
            NSLog(@"cancled");
        }
    };
}

@end
