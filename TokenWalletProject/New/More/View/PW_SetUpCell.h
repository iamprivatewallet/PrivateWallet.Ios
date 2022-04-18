//
//  PW_SetUpCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_SetUpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SetUpCell : PW_BaseTableCell

@property (nonatomic, strong) PW_SetUpModel *model;
@property (nonatomic, copy) void(^switchBlock)(PW_SetUpModel *model, BOOL isOn);

@end

NS_ASSUME_NONNULL_END
