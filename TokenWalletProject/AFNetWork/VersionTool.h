//
//  VersionTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/22.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionTool : NSObject

+ (void)requestAppVersion;
+ (void)requestAppVersionUserTake:(BOOL)userTake completeBlock:(void(^ _Nullable)(BOOL isShow))completeBlock;

@end

NS_ASSUME_NONNULL_END
