//
//  UITextField+PW_Global.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "UITextField+PW_Global.h"

@implementation UITextField (PW_Global)

- (void)setPlaceholder:(NSString *)placeholder {
    if([placeholder isNoEmpty]){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor g_placeholderColor]} range:NSMakeRange(0, attrStr.length)];
        self.attributedPlaceholder = attrStr;
    }
}

@end
