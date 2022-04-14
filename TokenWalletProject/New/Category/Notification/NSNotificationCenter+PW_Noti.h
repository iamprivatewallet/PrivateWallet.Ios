//
//  NSNotificationCenter+PW_Noti.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNotification+PW_Notification.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (PW_Noti)

- (void)addNotification:(NSNotification *)notification block:(PW_TargetBlock)block;

@end

NS_ASSUME_NONNULL_END
