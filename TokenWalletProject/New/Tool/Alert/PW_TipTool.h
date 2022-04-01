//
//  PW_TipTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_TipTool : NSObject

+ (void)showBackupTipSureBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
