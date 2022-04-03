//
//  UIImage+PW_Image.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "UIImage+PW_Image.h"

@implementation UIImage (PW_Image)

+ (UIImage *)pw_imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self pw_imageWithColor:color size:size cornerRadius:0];
}

+ (UIImage *)pw_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)pw_imageGradientSize:(CGSize)size gradientColors:(NSArray *)colors gradientType:(PW_GradientType)gradientType {
    return [self pw_imageGradientSize:size gradientColors:colors gradientType:gradientType cornerRadius:0];
}
+ (UIImage *)pw_imageGradientSize:(CGSize)size gradientColors:(NSArray *)colors gradientType:(PW_GradientType)gradientType cornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    NSMutableArray *colorArr = [NSMutableArray array];
    for(UIColor *c in colors) {
        [colorArr addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colorArr, nil);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case PW_GradientTopToBottom:
            start = CGPointMake(size.width/2, 0.0);
            end = CGPointMake(size.width/2, size.height);
            break;
        case PW_GradientLeftToRight:
            start = CGPointMake(0.0, size.height/2);
            end = CGPointMake(size.width, size.height/2);
            break;
        case PW_GradientLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case PW_GradientLeftBottomToRightTop:
            start = CGPointMake(0.0, size.height);
            end = CGPointMake(size.width, 0.0);
            break;
        default:
            break;
    }
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
