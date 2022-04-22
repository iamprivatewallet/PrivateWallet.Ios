//
//  PW_Button.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/2.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_Button.h"

@interface PW_Button ()

@property (nonatomic, assign) CGFloat space;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;

@end

@implementation PW_Button
@synthesize normalFont = _normalFont;

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.selectedFont) {
        self.titleLabel.font = selected?self.selectedFont:self.normalFont;
    }
}
- (void)pw_setNormalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont {
    self.normalFont = normalFont;
    self.selectedFont = selectedFont;
}
- (void)setNormalFont:(UIFont *)normalFont {
    _normalFont = normalFont;
    self.titleLabel.font = normalFont;
}
- (UIFont *)normalFont {
    if (!_normalFont) {
        _normalFont = self.titleLabel.font;
    }
    return _normalFont;
}
- (UIFont *)selectedFont {
    return _selectedFont?_selectedFont:self.normalFont;
}

/*
 * @param style：根据枚举设置ImageView和titleLabel的样式
 * @param space：ImageView和titleLabel的间距
 */
- (void)layoutWithEdgeInsetStyle:(PW_ButtonEdgeInsetStyle)style spaceBetweenImageAndTitle:(CGFloat)space {
    self.space = space;
    /**
     *  UIButton中的titleEdgeInsets是title相对于其上左下右的inset，跟tableView的contentInset是类似的。
     *  若只有title或只有image时，那它上下左右都是相对于button的。
     *  如果同时有image和label，UIButton默认的排版是image在左，title在右的，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    //1.获取imageView和titleLabel的宽高
    CGFloat imageViewWidth = self.imageView.frame.size.width;
    CGFloat imageViewHeight = self.imageView.frame.size.height;
    CGFloat titleLabelWidth = 0.f;
    CGFloat titleLabelHeight = 0.f;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        titleLabelWidth = self.titleLabel.intrinsicContentSize.width;
        titleLabelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        titleLabelWidth = self.titleLabel.frame.size.width;
        titleLabelHeight = self.titleLabel.frame.size.height;
    }
    
    //2.声明全局的imageView、titleLabel的EdgeInsets
    UIEdgeInsets imageViewEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleLabelEdgeInsets = UIEdgeInsetsZero;
    
    //3.根据style设置EdgeInsets
    switch (style) {
        case PW_ButtonEdgeInsetStyleTop:{
            imageViewEdgeInsets = UIEdgeInsetsMake(- titleLabelHeight - space/2.f, 0.f, 0.f, - titleLabelWidth);
            titleLabelEdgeInsets = UIEdgeInsetsMake(0.f, - imageViewWidth, -imageViewHeight - space/2.f, 0.f);
        }
            break;
        case PW_ButtonEdgeInsetStyleLeft:{
            imageViewEdgeInsets = UIEdgeInsetsMake(0.f, - space/2.f, 0.f, space/2.f);
            titleLabelEdgeInsets = UIEdgeInsetsMake(0.f, space/2.f, 0.f, - space/2.f);
        }
            break;
        case PW_ButtonEdgeInsetStyleBottom:{
            imageViewEdgeInsets = UIEdgeInsetsMake(0.f, 0.f, - titleLabelHeight - space/2.f, - titleLabelWidth);
            titleLabelEdgeInsets = UIEdgeInsetsMake(- imageViewHeight - space/2.f, - imageViewWidth, 0.f, 0.f);
        }
            break;
        case PW_ButtonEdgeInsetStyleRight:{
            imageViewEdgeInsets = UIEdgeInsetsMake(0.f, titleLabelWidth + space/2.f, 0.f, - titleLabelWidth - space/2.f);
            titleLabelEdgeInsets = UIEdgeInsetsMake(0.f, - imageViewWidth - space/2.f, 0.f, imageViewWidth + space/2.f);
        }
            break;
        default:
            break;
    }
    
    //4.赋值
    self.imageEdgeInsets = imageViewEdgeInsets;
    self.titleEdgeInsets = titleLabelEdgeInsets;
}

@end
