//
//  PW_ShareModel.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/21.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_ShareModel : NSObject

/// 用于展示分享弹出顶部左侧的图片
@property(nonatomic, strong) UIImage * __nullable showIcon;
/// 用于展示分享弹窗顶部的大标题
@property(nonatomic, copy) NSString * __nullable showTitle;
/// 用于展示分享弹出顶部大标题下面的小标题
@property(nonatomic, copy) NSString * __nullable showSubTitle;
/// 真正分享的内容（如果没有配置show的三个字段，直接使用data进行自动分享展示）
/// NSURL、NSString、UIImage。。。
@property(nonatomic, strong) id data;
+ (instancetype)modelWithShowIcon:(nullable UIImage *)showIcon title:(nullable NSString *)title subTitle:(nullable NSString *)subTitle data:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
