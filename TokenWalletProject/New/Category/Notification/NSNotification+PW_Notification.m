//
//  NSNotification+PW_Notification.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import "NSNotification+PW_Notification.h"
#import <objc/runtime.h>

static void * eventsBlockKey = &eventsBlockKey;

@interface NSNotification ()

@property (nonatomic, copy) PW_TargetBlock targetBlock;

@end

@implementation NSNotification (PW_Notification)

- (PW_TargetBlock)targetBlock {
    return objc_getAssociatedObject(self, &eventsBlockKey);
}
- (void)setTargetBlock:(PW_TargetBlock)targetBlock {
    objc_setAssociatedObject(self, &eventsBlockKey, targetBlock, OBJC_ASSOCIATION_COPY);
}
- (void)notificationAction:(NSNotification *)notification {
    if (self.targetBlock) {
        self.targetBlock(notification);
    }
}

@end
