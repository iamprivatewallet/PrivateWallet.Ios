//
//  PW_MoreCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_MoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MoreCell : PW_BaseTableCell

@property (nonatomic, strong) NSArray<PW_MoreModel *> *dataArr;

@end

NS_ASSUME_NONNULL_END
