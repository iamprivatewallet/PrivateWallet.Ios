//
//  NSArray+PW_Array.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/1.
//  Copyright © 2022 . All rights reserved.
//

#import "NSArray+PW_Array.h"

@implementation NSArray (PW_Array)

- (NSArray *)random {
    // 转为可变数组
    NSMutableArray * tmp = self.mutableCopy;
    // 获取数组长度
    NSInteger count = tmp.count;
    // 开始循环
    while (count > 0) {
        // 获取随机角标
        NSInteger index = arc4random_uniform((int)(count - 1));
        // 获取角标对应的值
        id value = tmp[index];
        // 交换数组元素位置
        tmp[index] = tmp[count - 1];
        tmp[count - 1] = value;
        count--;
    }
    // 返回打乱顺序之后的数组
    return tmp.copy;
}

@end
