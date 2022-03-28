//
//  ExportTopView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ExportTopView.h"
@interface ExportTopView()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ExportTopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews{
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    UIView *bgLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, ScreenWidth, 1)];
    bgLine.backgroundColor = [UIColor im_borderLineColor];
    [self addSubview:bgLine];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, ScreenWidth/2, 2)];
    self.bottomLine.backgroundColor = [UIColor im_blueColor];
    [self addSubview:self.bottomLine];
    
    
}
- (void)setTopItemTitleWithType:(BOOL)isKeystore{
    if (isKeystore) {
        [_leftButton setTitle:@"Keystore" forState:UIControlStateNormal];
        
    }else{
        [_leftButton setTitle:@"私钥" forState:UIControlStateNormal];
    }
}

- (void)itemButtonAction:(UIButton *)sender {
    [self makeButtonDefault];
    [sender setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomLine.center = CGPointMake(sender.centerX, self.height-2);
    }];
    if ([self.delegate respondsToSelector:@selector(clickItemWithIndex:)]) {
        [self.delegate clickItemWithIndex:sender.tag-10];
    }
}

- (void)chooseItemWithIndex:(NSInteger)index{
    [self makeButtonDefault];
    UIButton *btn = [self viewWithTag:10+index];
    [btn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
}

- (void)makeButtonDefault {
    [_leftButton setTitleColor:[UIColor im_textColor_six] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor im_textColor_six] forState:UIControlStateNormal];
}
- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        _leftButton.frame = CGRectMake(0, 0, ScreenWidth/2, self.height);
        [_leftButton setTitle:@"私钥" forState:UIControlStateNormal];
        _leftButton.tag = 10;
        _leftButton.titleLabel.font = GCSFontRegular(16);
        [_leftButton addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, self.height);
        [_rightButton setTitle:@"二维码" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor im_textColor_six] forState:UIControlStateNormal];
        _rightButton.tag = 11;
        _rightButton.titleLabel.font = GCSFontRegular(16);
        [_rightButton addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
