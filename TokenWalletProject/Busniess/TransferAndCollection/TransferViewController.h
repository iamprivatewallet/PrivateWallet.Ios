//
//  TransferViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/12.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferViewController : BaseViewController
@property (nonatomic, strong) WalletCoinModel *coinModel;

@property (nonatomic, strong) ScanCodeInfoModel *codeInfoModel;

@property (nonatomic, copy) void(^transferSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
