//
//  PW_AddCustomNetworkViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddCustomNetworkViewController : PW_BaseViewController

@property (nonatomic, strong) PW_NetworkModel *model;
@property (nonatomic, copy) void(^saveBlock)(PW_NetworkModel *model);

@end

NS_ASSUME_NONNULL_END
