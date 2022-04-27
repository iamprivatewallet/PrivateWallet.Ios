//
//  PW_AlertTool.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_AlertTool : NSObject

+ (void)showAlertTitle:(NSString *)title desc:(NSString *)desc sureBlock:(void (^)(void))block;

+ (void)showAnimationAlertContentView:(UIView *)contentView;
+ (void)showAnimationSheetContentView:(UIView *)contentView;
+ (UIView *)showAlertView:(UIView *)view;
+ (UIView *)showSheetView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
