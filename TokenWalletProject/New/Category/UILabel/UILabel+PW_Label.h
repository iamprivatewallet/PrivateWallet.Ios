//
//  UILabel+PW_Label.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/7.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (PW_Label)

- (void)setLineSpace:(CGFloat)space;
- (void)setWordSpace:(CGFloat)space;
- (void)setLineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

@end

NS_ASSUME_NONNULL_END
