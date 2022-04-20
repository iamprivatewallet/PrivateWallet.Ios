//
//  PW_WalletViewCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletViewCell : PW_BaseTableCell

@property (nonatomic, strong) Wallet *wallet;

@end

NS_ASSUME_NONNULL_END
