//
//  UIControl+PW_Block.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PW_ButtonTargetBlock)(UIControl * _Nonnull sender);

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (PW_Block)

- (void)addEvent:(UIControlEvents)event block:(PW_ButtonTargetBlock)block;
- (void)addTouchUpTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
