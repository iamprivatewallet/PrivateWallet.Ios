//
//  UIFont+PW_Font.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (PW_Font)

+ (instancetype)pw_regularFontOfSize:(CGFloat)size;
+ (instancetype)pw_boldFontOfSize:(CGFloat)size;
+ (instancetype)pw_mediumFontOfSize:(CGFloat)size;
+ (instancetype)pw_semiBoldFontOfSize:(CGFloat)size;
+ (instancetype)pw_thinFontOfSize:(CGFloat)size;
+ (instancetype)pw_heavyFontOfSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
