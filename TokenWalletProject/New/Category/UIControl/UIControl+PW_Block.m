//
//  UIControl+PW_Block.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "UIControl+PW_Block.h"
#import <objc/runtime.h>

static void * buttonEventsBlockKey = &buttonEventsBlockKey;

@interface UIControl ()
/** 事件回调的block */
@property (nonatomic, copy) PW_ButtonTargetBlock buttonTargetBlock;
 
@end

@implementation UIControl (PW_Block)

- (void)addTouchUpTarget:(nullable id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEvent:(UIControlEvents)event block:(PW_ButtonTargetBlock)block {
    self.buttonTargetBlock = block;
    [self addTarget:self action:@selector(blcokButtonClicked:) forControlEvents:event];
}
- (PW_ButtonTargetBlock)buttonTargetBlock {
    return objc_getAssociatedObject(self, &buttonEventsBlockKey);
}
- (void)setButtonTargetBlock:(PW_ButtonTargetBlock)buttonTargetBlock {
    objc_setAssociatedObject(self, &buttonEventsBlockKey, buttonTargetBlock, OBJC_ASSOCIATION_COPY);
}
- (void)blcokButtonClicked:(UIControl *)sender {
    if (self.buttonTargetBlock) {
        self.buttonTargetBlock(sender);
    }
}

@end
