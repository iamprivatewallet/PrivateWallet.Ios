//
//  PW_AuthenticationTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/5/6.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_AuthenticationTool : NSObject

+ (LAContext *)showWithDesc:(NSString *)desc reply:(void(^)(BOOL success,NSError *error))block;
+ (LAContext *)isSupportBiometrics;
+ (NSError *)supportBiometricsError;

@end

NS_ASSUME_NONNULL_END
