//
//  PW_RedRoseGreenFellTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_RedRoseGreenFellTool.h"

static NSString * _Nonnull PW_RedRoseGreenFellKey = @"RedRoseGreenFellKey";

@implementation PW_RedRoseGreenFellTool

+ (void)setOpen:(BOOL)isOpen {
    if ([self isOpen]==isOpen) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kRedRoseGreenFellNotification object:nil];
    [[NSUserDefaults standardUserDefaults] setBool:isOpen forKey:PW_RedRoseGreenFellKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isOpen {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PW_RedRoseGreenFellKey];
}

+ (void)clear {
    [self setOpen:NO];
}

@end
