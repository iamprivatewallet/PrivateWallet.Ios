//
//  DAppsWebAlertView.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsWebAlertView.h"
@interface DAppsWebAlertView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) void(^clickItemBlock)(NSInteger index);
@end
@implementation DAppsWebAlertView

+(DAppsWebAlertView *)showWebAlertViewWithUrl:(NSString *)url action:(void(^)(NSInteger index))action{
    DAppsWebAlertView *backView = nil;

    [SVProgressHUD dismiss];
    for (DAppsWebAlertView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[DAppsWebAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds url:url];
        backView.clickItemBlock = action;
        backView.url = url;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 300);

    [UIView animateWithDuration:0.2 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    return backView;

}
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViewsUrl:url];
    }
    return self;
}

- (void)makeViewsUrl:(NSString *)url{
    UIView *shadowBgView = [[UIView alloc] init];
    shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
    [self addSubview:shadowBgView];
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.backgroundColor = [UIColor im_tableBgColor];
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
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"页面管理" textColor:[UIColor im_textColor_six] font:GCSFontRegular(11)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.top.equalTo(self.bgView).offset(15);
    }];
    
    UIView *topLastView = nil;
    UIView *bottomLastView = nil;
    
    NSDictionary *dic = [[DAppsManager sharedInstance] getDAppsWithUrl:url];
    BOOL isCheck = [dic[@"isCollection"] boolValue];
    NSString *starStr = @"dappStar";
    if (isCheck) {
        starStr = @"dappStarred";
        
    }
    NSArray *list = @[
        @{
            @"img":@"dappShare",
            @"title":@"分享",
        },
        @{
            @"img":@"dappCopy",
            @"title":@"复制链接",
        },
        @{
            @"img":@"refresh",
            @"title":@"刷新",
        },
        @{
            @"img":@"switchAddress",
            @"title":@"切换钱包",
        },
        @{
            @"img":starStr,
            @"title":@"收藏",
        },
    ];

    for (int i = 0; i < list.count; i++) {
        UIButton *itemBtn = [ZZCustomView buttonInitWithView:self.bgView imageName:list[i][@"img"]];
        itemBtn.backgroundColor = [UIColor whiteColor];
        itemBtn.layer.cornerRadius = 14;
        itemBtn.tag = i;
        [itemBtn addTarget:self action:@selector(itemBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];

        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i >= 3) {
                make.left.equalTo(bottomLastView?bottomLastView.mas_right :self.bgView).offset(bottomLastView ? 20:25);
                make.top.equalTo(topLastView.mas_bottom).offset(40);
                make.bottom.equalTo(self.bgView).offset(-kBottomSafeHeight-55);
            }else{
                make.left.equalTo(topLastView?topLastView.mas_right :self.bgView).offset(topLastView ? 20:25);
                make.top.equalTo(titleLbl.mas_bottom).offset(20);
            }
            make.width.height.equalTo(@53);
        }];
        
        UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:list[i][@"title"] textColor:[UIColor im_textColor_six] font:GCSFontRegular(12)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemBtn);
            make.top.equalTo(itemBtn.mas_bottom).offset(5);
        }];
        if (i >= 3) {
            bottomLastView = itemBtn;

        }else{
            topLastView = itemBtn;

        }
    }
    
    
    
}
- (void)closeBtnAction{
    [self dissmissView];
}
- (void)dissmissView{
    [self removeFromSuperview];
}

- (void)itemBtnClickAction:(UIButton *)sender{
   
   
    if (sender.tag == 4) {
        NSDictionary *dic = [[DAppsManager sharedInstance] getDAppsWithUrl:self.url];
        BOOL isCheck = [dic[@"isCollection"] boolValue];
        if (isCheck) {
            sender.selected = YES;
        }
        sender.selected = ! sender.selected;
        if (sender.selected) {
            [sender setImage:ImageNamed(@"dappStar") forState:UIControlStateNormal];
        }else{
            [sender setImage:ImageNamed(@"dappStarred") forState:UIControlStateNormal];

        }
    }
    if (self.clickItemBlock) {
        self.clickItemBlock(sender.tag);
    }
    [self dissmissView];
}
@end
