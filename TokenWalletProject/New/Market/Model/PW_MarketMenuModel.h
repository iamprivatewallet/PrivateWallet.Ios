//
//  PW_MarketMenuModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
#import "PW_MarketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MarketMenuModel : PW_BaseModel

+ (instancetype)ModelTitle:(NSString *)title;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray<PW_MarketModel *> *dataArr;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
