//
//  PW_AllNftFiltrateGroupModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseModel.h"
@class PW_AllNftFiltrateItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface PW_AllNftFiltrateGroupModel : PW_BaseModel <NSMutableCopying>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateItemModel *> *items;
+ (instancetype)modelTitle:(NSString *)title items:(NSArray<PW_AllNftFiltrateItemModel *> *)items;

@end

@interface PW_AllNftFiltrateItemModel : PW_BaseModel <NSMutableCopying>

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
+ (instancetype)modelTitle:(NSString *)title value:(NSString *)value;
+ (instancetype)modelTitle:(NSString *)title value:(NSString *)value selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
