//
//  NSNotificationCenter+PW_Noti.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "NSNotificationCenter+PW_Noti.h"

@interface NSNotificationCenter ()

@end

@implementation NSNotificationCenter (PW_Noti)

- (void)addNotification:(NSNotification *)notification block:(PW_TargetBlock)block {
    [notification setTargetBlock:block];
    [self addObserver:notification selector:@selector(notificationAction:) name:notification.name object:nil];
}

@end
