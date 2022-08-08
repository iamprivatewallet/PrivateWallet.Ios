//
//  PW_WalletNFTCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NFTCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_WalletNFTCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NFTCollectionModel *model;

@end

NS_ASSUME_NONNULL_END
