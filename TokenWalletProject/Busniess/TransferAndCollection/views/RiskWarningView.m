//
//  RiskWarningView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/25.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "RiskWarningView.h"

@interface RiskWarningView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) void(^clickNextStepAction)(void);

@end

@implementation RiskWarningView

+(RiskWarningView *)getRiskWarningViewWithAction:(void(^)(void))action{
    RiskWarningView *backView = nil;

    [SVProgressHUD dismiss];
    for (RiskWarningView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[RiskWarningView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.clickNextStepAction = action;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);

    [UIView animateWithDuration:0.4 animations:^{
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
    self.bgView.layer.cornerRadius = 12;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(10);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.width.height.equalTo(@23);
    }];
    
    UIButton *nextStepBtn = [ZZCustomView im_ButtonDefaultWithView:self.bgView title:@"我已知晓" titleFont:GCSFontRegular(16) enable:YES];
    [nextStepBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-20);
        make.left.equalTo(self.bgView).offset(20);
        make.bottom.equalTo(self.bgView).offset(-25-kBottomSafeHeight);
        make.height.mas_equalTo(CGFloatScale(45));
    }];
        
    UIButton *lookBtn = [ZZCustomView buttonInitWithView:self.bgView title:@"查看常见骗局" titleColor:[UIColor im_btnSelectColor] titleFont:GCSFontRegular(14)];
    [lookBtn addTarget:self action:@selector(lookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.left.equalTo(self.bgView).offset(10);
        make.bottom.equalTo(nextStepBtn.mas_top).offset(-CGFloatScale(60));
        make.height.mas_equalTo(CGFloatScale(45));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"风险提示" textColor:[UIColor blackColor] font:GCSFontSemibold(20)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
        make.top.equalTo(closeBtn.mas_bottom).offset(CGFloatScale(40));
    }];
    
    [self makeInfoViewsWithTopView:titleLbl bottomView:lookBtn];
}

- (void)makeInfoViewsWithTopView:(UIView *)topView bottomView:(UIView *)bottomView{
    UIView *bgView = [[UIView alloc] init];
    [self.bgView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(topView.mas_bottom).offset(CGFloatScale(35));
        make.bottom.equalTo(bottomView.mas_top).offset(-90);
    }];
    NSArray *list = @[
        @{
            @"title":@"请务必在转账操作前，仔细核对转账地址信息;",
            @"icon":@"contact"
        },
        @{
            @"title":@"你的转账行为一旦完成， 对应的资产所有权将由变更为目标地址所对应的账户所有人享有;",
            @"icon":@"upCircle"
        },
        @{
            @"title":@"确保转账属于自愿行为，并确认不涉及任何传销、非法集资、诈骗等违法情形。谨防上当受骗，避免造成不必要的财产损失。",
            @"icon":@"transferProtection"
        },
    ];
    UIView *lastView = nil;
    for(int i = 0; i< list.count; i++){
        
        UIImageView *icon = [ZZCustomView imageViewInitView:bgView imageName:list[i][@"icon"]];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(CGFloatScale(20));
            make.top.equalTo(lastView?lastView.mas_bottom:topView.mas_bottom).offset(30);
            make.width.height.equalTo(@22);
        }];
        UILabel *titleLbl = [ZZCustomView labelInitWithView:bgView text:list[i][@"title"] textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
        titleLbl.numberOfLines = 0;
        [titleLbl sizeToFit];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(CGFloatScale(20));
            make.right.equalTo(bgView).offset(-CGFloatScale(25));

            make.top.equalTo(icon);
            if(i == list.count-1){
                make.bottom.equalTo(bgView);
            }
        }];
        lastView = titleLbl;
    }
    
}

- (void)nextStepBtnAction{
    if(self.clickNextStepAction){
        self.clickNextStepAction();
        [self removeFromSuperview];
    }
    
}
- (void)lookBtnAction{
    
}

- (void)closeBtnAction{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
