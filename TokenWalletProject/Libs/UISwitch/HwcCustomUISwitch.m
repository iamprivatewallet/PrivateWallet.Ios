//
//  HwcCustomUISwitch.m
//  UISwitch
//
//  Created by 宗宇辰 on 2019/1/22.
//  Copyright © 2019年 宗宇辰. All rights reserved.
//

#import "HwcCustomUISwitch.h"

@interface HwcCustomUISwitch()
@property (strong,nonatomic) UILabel * leftLabel;
@property (strong,nonatomic) UILabel * rightLabel;
@property (strong,nonatomic) UILabel * tagLabel;
@end

@implementation HwcCustomUISwitch
-(UILabel*)tagLabel{
    if (!_tagLabel) {
        CGRect frame = self.isOn?CGRectMake(self.frame.size.width - self.frame.size.height,0,self.frame.size.height,self.frame.size.height):CGRectMake(0, 0,self.frame.size.height, self.frame.size.height);
        _tagLabel = [[UILabel alloc] initWithFrame:frame];
        _tagLabel.layer.cornerRadius = self.frame.size.height / 2;
        _tagLabel.layer.masksToBounds = YES;
    }
    return  _tagLabel;
}
-(UILabel*)leftLabel{
    if (!_leftLabel) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _leftLabel = [[UILabel alloc] initWithFrame:frame];
        _leftLabel.backgroundColor = COLOR(238, 238, 238);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.layer.cornerRadius = self.frame.size.height / 2;
        _leftLabel.layer.masksToBounds = YES;
    }
    return _leftLabel;
}
-(void)setIsOn:(BOOL)isOn{
    _isOn = isOn;
    if ([_isState isEqualToString:@"1"]) {
        if (!isOn) {
            self.tagLabel.frame = CGRectMake(0, 0,self.frame.size.height, self.frame.size.height);
            self.leftLabel.backgroundColor = COLOR(174, 172, 172);
        }else{
            self.tagLabel.frame = CGRectMake(self.frame.size.width - self.frame.size.height,0,self.frame.size.height,self.frame.size.height);
            self.leftLabel.backgroundColor = COLOR(188, 152, 115);
        }
    }else{
        if (!isOn) {
            [UIView animateWithDuration:0.5
                                  delay:0.01
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.tagLabel.frame = CGRectMake(0, 0,self.frame.size.height, self.frame.size.height);
                             } completion:^(BOOL finished) {
                                 self.leftLabel.backgroundColor = COLOR(174, 172, 172);
                             }];
        }else{
            [UIView animateWithDuration:0.5
                                  delay:0.01
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.tagLabel.frame = CGRectMake(self.frame.size.width - self.frame.size.height,0,self.frame.size.height,self.frame.size.height);
                             } completion:^(BOOL finished) {
                                 self.leftLabel.backgroundColor = COLOR(188, 152, 115);
                             }];
        }
    }
}
-(void)setUp{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.tagLabel addGestureRecognizer:tap];
    [self.leftLabel addGestureRecognizer:tap1];
    self.tagLabel.userInteractionEnabled = YES;
    self.leftLabel.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [self addSubview:self.leftLabel];
    self.tagLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tagLabel];
    self.layer.cornerRadius = self.frame.size.height/10;
    self.clipsToBounds = YES;
}
-(void)tap{
    _isState = @"0";
    self.isOn = !self.isOn;
    int64_t delayInSeconds = 0.8;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.SwitchisOnBlock(self.isOn);
    });
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
@end
