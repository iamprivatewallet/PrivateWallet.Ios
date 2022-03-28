//
//  UITextField+PrivateMethod.m
//  MPay
//
//  Created by 马立平 on 2020/5/20.
//  Copyright © 2020 马立平. All rights reserved.
//

#import "UITextField+PrivateMethod.h"

@implementation UITextField (PrivateMethod)

-(void)im_setPlaceholder:(NSString *)placeholder{
    if(placeholder)
    {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:placeholder];
        [att addAttributes:@{NSForegroundColorAttributeName:COLORFORRGB(0xbcc3c6)} range:NSMakeRange(0, placeholder.length)];
        self.attributedPlaceholder = att;
    }
}
@end
