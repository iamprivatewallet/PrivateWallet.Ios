//
//  PW_ConfirmPurchaseNFTAlertViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseAlertViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_ConfirmPurchaseNFTAlertViewController : PW_BaseAlertViewController

@property (nonatomic, copy) void(^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
