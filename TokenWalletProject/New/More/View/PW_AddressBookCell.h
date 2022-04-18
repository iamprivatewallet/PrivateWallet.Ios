//
//  PW_AddressBookCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AddressBookCell : PW_BaseTableCell

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) PW_AddressBookModel *model;
@property (nonatomic, copy) void(^deleteBlock)(PW_AddressBookModel *model);

@end

NS_ASSUME_NONNULL_END
