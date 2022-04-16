//
//  PW_CurrencyManageCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_CurrencyManageCell : PW_BaseTableCell

@property (nonatomic, strong) PW_TokenModel *model;
@property (nonatomic, copy) void(^topBlock)(PW_TokenModel *model);

@end

NS_ASSUME_NONNULL_END
