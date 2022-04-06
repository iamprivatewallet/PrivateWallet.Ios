//
//  PW_TokenDetailCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/6.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_TokenDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TokenDetailCell : PW_BaseTableCell

@property (nonatomic, strong) PW_TokenDetailModel *model;

@end

NS_ASSUME_NONNULL_END
