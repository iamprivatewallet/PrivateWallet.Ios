//
//  PW_ScanTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_ScanTool : NSObject

+ (instancetype)shared;
- (void)showScanWithResultBlock:(void(^)(NSString *result))resultBlock;

@end

NS_ASSUME_NONNULL_END
