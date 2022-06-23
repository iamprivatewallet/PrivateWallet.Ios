//
//  PW_DappBrowserModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
#import "PW_DappModel.h"
#import "PW_BannerModel.h"
#import "PW_DappChainBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappBrowserModel : PW_BaseModel

@property (nonatomic, copy) NSArray<PW_DappModel *> *dapp;
@property (nonatomic, copy) NSArray<PW_DappModel *> *dappTop;
@property (nonatomic, copy) NSArray<PW_BannerModel *> *banner_1_1;
@property (nonatomic, copy) NSArray<PW_BannerModel *> *banner_2_2;
@property (nonatomic, copy) NSArray<PW_BannerModel *> *banner_2_3;
@property (nonatomic, copy) NSArray<PW_DappChainBrowserModel *> *browser;

@end

NS_ASSUME_NONNULL_END
