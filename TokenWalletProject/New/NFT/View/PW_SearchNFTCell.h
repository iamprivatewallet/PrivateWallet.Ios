//
//  PW_SearchNFTCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"
#import "PW_NFTCollectionModel.h"
#import "PW_NFTAccountModel.h"
#import "PW_NFTItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchNFTCell : PW_BaseTableCell

@property (nonatomic, strong) PW_NFTCollectionModel *collectionModel;
@property (nonatomic, strong) PW_NFTAccountModel *accountModel;
@property (nonatomic, strong) PW_NFTItemModel *itemModel;

@end

NS_ASSUME_NONNULL_END
