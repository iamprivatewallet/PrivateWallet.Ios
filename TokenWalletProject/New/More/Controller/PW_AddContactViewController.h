//
//  PW_AddContactViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddContactViewController : PW_BaseViewController

@property (nonatomic, copy) void(^saveBlock)(PW_AddressBookModel *model);

@end

NS_ASSUME_NONNULL_END
