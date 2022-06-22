//
//  PW_LockTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/20.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger PW_AppPwdUnlockErrorMaxCount = 5;

NS_ASSUME_NONNULL_BEGIN

@interface PW_LockTool : NSObject

+ (void)setOpenUnlockPwd:(BOOL)open;
+ (BOOL)getOpenUnlockPwd;
+ (void)setUnlockPwdErrorCount:(NSInteger)count;//错误次数
+ (NSInteger)getUnlockPwdErrorCount;
+ (NSString *)getUnlockPwdErrorStr;
+ (void)deductUnlockPwd;//扣除一次
+ (BOOL)hasUnlockPwd;//是否还有次数
+ (void)resetUnlockPwd;//重置次数

+ (void)setUnlockPwd:(NSString *)pwd;
+ (NSString *)getUnlockPwd;

+ (void)setUnlockAppTransaction:(BOOL)open;
+ (BOOL)getUnlockAppTransaction;

+ (void)clear;

@end

NS_ASSUME_NONNULL_END
