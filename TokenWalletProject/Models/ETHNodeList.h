//
//  ETHNodeList.h
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "JSONModel.h"
#import "ETHNode.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ETHNode;

@interface ETHNodeList : JSONModel

@property (strong, nonatomic) NSArray<ETHNode> *main_net;
@property (strong, nonatomic) NSArray<ETHNode> *test_net;
@property (strong, nonatomic) NSArray<ETHNode> *dev_net;
@property (strong, nonatomic) NSString<Optional> *err_code;
@property (strong, nonatomic) NSString<Optional> *msg;
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError **)err;
@end

NS_ASSUME_NONNULL_END
