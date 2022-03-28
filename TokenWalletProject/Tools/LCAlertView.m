//
//  LCAlertView.m
//  PJS
//
//  Created by lmondi on 16/7/21.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "LCAlertView.h"

#define YMargin 10

@interface DDAlertView1 :UIView

@property (nonatomic, copy)   void(^buttonClickIndex)(NSInteger);

@end


@implementation DDAlertView1


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kRealValue(14);
        self.clipsToBounds = YES;
        self.frame = CGRectMake(0, 0, kRealValue(318), 0);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitlesArray:(NSArray *)buttonTitles action:(void(^)(NSInteger index))action{
    self = [super init];
    if (self) {
        self.buttonClickIndex = action;
        [self setUpWithTitle:title message:message buttonTitles:buttonTitles];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title tip:(NSString *)tip message:(NSString *)message buttonTitlesArray:(NSArray *)buttonTitles action:(void(^)(NSInteger index))action{
    self = [super init];
    if (self) {
        self.buttonClickIndex = action;
        [self setUpWithTitle:title tip:tip message:message buttonTitles:buttonTitles];
    }
    return self;
}

- (void)setUpWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles {
    float y = kRealValue(30);
    if (title) {
        //create titleView
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kRealValue(274), 40)];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:kRealValue(20)];
        [self addSubview:titleLabel];
        if (message.length == 0 || !message) {
            titleLabel.font = [UIFont boldSystemFontOfSize:kRealValue(18)];
            titleLabel.height = kRealValue(20);
        }
        titleLabel.center = CGPointMake(self.center.x, titleLabel.center.y);
        y = CGRectGetMaxY(titleLabel.frame)+kRealValue(16);
    }
//    y += YMargin;
    if ([message isKindOfClass:[NSAttributedString class]]) {
        //create messageView
        // 创建信息label
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kRealValue(274), 0)];
        messageLabel.font = [UIFont systemFontOfSize:kRealValue(15)];
        messageLabel.textColor = [UIColor UIColorWithHexColorString:@"000000" AndAlpha:0.65];
        messageLabel.attributedText = message;
        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
        [messageLabel sizeToFit];
        messageLabel.width = kRealValue(274);
        messageLabel.center = CGPointMake(self.center.x, messageLabel.center.y);
        y = CGRectGetMaxY(messageLabel.frame) + YMargin;
    }else{
        //create messageView
        // 创建信息label
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kRealValue(274), 0)];
        messageLabel.font = [UIFont systemFontOfSize:kRealValue(15)];
        messageLabel.text = message;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
        [messageLabel sizeToFit];
        messageLabel.width = kRealValue(274);
        messageLabel.textColor = [UIColor UIColorWithHexColorString:@"000000" AndAlpha:0.65];
        messageLabel.center = CGPointMake(self.center.x, messageLabel.center.y);
        y = CGRectGetMaxY(messageLabel.frame) + YMargin;
    }
    
    y = [self creatButtonWithTitles:buttonTitles currentY:y];
    
    self.height = y;
}


- (void)setUpWithTitle:(NSString *)title tip:(NSString *)tip message:(NSString *)message buttonTitles:(NSArray *)buttonTitles {
    float y = kRealValue(30);
    
    if (title) {
        //create titleView
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kRealValue(274), 40)];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:kRealValue(20)];
        
        [self addSubview:titleLabel];
        titleLabel.center = CGPointMake(self.center.x, titleLabel.center.y);
        y = CGRectGetMaxY(titleLabel.frame)+kRealValue(16);
    }
