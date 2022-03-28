//
//  AddNewAddressVC.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddNewAddressVC : BaseTableViewController
@property(nonatomic, assign) BOOL isEditAddr;//编辑地址
@property(nonatomic, assign) BOOL isScanCodeAddr;//扫码添加地址

@property(nonatomic, strong) ChooseCoinTypeModel *chooseModel;

@property (nonatomic, copy) void(^editAddressBlock)(void);

@end

NS_ASSUME_NONNULL_END
