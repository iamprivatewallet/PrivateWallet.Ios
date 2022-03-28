//
//  HwcCustomUISwitch.h
//  UISwitch
//
//  Created by 宗宇辰 on 2019/1/22.
//  Copyright © 2019年 宗宇辰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HwcCustomUISwitchisOn)(BOOL isOn);
@interface HwcCustomUISwitch : UIView
@property (nonatomic, copy) HwcCustomUISwitchisOn SwitchisOnBlock;
@property (nonatomic)BOOL isOn;
@property (nonatomic, copy)NSString *isState;
@end

NS_ASSUME_NONNULL_END
