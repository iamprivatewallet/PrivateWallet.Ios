//
//  PW_AllNftFiltrateCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_AllNftFiltrateGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_AllNftFiltrateCell : PW_BaseTableCell

@property (nonatomic, strong) PW_AllNftFiltrateGroupModel *model;
@property (nonatomic, copy) void(^clickBlock)(PW_AllNftFiltrateGroupModel *groupModel, PW_AllNftFiltrateItemModel *model);

@end

NS_ASSUME_NONNULL_END
