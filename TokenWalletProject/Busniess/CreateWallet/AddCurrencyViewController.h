//
//  AddCurrencyViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/22.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCurrencyViewController : BaseViewController
@property(nonatomic, assign) BOOL isFirstBackup;//是否第一次备份
@property(nonatomic, assign) BOOL isRecoveryPage;//是否来自恢复身份页
@property(nonatomic, assign) BOOL isAddCurrency;//是否为添加币种

@end

NS_ASSUME_NONNULL_END
