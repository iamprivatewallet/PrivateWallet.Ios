//
//  ETHNode.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ETHNode : JSONModel

@property (strong, nonatomic) NSString<Optional> *node_name;
@property (strong, nonatomic) NSString<Optional> *node_url;
@property (strong, nonatomic) NSString<Optional> *node_net;
@property (strong, nonatomic) NSString<Optional> *node_des;
@property (strong, nonatomic) NSString<Optional> *err_code;
@property (strong, nonatomic) NSString<Optional> *is_def;
@property (strong, nonatomic) NSString<Optional> *customNode;
@property (strong, nonatomic) NSString<Optional> *msg;
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError **)err;
@end

NS_ASSUME_NONNULL_END
