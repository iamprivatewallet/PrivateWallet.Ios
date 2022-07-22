//
//  PW_PrisonBreakTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PrisonBreakTool.h"

@implementation PW_PrisonBreakTool

+ (BOOL)isPrisonBreak {
    BOOL status1 = [self isJailBreak1];
    BOOL status2 = [self isJailBreak2];
    BOOL status3 = [self isJailBreak3];
    if (status1 || status2 || status3) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isJailBreak1 {
#ifdef DEBUG
    NSArray *jailbreak_tool_paths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/etc/apt"
    ];
#else
    NSArray *jailbreak_tool_paths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt"
    ];
#endif
    for (int i=0; i<jailbreak_tool_paths.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
            NSLog(@"The device is jail broken!1");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!1");
    return NO;
}
+ (BOOL)isJailBreak2 {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!2");
        return YES;
    }
    NSLog(@"The device is NOT jail broken!2");
    return NO;
}
+ (BOOL)isJailBreak3 {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        NSLog(@"The device is jail broken!3");
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        NSLog(@"appList = %@", appList);
        return YES;
    }
    NSLog(@"The device is NOT jail broken!3");
    return NO;
}

@end
