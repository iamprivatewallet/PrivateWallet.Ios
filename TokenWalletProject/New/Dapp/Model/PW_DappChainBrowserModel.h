//
//  PW_DappChainBrowserModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappChainBrowserModel : PW_BaseModel

@property (nonatomic, copy) NSString *bId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *appUrl;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *languageCode;

@end

NS_ASSUME_NONNULL_END
