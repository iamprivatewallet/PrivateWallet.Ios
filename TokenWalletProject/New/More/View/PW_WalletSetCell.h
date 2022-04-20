//
//  PW_WalletSetCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_WalletSetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletSetCell : PW_BaseTableCell

@property (nonatomic, strong) PW_WalletSetModel *model;

@end

NS_ASSUME_NONNULL_END
