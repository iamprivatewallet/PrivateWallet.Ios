//
//  PW_AuthenticationTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/5/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AuthenticationTool.h"

@implementation PW_AuthenticationTool

+ (LAContext *)showWithDesc:(NSString *)desc reply:(void(^)(BOOL success,NSError *error))block {
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    BOOL canAuthentication = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (canAuthentication) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:desc reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block) {
                    block(success,error);
                }
            });
        }];
    }else{
        if(block) {
            block(NO,error);
        }
    }
    return context;
}
+ (LAContext *)isSupportBiometrics {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        return context;
    }
    return nil;
}
+ (NSError *)supportBiometricsError {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        return nil;
    }
    return error;
}

@end
