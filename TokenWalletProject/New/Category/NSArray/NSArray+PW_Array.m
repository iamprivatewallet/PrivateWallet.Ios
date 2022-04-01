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
    NSArray *arr = self;
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x = arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return [newArr copy];
}

@end
