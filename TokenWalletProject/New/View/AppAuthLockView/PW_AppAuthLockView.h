//
//  PW_AppAuthLockView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/23.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_AppAuthLockView : UIView

@property (nonatomic, copy) void(^completeBlock)(PW_AppAuthLockView *view, BOOL success);
- (void)start;//begin auth
- (void)reset;

@end

NS_ASSUME_NONNULL_END
