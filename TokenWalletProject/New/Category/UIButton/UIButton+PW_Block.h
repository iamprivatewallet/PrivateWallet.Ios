//
//  UIButton+PW_Block.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (PW_Block)

- (void)addEvent:(UIControlEvents)event block:(void (^)(UIButton * button))block;

@end

NS_ASSUME_NONNULL_END
