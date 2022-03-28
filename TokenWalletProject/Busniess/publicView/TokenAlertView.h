//
//  TokenAlertView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TokenAlertView : UIView

+ (void)showWithTitle:(NSString *)title message:(NSString *)message textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles action:(void(^)(NSInteger index,NSString *inputText))action;
+ (void)showWithTitle:(NSString *)title message:(NSString *)message textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles keyboardType:(UIKeyboardType)keyboardType action:(void(^)(NSInteger index,NSString *inputText))action;
+ (void)showWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles isPassword:(BOOL)isPassword action:(void(^)(NSInteger index,NSString *inputText))action;
+ (void)showWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder buttonTitles:(NSArray *)buttonTitles keyboardType:(UIKeyboardType)keyboardType isPassword:(BOOL)isPassword action:(void(^)(NSInteger index,NSString *inputText))action;

//普通输入弹框
+ (void)showViewWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder action:(void(^)(NSInteger index,NSString *inputText))action;
+ (void)showViewWithTitle:(NSString *)title textField_p:(NSString *)tf_placehoder keyboardType:(UIKeyboardType)keyboardType action:(void(^)(NSInteger index,NSString *inputText))action;

//密码弹框
+ (void)showInputPasswordWithTitle:(NSString *)title ViewWithAction:(void(^)(NSInteger index,NSString *inputText))action;

@end

NS_ASSUME_NONNULL_END
