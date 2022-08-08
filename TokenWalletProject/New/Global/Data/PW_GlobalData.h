//
//  PW_GlobalData.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/15.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_TokenModel.h"
#import "PW_NFTClassifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_GlobalData : NSObject

+ (instancetype)shared;
@property (nonatomic, strong) NSMutableArray<PW_TokenModel *> *coinList;
@property (nonatomic, strong) PW_TokenModel *mainTokenModel;
- (void)updateCoinList:(NSArray<PW_TokenModel *> *)coinList;

@property (nonatomic, strong) NSArray<PW_NFTClassifyModel *> *nftClassifyArr;

@end

NS_ASSUME_NONNULL_END
