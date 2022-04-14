//
//  NSNotification+PW_Notification.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PW_TargetBlock)(NSNotification * _Nonnull notification);

NS_ASSUME_NONNULL_BEGIN

@interface NSNotification (PW_Notification)

- (void)setTargetBlock:(PW_TargetBlock)targetBlock;
- (void)notificationAction:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
