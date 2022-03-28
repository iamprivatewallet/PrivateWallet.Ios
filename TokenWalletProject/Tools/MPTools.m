
//
//  MPTools.m
//  MPay
//
//  Created by MM on 2020/5/22.
//  Copyright © 2020 MM. All rights reserved.
//

#import "MPTools.h"

@implementation MPTools


+(UINavigationController *)appRootViewController{
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return nil;
}




@end
