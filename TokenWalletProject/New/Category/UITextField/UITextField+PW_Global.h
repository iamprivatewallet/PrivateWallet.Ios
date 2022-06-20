//
//  UITextField+PW_Global.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (PW_Global)

- (void)pw_setPlaceholder:(NSString *)placeholder;
- (void)pw_setPlaceholder:(NSString *)placeholder color:(UIColor *)color;
- (void)pw_setPlaceholder:(NSString *)placeholder color:(UIColor *)color leftImage:(nullable NSString *)leftImage;

- (void)pw_setSecureTextEntry;

@end

NS_ASSUME_NONNULL_END
