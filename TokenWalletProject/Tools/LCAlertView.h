//
//  LCAlertView.h
//  PJS
//
//  Created by lmondi on 16/7/21.
//  Copyright © 2016年 Rich. All rights reserved.
//


/*
 用法示例
 one:
 LCAlertView *alert =  [LCAlertView showWithTitle:nil message:nil buttonTitles:nil action:^(NSInteger index) {
    NSLog(@"index = %ld",index);
 }];
 alert.backViewDismiss = YES;

 two:
 [LCAlertView showWithTitle:nil message:nil buttonTitles:nil action:^(NSInteger index) {
    NSLog(@"index = %ld",index);
 }];
 
 
 */

#import <UIKit/UIKit.h>
@interface LCAlertView : UIView
/**
 *  点击背景蒙版是否消失
 */
@property (nonatomic,assign) BOOL backViewDismiss;


/**
 *  仿系统alert样式
 *
 *  @param title        alert的标题   最多两行，尽量一行吧
 *  @param message      提示文本   极限情况就算了，也没必要提示
 *  @param buttonTitles 数组形式的按钮标题 支持很多个，两个的时候左右排布，其它均为上下
 *  @param action       点击按钮事件，根据index去判断点击哪个按钮，index：0~max
 *
 *  @return 返回实例对象可以设置点击蒙版背景是否消失
 */

+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles action:(void(^)(NSInteger index))action;


+ (instancetype)showAuthorizationWithTitle:(NSString *)title with:(NSString *)tip message:(NSString *)message buttonTitles:(NSArray *)buttonTitles action:(void(^)(NSInteger index))action;
@end
