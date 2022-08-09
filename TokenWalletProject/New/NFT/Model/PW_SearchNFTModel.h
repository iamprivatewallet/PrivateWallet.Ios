//
//  PW_SearchNFTModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/9.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
#import "PW_NFTCollectionModel.h"
#import "PW_NFTAccountModel.h"
#import "PW_NFTItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchNFTModel : PW_BaseModel

@property (nonatomic, copy) NSArray<PW_NFTCollectionModel *> *collections;
@property (nonatomic, copy) NSArray<PW_NFTAccountModel *> *accounts;
@property (nonatomic, copy) NSArray<PW_NFTItemModel *> *items;

@end

NS_ASSUME_NONNULL_END
