//
//  PW_GlobalData.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_GlobalData : NSObject

+ (instancetype)shared;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *coinList;
- (void)updateCoinList:(NSArray<PW_TokenModel *> *)coinList;

@end

NS_ASSUME_NONNULL_END
