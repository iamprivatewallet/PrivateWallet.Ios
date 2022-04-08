//
//  PW_ShareTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ShareTool.h"

@implementation PW_ShareTool

+ (void)shareTitle:(NSString *)title iamge:(UIImage *)image urlStr:(NSString *)urlStr {
    NSURL *urlToShare = [NSURL URLWithString:urlStr];
    NSMutableArray *activityArray = [NSMutableArray array];
    if([title isNoEmpty]){
        [activityArray addObject:title];
    }
    if(image){
        [activityArray addObject:image];
    }
    if(urlToShare){
        [activityArray addObject:urlToShare];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:activityVC animated:YES completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            [PW_ToastTool showSucees:LocalizedStr(@"text_success")];
        } else  {
            NSLog(@"cancled");
        }
    };
}

@end
