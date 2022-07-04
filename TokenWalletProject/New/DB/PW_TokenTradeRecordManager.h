//
//  PW_TokenTradeRecordManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/6.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_TokenDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_TokenTradeRecordManager : NSObject

+ (instancetype)shared;
- (void)saveRecord:(PW_TokenDetailModel *)record;
- (void)updateRecord:(PW_TokenDetailModel *)record;
- (void)deleteRecord:(PW_TokenDetailModel*)record;
- (void)deleteAll;
- (NSArray*)getWalletsWithAddress:(NSString *)address tokenAddr:(NSString *)tokenAddr;

@end

NS_ASSUME_NONNULL_END