//    y += YMargin;
    if (tip) {
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kRealValue(274), 0)];
        tipLbl.font = [UIFont systemFontOfSize:kRealValue(15)];
        tipLbl.text = tip;
        [self addSubview:tipLbl];
        [tipLbl sizeToFit];
        tipLbl.width = kRealValue(274);
        tipLbl.textColor = [UIColor mp_tradepsTitleBlueGrayColor];
        tipLbl.center = CGPointMake(self.center.x, tipLbl.center.y);
        y = CGRectGetMaxY(tipLbl.frame) + kRealValue(6);
    }
    if (message) {
        //create messageView
        // 创建信息label
        UIView *circleV = [[UIView alloc]initWithFrame:CGRectMake(kRealValue(22), y+kRealValue(6),kRealValue(6) , kRealValue(6))];
        circleV.backgroundColor = [UIColor UIColorWithHexColorString:@"#D8D8D8" AndAlpha:1];
        [circleV addWholeRound:kRealValue(3)];
        [self addSubview:circleV];

        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kRealValue(36), y, kRealValue(264), 0)];
        messageLabel.font = [UIFont systemFontOfSize:kRealValue(15)];
        messageLabel.text = message;
        messageLabel.numberOfLines = 0;
        [self addSubview:messageLabel];
        [messageLabel sizeToFit];
        messageLabel.width = kRealValue(274);
        messageLabel.textColor = [UIColor UIColorWithHexColorString:@"000000" AndAlpha:0.65];
        y = CGRectGetMaxY(messageLabel.frame) + YMargin;
    }
    
    y = [self creatButtonWithTitles:buttonTitles currentY:y];
    
    self.height = y;
}

- (CGFloat)creatButtonWithTitles:(NSArray *)titleArray currentY:(CGFloat)y{
    
    CGFloat btnH = kRealValue(54);
    if (titleArray.count == 2) {
        //2个按钮 单独处理 左右分布
        CGFloat w = self.frame.size.width/2;
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(idx*w, y, w, btnH);
            [button setTitle:obj forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:kRealValue(16)];
            button.tag = idx;
            [button setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }];
       [self lineViewWithFrame:CGRectMake(w, y+18, kRealValue(2), kRealValue(20)) color:[UIColor UIColorWithHexColorString:@"#F1F1F1" AndAlpha:1]];
//        [self lineViewWithFrame:CGRectMake(w, y, 0.5f, btnH) color:[UIColor lightGrayColor]];
        
        y += btnH;
        
    }else {
        CGFloat w = self.frame.size.width;
        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, y + btnH*idx, w, btnH);
            [button setTitle:obj forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:kRealValue(16)];
            [button setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            button.tag = idx;
            [button addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
//            [self lineViewWithFrame:CGRectMake(0, CGRectGetMinY(button.frame), self.frame.size.width, .5f) color:[UIColor lightGrayColor]];
        }];
        y += btnH*titleArray.count;
    }
    
    y+=kRealValue(16);
    return y;
}

- (void)messageButtonsEvent:(UIButton *)button {
    [self dismiss:NO];
    if (self.buttonClickIndex) {
        self.buttonClickIndex(button.tag);
    }
    
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [self.superview removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
        
    }];
    
}


- (UIView *)lineViewWithFrame:(CGRect)frame color:(UIColor *)color {
    
    UIView *line         = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    
    [self addSubview:line];
    return line;
}


@end


@interface LCAlertView ()

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,strong) NSArray *buttonTitles;

@end

@implementation LCAlertView


+ (instancetype)showWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles action:(void(^)(NSInteger index))action{
    LCAlertView *backView = nil;
    [SVProgressHUD dismiss];
    for (LCAlertView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[LCAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(touch)];
        [backView addGestureRecognizer:tap];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    DDAlertView1 *alertView1 = [[DDAlertView1 alloc] initWithTitle:title message:message buttonTitlesArray:buttonTitles action:action];
    [backView addSubview:alertView1];
    alertView1.centerX = backView.centerX;
    alertView1.centerY = backView.centerY-kRealValue(50);
    
    return backView;
}


+ (instancetype)showAuthorizationWithTitle:(NSString *)title with:(NSString *)tip message:(NSString *)message buttonTitles:(NSArray *)buttonTitles action:(void(^)(NSInteger index))action{
    LCAlertView *backView = nil;
    for (LCAlertView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[LCAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backView action:@selector(touch)];
        [backView addGestureRecognizer:tap];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    DDAlertView1 *alertView1 = [[DDAlertView1 alloc] initWithTitle:title tip:tip message:message buttonTitlesArray:buttonTitles action:action];
    [backView addSubview:alertView1];
    alertView1.centerX = backView.centerX;
    alertView1.centerY = backView.centerY-kRealValue(50);
    
    return backView;
}

- (void)touch {
    if (self.backViewDismiss) {
        [self dismiss:NO];
    }
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
