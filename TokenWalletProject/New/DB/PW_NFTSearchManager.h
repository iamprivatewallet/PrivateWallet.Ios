//
//  PW_NFTSearchManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/9.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
@class PW_NFTSearchDBModel;

NS_ASSUME_NONNULL_BEGIN

@interface PW_NFTSearchManager : NSObject

+ (instancetype)shared;
- (void)saveModel:(PW_NFTSearchDBModel *)model;
- (BOOL)deleteAll;
- (NSArray<PW_NFTSearchDBModel *> *)getList;
- (nullable PW_NFTSearchDBModel *)isExistWithSearch:(NSString *)search;

@end

@interface PW_NFTSearchDBModel : NSObject

@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
