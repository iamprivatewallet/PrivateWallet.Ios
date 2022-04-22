//
//  PW_MarketModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MarketModel : PW_BaseModel

@property (nonatomic, copy) NSString *amout;
@property (nonatomic, copy) NSString *mId;
@property (nonatomic, copy) NSString *last;
@property (nonatomic, copy) NSString *lastVol;
@property (nonatomic, copy) NSString *rose;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) NSTimeInterval updateTime;

@property (nonatomic, assign) BOOL collection;

@end

NS_ASSUME_NONNULL_END
