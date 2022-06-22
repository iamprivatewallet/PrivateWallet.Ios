//
//  PW_LockTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_LockTool.h"

static NSString * _Nonnull PW_UnlockAppPwdKey = @"UnlockAppPwdKey";
static NSString * _Nonnull PW_UnlockAppPwdErrorCountKey = @"UnlockAppPwdErrorCountKey";
static NSString * _Nonnull PW_OpenUnlockAppPwdKey = @"OpenUnlockAppPwdKey";
static NSString * _Nonnull PW_UnlockAppTransactionKey = @"UnlockAppTransactionKey";

@implementation PW_LockTool

+ (void)setOpenUnlockPwd:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:PW_OpenUnlockAppPwdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getOpenUnlockPwd {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PW_OpenUnlockAppPwdKey];
}
+ (void)setUnlockPwdErrorCount:(NSInteger)count {
    [[NSUserDefaults standardUserDefaults] setInteger:MIN(MAX(0,count),PW_AppPwdUnlockErrorMaxCount) forKey:PW_UnlockAppPwdErrorCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)getUnlockPwdErrorCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PW_UnlockAppPwdErrorCountKey];
}
+ (NSString *)getUnlockPwdErrorStr {
    return NSStringWithFormat(LocalizedStr(@"text_unlockPwdErrorTip"),@(PW_AppPwdUnlockErrorMaxCount-[self getUnlockPwdErrorCount]).stringValue);
}
+ (void)deductUnlockPwd {
    NSInteger count = [self getUnlockPwdErrorCount]+1;
    [self setUnlockPwdErrorCount:count];
}
+ (BOOL)hasUnlockPwd {
    if ([self getUnlockPwdErrorCount]>=PW_AppPwdUnlockErrorMaxCount) {
        return NO;
    }
    return YES;
}
+ (void)resetUnlockPwd {
    [self setUnlockPwdErrorCount:0];
}

+ (void)setUnlockPwd:(NSString *)pwd {
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:PW_UnlockAppPwdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUnlockPwd {
    return [[NSUserDefaults standardUserDefaults] stringForKey:PW_UnlockAppPwdKey];
}

+ (void)setUnlockAppTransaction:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:PW_UnlockAppTransactionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getUnlockAppTransaction {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PW_UnlockAppTransactionKey];
}

+ (void)clear {
    [PW_LockTool setUnlockPwd:@""];
    [PW_LockTool setOpenUnlockPwd:NO];
    [PW_LockTool setUnlockPwdErrorCount:0];
    [PW_LockTool setUnlockAppTransaction:NO];
}

@end
