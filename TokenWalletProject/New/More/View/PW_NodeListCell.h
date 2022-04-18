//
//  PW_NodeListCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NodeListCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NetworkModel *model;

@end

NS_ASSUME_NONNULL_END
