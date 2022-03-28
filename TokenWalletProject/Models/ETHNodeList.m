//
//  ETHNodeList.m
//  FunnyProject
//
//  Created by jinkh on 2018/12/23.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import "ETHNodeList.h"

@implementation ETHNodeList
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError **)err{
    self = [self init];
    if (self) {//是否初始化成功
        _main_net = [self setArray:dict Key:@"main_net"];
        _dev_net = [self setArray:dict Key:@"dev_net"];
        _test_net = [self setArray:dict Key:@"test_net"];
        _msg = dict[@"msg"];
        _err_code = dict[@"err_code"];
    }
    return self;
}
-(NSArray<ETHNode> *)setArray:(NSDictionary *)dict Key:(NSString *)key{
    NSArray<ETHNode> *array;
    if([[dict allKeys] containsObject:key])
    {
        return dict[key];
    }else{
        return array;
    }
}
@end
