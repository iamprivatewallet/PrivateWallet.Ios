//
//  MinersfeeSettingVC.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MinersfeeSettingVC : BaseTableViewController
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) CurrentGasPriceModel *currentGasModel;
@property(nonatomic, assign) BOOL isDAppsPush;
@property (nonatomic, copy) void(^chooseGasPriceBlock)(GasPriceModel *gasPriceModel);
@end

NS_ASSUME_NONNULL_END
