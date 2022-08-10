//
//  PW_NFTDetailPropertyCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NFTTraitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTDetailPropertyCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NFTTraitModel *model;

@end

NS_ASSUME_NONNULL_END
