//
//  PW_ConfirmBackupViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_ConfirmBackupViewController : PW_BaseViewController

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, copy) NSString *wordStr;
@property (nonatomic, strong) Wallet *wallet;

@end

NS_ASSUME_NONNULL_END
