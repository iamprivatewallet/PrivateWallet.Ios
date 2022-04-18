//
//  PW_NodeSetCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NodeSetCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NetworkModel *model;

@end

NS_ASSUME_NONNULL_END