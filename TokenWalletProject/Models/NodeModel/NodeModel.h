//
//  NodeModel.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/2.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeModel : NSObject

@property (nonatomic, copy) NSString *node_name;
@property (nonatomic, copy) NSString *node_url;
@property (nonatomic, copy) NSString *node_chainID;
@property (nonatomic, copy) NSString *node_symbol;
@property (nonatomic, copy) NSString *node_browser;

@end

NS_ASSUME_NONNULL_END
