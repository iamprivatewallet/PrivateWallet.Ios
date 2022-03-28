//
//  ReadServiceView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/6.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ReadServiceView.h"
@interface ReadServiceView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *nextStepBtn;

@property (nonatomic, copy) void(^clickBtnAction)(void);

@end
@implementation ReadServiceView

+(ReadServiceView *)showServiceViewWithAction:(void(^)(void))action{
    ReadServiceView *backView = nil;

    [SVProgressHUD dismiss];
    for (ReadServiceView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[ReadServiceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.bgView.layer.cornerRadius = 6;
        backView.clickBtnAction = action;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);

    [UIView animateWithDuration:0.2 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    return backView;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}

- (void)makeViews{
    UIView *shadowBgView = [[UIView alloc] init];
    shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
    [self addSubview:shadowBgView];
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor navAndTabBackColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(10);
        make.top.equalTo(self).offset(kNavBarAndStatusBarHeight);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"服务条款" textColor:[UIColor im_textColor_six] font:GCSFontRegular(16)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(CGFloatScale(10));
    }];
    
    UIButton *netBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [netBtn setImage:ImageNamed(@"global") forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(internetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:netBtn];
    [netBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];
    
    self.nextStepBtn = [ZZCustomView im_ButtonDefaultWithView:self.bgView title:@"确认" titleFont:GCSFontRegular(15) enable:NO];
    [self.nextStepBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.bottom.equalTo(self.bgView).offset(-CGFloatScale(30)-kBottomSafeHeight);
        make.height.mas_equalTo(50);
    }];

    UIButton *protocolBtn = [ZZCustomView buttonInitWithView:self.bgView title:@"我已阅读并同意服务条款和Cookie说明" titleColor:[UIColor im_grayColor] titleFont:GCSFontRegular(13)];
    [protocolBtn addTarget:self action:@selector(protocolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(15));
        make.bottom.equalTo(self.nextStepBtn.mas_top).offset(-CGFloatScale(8));
        make.right.equalTo(self.bgView).offset(-60);
        make.height.equalTo(@30);
    }];
    [protocolBtn setImage:ImageNamed(@"currency_uncheck") forState:UIControlStateNormal];
    [protocolBtn setImageEdgeInsets:UIEdgeInsetsMake(5, -30, 5, 0)];
    [protocolBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    protocolBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = 10;
    [self.bgView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeBtn.mas_bottom).offset(CGFloatScale(10));
        make.bottom.equalTo(protocolBtn.mas_top).offset(-CGFloatScale(8));
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
    }];
    self.textView = [ZZCustomView textViewInitFrame:CGRectZero view:whiteBg delegate:nil font:GCSFontRegular(12) textColor:[UIColor im_textColor_three]];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg).offset(CGFloatScale(15));
        make.bottom.equalTo(whiteBg).offset(-CGFloatScale(15));
        make.left.equalTo(whiteBg).offset(CGFloatScale(20));
        make.right.equalTo(whiteBg).offset(-CGFloatScale(20));
    }];
}

- (void)closeBtnAction{
    [self dissmissView];
}

- (void)protocolBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:ImageNamed(@"checkedBlueGhost") forState:UIControlStateNormal];
        self.nextStepBtn.userInteractionEnabled = YES;
        self.nextStepBtn.backgroundColor = [UIColor im_btnSelectColor];
    }else{
        [sender setImage:ImageNamed(@"currency_uncheck") forState:UIControlStateNormal];
        self.nextStepBtn.userInteractionEnabled = NO;
        self.nextStepBtn.backgroundColor = [UIColor im_btnUnSelectColor];
    }
}

- (void)internetBtnAction{
    
}

- (void)nextStepBtnAction{
    if (self.clickBtnAction) {
        self.clickBtnAction();
    }
    [self dissmissView];
}
- (void)dissmissView{
    [self removeFromSuperview];
}
@end
