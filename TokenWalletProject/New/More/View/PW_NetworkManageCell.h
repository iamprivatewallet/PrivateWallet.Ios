//
//  PW_NetworkManageCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/19.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NetworkManageCell : PW_BaseTableCell

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) PW_NetworkModel *model;
@property (nonatomic, copy) void(^topBlock)(PW_NetworkModel *model);

@end

NS_ASSUME_NONNULL_END
