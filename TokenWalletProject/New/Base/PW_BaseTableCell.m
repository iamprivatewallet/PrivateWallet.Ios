//
//  PW_BaseTableCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseTableCell.h"

@implementation PW_BaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor g_bgColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (self.selectionStyle != UITableViewCellSelectionStyleNone){
        if (highlighted) {
            self.backgroundColor = [UIColor g_grayBgColor];
        }else{
            self.backgroundColor = [UIColor g_bgColor];
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self customDragImgIcon];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: YES];
    if (editing) {
        [self customDragImgIcon];
    }
}
- (void)customDragImgIcon {
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass: [UIImageView class]]) {
                    ((UIImageView *)subview).image = [UIImage imageNamed:@"icon_menu"];
                }
            }
        }
    }
}

@end
