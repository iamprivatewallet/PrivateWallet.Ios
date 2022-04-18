//
//  PW_NodeListViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NodeListViewController : PW_BaseViewController

@property (nonatomic, strong) PW_NetworkModel *model;
@property (nonatomic, copy) void(^changeBlock)(PW_NetworkModel *model);

@end

NS_ASSUME_NONNULL_END
