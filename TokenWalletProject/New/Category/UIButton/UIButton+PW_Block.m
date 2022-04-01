//
//  UIButton+PW_Block.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "UIButton+PW_Block.h"
#import <objc/runtime.h>

typedef void(^ButtonTargetBlock)(UIButton * button);
static void * buttonEventsBlockKey = &buttonEventsBlockKey;

@interface UIButton ()
/** 事件回调的block */
@property (nonatomic, copy) ButtonTargetBlock buttonTargetBlock;
 
@end

@implementation UIButton (PW_Block)

- (void)addEvent:(UIControlEvents)event block:(void (^)(UIButton * button))block {
    self.buttonTargetBlock = block;
    [self addTarget:self action:@selector(blcokButtonClicked:) forControlEvents:event];
}
- (ButtonTargetBlock)buttonTargetBlock {
    return objc_getAssociatedObject(self, &buttonEventsBlockKey);
}
- (void)setButtonTargetBlock:(ButtonTargetBlock)buttonTargetBlock {
    objc_setAssociatedObject(self, &buttonEventsBlockKey, buttonTargetBlock, OBJC_ASSOCIATION_COPY);
}
- (void)blcokButtonClicked:(UIButton *)sender {
    if (self.buttonTargetBlock) {
        self.buttonTargetBlock(sender);
    }
}

@end
