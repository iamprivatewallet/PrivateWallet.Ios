//
//  PW_DappModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappModel : PW_BaseModel

@property (nonatomic, copy) NSString *dId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *appUrl;
@property (nonatomic, copy) NSString *firType;
@property (nonatomic, copy) NSString *secType;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, copy) NSString *languageCode;

@end

NS_ASSUME_NONNULL_END
