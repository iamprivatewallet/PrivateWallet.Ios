//
//  BrowseModel.h
//  TokenWalletProject
//
//  Created by FChain on 2021/10/13.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrowseModel : NSObject
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *current;
@property (nonatomic, copy) NSString *optimizeCountSql;
@property (nonatomic, copy) NSString *hitCount;
@property (nonatomic, copy) NSString *countId;
@property (nonatomic, copy) NSString *maxLimit;
@property (nonatomic, copy) NSString *searchCount;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSArray *orders;
@property (nonatomic, copy) NSArray *records;

@end

@interface BrowseRecordsModel : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *descriptionStr;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *appUrl;
@property (nonatomic, copy) NSString *firType;
@property (nonatomic, copy) NSString *secType;
@property (nonatomic, assign) NSInteger chainId;

@end

NS_ASSUME_NONNULL_END
