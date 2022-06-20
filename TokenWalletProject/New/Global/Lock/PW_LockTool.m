//
//  PW_LockTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_LockTool.h"

static NSString * _Nonnull PW_UnlockPwdKey = @"UnlockPwdKey";
static NSString * _Nonnull PW_UnlockAppTransactionKey = @"UnlockAppTransactionKey";

@implementation PW_LockTool

+ (void)setUnlockPwd:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:PW_UnlockPwdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getUnlockPwd {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PW_UnlockPwdKey];
}

+ (void)setUnlockAppTransaction:(BOOL)open {
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:PW_UnlockAppTransactionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)getUnlockAppTransaction {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PW_UnlockAppTransactionKey];
}

@end
