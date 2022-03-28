//
//  DAppsShowAlertView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/11.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "DAppsShowAlertView.h"
@interface DAppsShowAlertView()
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic, assign) BOOL isCheckAlert;
@property (nonatomic, copy) void(^clickBtnAction)(NSInteger index, BOOL isNoAlert);

@end
@implementation DAppsShowAlertView

+(DAppsShowAlertView *_Nullable)showAlertViewIsVisitExplain:(BOOL)isExplain netUrl:(nullable NSString *)netUrl action:(void(^_Nullable)(NSInteger index, BOOL isNoAlert))action{
    DAppsShowAlertView *sheetView = [DAppsShowAlertView initView];
    sheetView.bgView.layer.cornerRadius = 12;
    sheetView.clickBtnAction = action;
    [sheetView makeViewIsExplain:isExplain netUrl:netUrl];
    return sheetView;
}
//+(DAppsShowAlertView *)showTradeViewWithAction:(void(^)(NSInteger index))action{
//    
//}
+(DAppsShowAlertView *)initView{
    DAppsShowAlertView *backView = nil;
    [SVProgressHUD dismiss];
    for (DAppsShowAlertView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[DAppsShowAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
       
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
        [self makeBaseViews];
    }
    return self;
}

- (void)makeBaseViews{
    UIView *shadowBgView = [[UIView alloc] init];
    shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
    [self addSubview:shadowBgView];
    [shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor im_tableBgColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(10);
    }];

}

-(void)makeViewIsExplain:(BOOL)isExplain netUrl:(NSString *)netUrl{
    NSString *titleStr;
    if (isExplain) {
        titleStr = @"访问说明";
    }else{
        titleStr = @"申请授权";
    }

    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:titleStr textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(CGFloatScale(10));
        make.centerX.equalTo(self.bgView);
    }];
   
    //2个按钮 单独处理 左右分布
    NSArray *titleArray = @[@"退出",@"确认"];
   __block UIView *lastView = nil;
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *item = [ZZCustomView buttonInitWithView:self.bgView title:obj titleColor:nil titleFont:GCSFontRegular(14)];
        item.tag = idx;
        item.layer.cornerRadius = 8;
        [item addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(idx == 0? self.bgView :self.bgView.mas_centerX).offset(15);
            make.right.equalTo(idx == 0? self.bgView.mas_centerX :self.bgView).offset(-15);
            make.bottom.equalTo(self.bgView).offset(-kBottomSafeHeight-30);
            make.height.mas_equalTo(CGFloatScale(45));
        }];
        if (idx == 0) {
            lastView = item;
            item.backgroundColor = COLORFORRGB(0xdfedf6);
            [item setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        }else{
            item.backgroundColor = [UIColor im_btnSelectColor];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }];
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = 8;
    [self.bgView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).offset(CGFloatScale(10));
        make.bottom.equalTo(lastView.mas_top).offset(isExplain ? -45 : -15);
        make.left.equalTo(self.bgView).offset(CGFloatScale(15));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(15));
    }];
    if (isExplain) {
        UIButton *notShowBtn = [ZZCustomView buttonInitWithView:self.bgView title:@"下次不再提示" titleColor:[UIColor im_grayColor] titleFont:GCSFontRegular(12)];
        [notShowBtn addTarget:self action:@selector(notShowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [notShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(CGFloatScale(10));
            make.bottom.equalTo(lastView.mas_top).offset(-CGFloatScale(5));
            make.height.equalTo(@30);
            make.width.equalTo(@150);
        }];
        [notShowBtn setImage:ImageNamed(@"check_Unchecked") forState:UIControlStateNormal];
        [notShowBtn setImageEdgeInsets:UIEdgeInsetsMake(8, -45, 8, 0)];
        [notShowBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        notShowBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self makeWhiteViewsForView_export:whiteBg isExplain:isExplain netUrl:netUrl];
    
}
- (void)makeWhiteViewsForView_export:(UIView *)whiteView isExplain:(BOOL)isExplain netUrl:(NSString *)netUrl{
    NSString *str;
    NSString *str2;
    
    if (isExplain) {
        str = @"你正在访问第三方DApp";
        str2 = NSStringWithFormat(@"你在第三方DApp.上的使用行为将适用该第三方\nDApp的《用户协议》和《隐私政策》，由\n%@直接并单独向你承担责任。",netUrl);
    }else{
        str = netUrl;
        str2 = NSStringWithFormat(@"%@正在申请访问你的钱包地址，你确认将钱包地址公开给此网站吗?",netUrl);
    }
    
    UIImageView *icon = [ZZCustomView imageViewInitView:whiteView imageName:@"defaultDappIcon"];
    icon.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    icon.layer.borderWidth = 1;
    icon.layer.cornerRadius = 8;
    icon.layer.masksToBounds = YES;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(whiteView).offset(CGFloatScale(40));
        make.width.height.mas_equalTo(CGFloatScale(60));
    }];
    UILabel *title = [ZZCustomView labelInitWithView:whiteView text:str textColor:[UIColor im_textColor_three] font:GCSFontMedium(17)];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(icon.mas_bottom).offset(12);
    }];
    
    UILabel *detail = [ZZCustomView labelInitWithView:whiteView text:str2 textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
    detail.numberOfLines = 0;
    detail.textAlignment = NSTextAlignmentCenter;
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.left.equalTo(whiteView).offset(CGFloatScale(25));
        make.right.equalTo(whiteView).offset(-CGFloatScale(25));
        make.top.equalTo(title.mas_bottom).offset(12);
        make.bottom.equalTo(whiteView).offset(-25);
    }];
}
- (void)clickItemAction:(UIButton *)sender{
    if(self.clickBtnAction){
        self.clickBtnAction(sender.tag,self.isCheckAlert);
    }
    [self removeFromSuperview];

}
- (void)notShowBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.isCheckAlert = YES;
        [sender setImage:ImageNamed(@"check_Checked") forState:UIControlStateNormal];

    }else{
        self.isCheckAlert = NO;
        [sender setImage:ImageNamed(@"check_Unchecked") forState:UIControlStateNormal];

    }

}

@end
