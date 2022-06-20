//
//  PW_LockTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/20.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_LockTool : NSObject

+ (void)setUnlockPwd:(BOOL)open;
+ (BOOL)getUnlockPwd;

+ (void)setUnlockAppTransaction:(BOOL)open;
+ (BOOL)getUnlockAppTransaction;

@end

NS_ASSUME_NONNULL_END
