//
//  PW_PendingAlertViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseAlertViewController.h"

typedef NS_ENUM(NSUInteger, PW_PendingAlertType) {
    PW_PendingAlertPending=0,
    PW_PendingAlertSuccess,
    PW_PendingAlertError,
};

NS_ASSUME_NONNULL_BEGIN

@interface PW_PendingAlertViewController : PW_BaseAlertViewController

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
