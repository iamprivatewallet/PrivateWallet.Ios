//
//  PW_AppPwdLockView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/22.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_AppPwdLockView : UIView

@property (nonatomic, copy) void(^completeBlock)(PW_AppPwdLockView *view, BOOL success);
- (void)reset;

@end

NS_ASSUME_NONNULL_END
