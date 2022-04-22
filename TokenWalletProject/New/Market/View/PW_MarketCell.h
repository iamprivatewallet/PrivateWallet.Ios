//
//  PW_MarketCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_MarketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MarketCell : PW_BaseTableCell

@property (nonatomic, strong) PW_MarketModel *model;
@property (nonatomic, copy) void(^collectionBlock)(PW_MarketModel *model);

@end

NS_ASSUME_NONNULL_END
