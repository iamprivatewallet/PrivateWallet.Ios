//
//  AddressBookViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookViewController : BaseViewController

@property(nonatomic, assign) BOOL isChooseAddr;//是否是选择地址进来的

@property (nonatomic, copy) void(^chooseAddressBlock)(NSString *addr);

@end

NS_ASSUME_NONNULL_END
