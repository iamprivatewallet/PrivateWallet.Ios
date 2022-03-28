//
//  UIImage+ImageEffects.h
//  Traffic
//
//  Created by Terry.c on 30/03/2017.
//  Copyright © 2017 Terry.c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageEffects)

// 返回虚线image的方法
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView;

- (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;
@end
