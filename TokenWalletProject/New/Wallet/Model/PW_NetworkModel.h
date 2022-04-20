//
//  PW_NetworkModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/11.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NetworkModel : PW_BaseModel

@property (nonatomic, copy) NSString *nId;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *rpcUrl;
@property (nonatomic, copy) NSString *browseUrl;
@property (nonatomic, copy) NSString *backUrl;

@property (nonatomic, assign) NSInteger sortIndex;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
