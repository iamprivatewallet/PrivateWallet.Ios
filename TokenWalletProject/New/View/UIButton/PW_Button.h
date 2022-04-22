//
//  PW_Button.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PW_ButtonEdgeInsetStyle) {
    PW_ButtonEdgeInsetStyleTop,          //imageView在上,titleLabel在下
    PW_ButtonEdgeInsetStyleLeft,         //imageView在左,titleLabel在右  (UIButton的默认排版)
    PW_ButtonEdgeInsetStyleBottom,       //imageView在下,titleLabel在上
    PW_ButtonEdgeInsetStyleRight         //imageView在右,titleLabel在左
};

NS_ASSUME_NONNULL_BEGIN

@interface PW_Button : UIButton

- (void)pw_setNormalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont;

- (void)layoutWithEdgeInsetStyle:(PW_ButtonEdgeInsetStyle)style spaceBetweenImageAndTitle:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
