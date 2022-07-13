//
//  PW_SearchDappCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_DappModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchDappCell : PW_BaseTableCell

@property (nonatomic, strong) PW_DappModel *model;

@end

NS_ASSUME_NONNULL_END
