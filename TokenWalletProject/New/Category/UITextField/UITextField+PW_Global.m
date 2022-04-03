//
//  UITextField+PW_Global.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "UITextField+PW_Global.h"

@implementation UITextField (PW_Global)

- (void)pw_setPlaceholder:(NSString *)placeholder {
    [self pw_setPlaceholder:placeholder leftImage:nil];
}
- (void)pw_setPlaceholder:(NSString *)placeholder leftImage:(nullable NSString *)leftImage {
    if([placeholder isNoEmpty]){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor g_placeholderColor]} range:NSMakeRange(0, attrStr.length)];
        if(self.font){
            [attrStr addAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(0, attrStr.length)];
        }
        if([leftImage isNoEmpty]){
            UIImage *image = [UIImage imageNamed:leftImage];
            if(image){
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                attach.image = image;
                if(self.font){
                    attach.bounds = CGRectMake(0, (self.font.lineHeight-image.size.height)*0.5, image.size.width, image.size.height);
                }else{
                    attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                }
                NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
                [attrStr insertAttributedString:attachString atIndex:0];
            }
        }
        self.attributedPlaceholder = attrStr;
    }
}

@end
