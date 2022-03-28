//
//  TokenChainModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/17.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrowseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TokenChainModel : NSObject

@property (nonatomic, copy) NSString *cId;
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *rpcUrl;
@property (nonatomic, copy) NSString *browseUrl;
@property (nonatomic, copy) NSString *backUrl;
@property (nonatomic, copy) NSArray<BrowseRecordsModel *> *dappList;

@end

NS_ASSUME_NONNULL_END
