//
//  PW_DappChainCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_DappModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappChainCell : PW_BaseTableCell

@property (nonatomic, copy) NSArray<PW_DappModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(PW_DappModel *model);

@end

NS_ASSUME_NONNULL_END
