//
//  UIImage+PW_Image.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PW_GradientTopToBottom,
    PW_GradientLeftToRight,
    PW_GradientLeftTopToRightBottom,
    PW_GradientLeftBottomToRightTop,
} PW_GradientType;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PW_Image)

+ (UIImage *)pw_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)pw_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;
+ (UIImage *)pw_imageGradientSize:(CGSize)size gradientColors:(NSArray *)colors gradientType:(PW_GradientType)gradientType;
+ (UIImage *)pw_imageGradientSize:(CGSize)size gradientColors:(NSArray *)colors gradientType:(PW_GradientType)gradientType cornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
