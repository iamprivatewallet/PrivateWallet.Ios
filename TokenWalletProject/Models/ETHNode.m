//
//  ETHNode.m
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "ETHNode.h"

@implementation ETHNode
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError **)err{
    self = [self init];
    if (self) {//是否初始化成功
        _node_des = dict[@"node_des"];
        _node_net = dict[@"node_net"];
        _node_url = dict[@"node_url"];
        NSString *newNode_name = [self setcustomNode:dict Key:@"node_name"];
        if (newNode_name.length > 0) {
           _node_name = [newNode_name substringWithRange:NSMakeRange(0, 3)];
        }
        _is_def = [NSString stringWithFormat:@"%@",dict[@"is_def"]];
        _customNode = [self setcustomNode:dict Key:@"customNode"];
        _msg = dict[@"msg"];
        _err_code = dict[@"err_code"];
    }
    return self;
}
-(NSString *)setcustomNode:(NSDictionary *)dict Key:(NSString *)key{
    if([[dict allKeys] containsObject:key])
    {
        return dict[key];
    }else{
        return @"";
    }
}
@end
