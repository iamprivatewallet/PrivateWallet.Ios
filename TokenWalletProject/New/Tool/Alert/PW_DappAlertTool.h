//
//  PW_DappAlertTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_DappPayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappAlertTool : NSObject

+ (void)showDappAuthorizationConfirm:(PW_DappPayModel *)model sureBlock:(void(^)(PW_DappPayModel *model))block;
+ (void)showDappConfirmPayInfo:(PW_DappPayModel *)model sureBlock:(void(^)(PW_DappPayModel *model))block;
+ (void)showDappMaxAuthorizationCountSureBlock:(void(^)(NSString *count))block;
+ (void)showDappConfirmGas:(PW_GasModel *)model sureBlock:(void(^)(PW_GasModel *model))block;

@end

NS_ASSUME_NONNULL_END
