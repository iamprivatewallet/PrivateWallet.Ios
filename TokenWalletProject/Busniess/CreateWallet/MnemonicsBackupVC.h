//
//  MnemonicsBackupVC.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/23.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicsBackupVC : BaseViewController
@property(nonatomic, assign) BOOL isFirstBackup;
@property (nonatomic, strong) Wallet *wallet;

@end

NS_ASSUME_NONNULL_END
