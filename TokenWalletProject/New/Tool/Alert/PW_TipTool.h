//
//  PW_TipTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_DappMoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TipTool : NSObject

+ (void)showBackupTipSureBlock:(void (^)(void))block;
+ (void)showBackupTipPrivateKeySureBlock:(void (^)(void))block;
+ (void)showBackupTipDesc:(NSString *)desc sureBlock:(void (^)(void))block;
+ (void)showPayPwdSureBlock:(void (^)(NSString *pwd))block;
/// dapp钱包不支持
+ (void)showDappWalletNotSupportedWithModel:(PW_DappModel *)model sureBlock:(void(^)(void))block;
/// dapp免责声明
+ (void)showDappDisclaimerUrlStr:(NSString *)urlStr sureBlock:(void(^)(void))block;
/// dapp
+ (void)showDappMoreTitle:(NSString *)title dataArr:(NSArray<PW_DappMoreModel *> *)dataArr sureBlock:(void(^)(PW_DappMoreModel *model))block;

@end

NS_ASSUME_NONNULL_END
