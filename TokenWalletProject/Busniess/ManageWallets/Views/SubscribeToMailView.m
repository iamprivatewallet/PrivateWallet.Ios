//
//  SubscribeToMailView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/8.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "SubscribeToMailView.h"
@interface SubscribeToMailView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *mailTF;

@property (nonatomic, copy) void(^clickBtnAction)(NSString *emailStr);

@end
@implementation SubscribeToMailView

+(void)showMailViewWithAction:(void(^)(NSString *emailStr))action{
    SubscribeToMailView *backView = nil;
    [SVProgressHUD dismiss];
    for (SubscribeToMailView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[SubscribeToMailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.clickBtnAction = action;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);

    [UIView animateWithDuration:0.2 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
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
    self.bgView.layer.cornerRadius = 13;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(45);
        make.right.equalTo(self).offset(-45);
        make.center.equalTo(self);
    }];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"订阅邮件" textColor:[UIColor blackColor] font:GCSFontMedium(18)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
        make.top.equalTo(self.bgView).offset(CGFloatScale(25));
    }];
    
    self.mailTF = [ZZCustomView textFieldInitFrame:CGRectZero view:self.bgView placeholder:@"邮箱" delegate:nil font:GCSFontRegular(13)];
    self.mailTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.mailTF.leftViewMode = UITextFieldViewModeAlways;
    self.mailTF.layer.borderColor = [UIColor mp_lineGrayColor].CGColor;
    self.mailTF.layer.borderWidth = 1;
    self.mailTF.layer.cornerRadius = 2;
    [self.mailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.top.equalTo(titleLbl.mas_bottom).offset(CGFloatScale(15));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(20));
        make.height.equalTo(@30);
    }];
    
    UILabel *contentLbl = [ZZCustomView labelInitWithView:self.bgView text:@"同意订阅即代表同意PTE. LTD.、及关联方发送包括有关安全风险提示、产品使用帮助、产品最新信息、活动推广信息等内容。" textColor:[UIColor im_textColor_six] font:GCSFontRegular(15)];
    contentLbl.numberOfLines = 0;
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.top.equalTo(self.mailTF.mas_bottom).offset(CGFloatScale(15));
        make.right.equalTo(self.mailTF.mas_right);

    }];
    
    NSArray *titleArray = @[@"以后再说",@"同意订阅"];
    //2个按钮 单独处理 左右分布
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [ZZCustomView buttonInitWithView:self.bgView title:obj titleColor:[UIColor im_textBlueColor] titleFont:GCSFontRegular(14)];
        item.tag = idx;
        [item addTarget:self action:@selector(messageButtonsEvent:) forControlEvents:UIControlEventTouchUpInside];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(idx == 0? self.bgView :self.bgView.mas_centerX);
            make.right.equalTo(idx == 0? self.bgView.mas_centerX :self.bgView);
            make.bottom.equalTo(self.bgView);
            make.top.equalTo(contentLbl.mas_bottom).offset(20);
            make.height.mas_equalTo(CGFloatScale(45));
        }];
        if (idx == 1) {
            item.titleLabel.font = GCSFontMedium(14);
        }
    }];
    UIView *line_h = [[UIView alloc] init];
    line_h.backgroundColor = [UIColor im_borderLineColor];
    [self.bgView addSubview:line_h];
    [line_h mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.bgView.mas_bottom).offset(-CGFloatScale(45));
    }];
    UIView *line_v = [[UIView alloc] init];
    line_v.backgroundColor = [UIColor im_borderLineColor];
    [self.bgView addSubview:line_v];
    [line_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(line_h);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.bgView.mas_centerX);
    }];
}

- (void)messageButtonsEvent:(UIButton *)sender{
    if (sender.tag == 0) {
       [self dissmissView];
    }else{
        if (self.clickBtnAction) {
            self.clickBtnAction(self.mailTF.text);
        }
    }
}

- (void)dissmissView{
    [self removeFromSuperview];
}
@end
