//
//  PW_WalletManageCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletManageCell : PW_BaseTableCell

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) Wallet *model;
@property (nonatomic, copy) void(^topBlock)(Wallet *model);

@end

NS_ASSUME_NONNULL_END
