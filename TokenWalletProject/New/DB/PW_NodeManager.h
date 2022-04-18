//
//  PW_NodeManager.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PW_NetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_NodeManager : NSObject

+ (instancetype)shared;
- (void)saveNodeModel:(PW_NetworkModel *)model;
- (BOOL)updateNode:(PW_NetworkModel *)model;
- (void)deleteNodeModel:(PW_NetworkModel *)model;
- (NSArray<PW_NetworkModel *> *)getNodeListWithChainId:(NSString *)chainId;
- (nullable PW_NetworkModel *)getSelectedNodeWithChainId:(NSString *)chainId;

@end

NS_ASSUME_NONNULL_END
