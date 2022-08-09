//
//  PW_AllNftFiltrateGroupModel.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AllNftFiltrateGroupModel.h"

@implementation PW_AllNftFiltrateGroupModel

+ (instancetype)modelTitle:(NSString *)title key:(NSString *)key items:(NSArray<PW_AllNftFiltrateItemModel *> *)items {
    PW_AllNftFiltrateGroupModel *model = [PW_AllNftFiltrateGroupModel new];
    model.title = title;
    model.key = key;
    model.items = items;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    PW_AllNftFiltrateGroupModel *model = [PW_AllNftFiltrateGroupModel allocWithZone:zone];
    model.title = _title;
    model.key = _key;
    NSMutableArray *array = [NSMutableArray array];
    for (PW_AllNftFiltrateItemModel *old in _items) {
        [array addObject:[old mutableCopy]];
    }
    model.items = [array copy];
    return model;
}

@end

@implementation PW_AllNftFiltrateItemModel

+ (instancetype)modelTitle:(NSString *)title value:(NSString *)value {
    return [self modelTitle:title value:value selected:NO];
}
+ (instancetype)modelTitle:(NSString *)title value:(NSString *)value selected:(BOOL)selected {
    PW_AllNftFiltrateItemModel *model = [PW_AllNftFiltrateItemModel new];
    model.title = title;
    model.value = value;
    model.selected = selected;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    PW_AllNftFiltrateItemModel *model = [PW_AllNftFiltrateItemModel allocWithZone:zone];
    model.title = _title;
    model.value = _value;
    model.selected = _selected;
    return model;
}

@end
