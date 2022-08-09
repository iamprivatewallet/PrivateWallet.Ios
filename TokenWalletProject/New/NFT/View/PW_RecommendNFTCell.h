//
//  PW_RecommendNFTCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NFTCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_RecommendNFTCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NFTCollectionModel *model;

@end

NS_ASSUME_NONNULL_END
