//
//  PW_RankListNFTCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NFTTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_RankListNFTCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NFTTokenModel *model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^seriesBlock)(PW_NFTTokenModel *model);

@end

NS_ASSUME_NONNULL_END
