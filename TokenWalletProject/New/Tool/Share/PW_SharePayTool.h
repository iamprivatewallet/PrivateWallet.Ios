//
//  PW_SharePayTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SharePayTool : NSObject

+ (void)showPayMeViewWithAddress:(NSString *)address name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
