//
//  NotScreenshotView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/23.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "WarningAlertSheetView.h"
@interface WarningAlertSheetView()
@property (nonatomic, strong) UIView *shadowBgView;
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic, assign) BOOL isLoginOut;
@property(nonatomic, assign) BOOL isKeystore;
@property (nonatomic, copy) void(^bottomClickItemAction)(NSInteger index);
@property (nonatomic, copy) void(^clickBtnAction)(void);

@end
@implementation WarningAlertSheetView

+(WarningAlertSheetView *)initView{
    WarningAlertSheetView *backView = nil;

    [SVProgressHUD dismiss];
    for (WarningAlertSheetView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[WarningAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
       
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);

    [UIView animateWithDuration:0.4 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    return backView;

}
//退出登录 样式
+(WarningAlertSheetView *)showAlertViewWithIcon:(NSString *)icon
                                          title:(NSString *)title
                                        content:(NSString *)content
                                        btnText:(NSString *)btnText
                                     btnBgColor:(UIColor *)bgColor
                                         action:(void(^)(void))action{
    WarningAlertSheetView *sheetView = [WarningAlertSheetView initView];
    sheetView.bgView.layer.cornerRadius = 12;
    sheetView.clickBtnAction = action;
    [sheetView makeAlertViewWithIcon:icon title:title content:content btnText:btnText btnBgColor:bgColor];
    return sheetView;
}
//导出keystore 样式
+(WarningAlertSheetView *)showExportAlertViewIsKeystore:(BOOL)isKeystore{
    WarningAlertSheetView *sheetView = [WarningAlertSheetView initView];
    sheetView.isKeystore = isKeystore;
    sheetView.bgView.layer.cornerRadius = 12;
    [sheetView makeExportViewsIsNotBackup:NO];
    return sheetView;
}
//底部选项框
+(WarningAlertSheetView *)showClickViewWithItems:(NSArray *)items action:(void(^)(NSInteger index))action{
    WarningAlertSheetView *sheetView = [WarningAlertSheetView initView];
    [sheetView makeClickItemViewWithItems:items];
    sheetView.bottomClickItemAction = action;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:sheetView action:@selector(tapGestureAction)];
    [sheetView.shadowBgView addGestureRecognizer:tap];

    return sheetView;
}
+(WarningAlertSheetView *)showSortViewWithAction:(void(^)(NSInteger index))action{
    WarningAlertSheetView *sheetView = [WarningAlertSheetView initView];
    [sheetView makeSortView];
    sheetView.bottomClickItemAction = action;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:sheetView action:@selector(tapGestureAction)];
    [sheetView.shadowBgView addGestureRecognizer:tap];

    return sheetView;
}
//未备份提示框
+(WarningAlertSheetView *)showNotBackupAlertViewWithAction:(void(^)(NSInteger index))action{
    WarningAlertSheetView *sheetView = [WarningAlertSheetView initView];
    sheetView.bgView.layer.cornerRadius = 12;
    sheetView.bottomClickItemAction = action;
    [sheetView makeExportViewsIsNotBackup:YES];
    return sheetView;
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
    self.shadowBgView = [[UIView alloc] init];
    self.shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
    [self addSubview:self.shadowBgView];
    
    [self.shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor navAndTabBackColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(10);
    }];
}
#pragma mark sheet弹框
- (void)makeClickItemViewWithItems:(NSArray *)itemList{
    UIView *bottom_whiteBg = [[UIView alloc] init];
    bottom_whiteBg.backgroundColor = [UIColor whiteColor];
    bottom_whiteBg.layer.cornerRadius = 14;
    [self.bgView addSubview:bottom_whiteBg];
    [bottom_whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-kBottomSafeHeight-15);
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.height.mas_equalTo(60);
    }];
    
    UIButton *cancelBtn = [ZZCustomView buttonInitWithView:bottom_whiteBg title:@"取消" titleColor:[UIColor im_textColor_three] titleFont:GCSFontRegular(18)];
    cancelBtn.tag = 0;
    [cancelBtn addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottom_whiteBg);
    }];
    
    UIView *top_whiteBg = [[UIView alloc] init];
    top_whiteBg.backgroundColor = [UIColor whiteColor];
    top_whiteBg.layer.cornerRadius = 14;
    [self.bgView addSubview:top_whiteBg];
    [top_whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.bottom.equalTo(bottom_whiteBg.mas_top).offset(-CGFloatScale(10));
    }];
    UIView *lastView = nil;
    for(int i = 0; i <itemList.count; i++){
        UIButton *itemBtn = [ZZCustomView buttonInitWithView:top_whiteBg title:itemList[i] titleColor:[UIColor im_blueColor] titleFont:GCSFontMedium(17)];
        itemBtn.tag = i+1;
        [itemBtn addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(top_whiteBg);
            make.top.equalTo(lastView?lastView.mas_bottom:top_whiteBg);
            make.height.mas_equalTo(bottom_whiteBg);
            if (i == itemList.count-1) {
                make.bottom.equalTo(top_whiteBg);
            }
        }];
        if(i != itemList.count-1){
            UIView *line = [ZZCustomView viewInitWithView:top_whiteBg bgColor:[UIColor im_borderLineColor]];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(top_whiteBg);
                make.top.equalTo(itemBtn.mas_bottom);
                make.height.mas_equalTo(1);
            }];
        }
        lastView = itemBtn;
    }
}
#pragma mark 选择排序 sheet弹框
- (void)makeSortView{
    UIView *bottom_whiteBg = [[UIView alloc] init];
    bottom_whiteBg.backgroundColor = [UIColor whiteColor];
    bottom_whiteBg.layer.cornerRadius = 14;
    [self.bgView addSubview:bottom_whiteBg];
    [bottom_whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-kBottomSafeHeight-15);
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.height.mas_equalTo(60);
    }];
    
    UIButton *cancelBtn = [ZZCustomView buttonInitWithView:bottom_whiteBg title:@"取消" titleColor:[UIColor im_textColor_three] titleFont:GCSFontRegular(18)];
    cancelBtn.tag = 0;
    [cancelBtn addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottom_whiteBg);
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"选择排序方式" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(13)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.centerX.equalTo(self.bgView);
    }];
    
    UIView *top_whiteBg = [[UIView alloc] init];
    top_whiteBg.backgroundColor = [UIColor whiteColor];
    top_whiteBg.layer.cornerRadius = 14;
    [self.bgView addSubview:top_whiteBg];
    [top_whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).offset(CGFloatScale(15));
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
        make.bottom.equalTo(bottom_whiteBg.mas_top).offset(-CGFloatScale(10));
    }];
    NSArray *itemList = @[@"默认排序",@"价值排序",@"名称排序"];
    UIView *lastView = nil;
    for(int i = 0; i <itemList.count; i++){
        UIButton *itemBtn = [ZZCustomView buttonInitWithView:top_whiteBg title:itemList[i] titleColor:[UIColor im_blueColor] titleFont:GCSFontMedium(17)];
        itemBtn.tag = i+1;
        [itemBtn addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(top_whiteBg);
            make.top.equalTo(lastView?lastView.mas_bottom:top_whiteBg);
            make.height.mas_equalTo(bottom_whiteBg);
            if (i == itemList.count-1) {
                make.bottom.equalTo(top_whiteBg);
            }
        }];
        if(i != itemList.count-1){
            UIView *line = [ZZCustomView viewInitWithView:top_whiteBg bgColor:[UIColor im_borderLineColor]];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(top_whiteBg);
                make.top.equalTo(itemBtn.mas_bottom);
                make.height.mas_equalTo(1);
            }];
        }
        lastView = itemBtn;
    }
}

- (void)clickItemAction:(UIButton *)sender{
    if (sender.tag == 0) {
        [self removeSubviews];
    }else {
        if(self.bottomClickItemAction){
            self.bottomClickItemAction(sender.tag);
            [self removeSubviews];
        }
    }
}
#pragma mark 未备份身份

#pragma mark 导出Keystore || 私钥
- (void)makeExportViewsIsNotBackup:(BOOL)isNotBackup{
    UILabel *title;
    if (!isNotBackup) {
        title = [ZZCustomView labelInitWithView:self.bgView text:self.isKeystore?@"复制Keystore":@"复制私钥" textColor:COLORFORRGB(0x54565e) font:GCSFontRegular(18)];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.bgView).offset(10);
        }];
    }
    NSString *str;
    NSString *str2;
    if (isNotBackup) {
        str = @"取消";
        str2 = @"前往备份";
    }else{
        str = @"仍要复制";
        str2 = @"不复制了";
    }
    UIButton *copyBtn = [ZZCustomView buttonInitWithView:self.bgView title:str titleColor:[UIColor im_blueColor] titleFont:GCSFontRegular(16) bgColor:COLORFORRGB(0xdfecf5)];
    copyBtn.layer.cornerRadius = 8;
    [copyBtn addTarget:self action:@selector(copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_centerX).offset(-5);
        make.left.equalTo(self.bgView).offset(10);
        make.bottom.equalTo(self.bgView).offset(-CGFloatScale(45));
        make.height.mas_equalTo(CGFloatScale(50));
    }];
    
    UIButton *noCopyBtn = [ZZCustomView im_ButtonDefaultWithView:self.bgView title:str2 titleFont:GCSFontRegular(16) enable:YES];
    [noCopyBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [noCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_centerX).offset(5);
        make.right.equalTo(self.bgView).offset(-10);
        make.bottom.height.equalTo(copyBtn);
    }];
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = 8;
    [self.bgView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isNotBackup) {
            make.top.equalTo(self.bgView).offset(CGFloatScale(20));
        }else{
            make.top.equalTo(title.mas_bottom).offset(CGFloatScale(10));
        }
        make.bottom.equalTo(copyBtn.mas_top).offset(-CGFloatScale(10));
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));
    }];
    [self makeWhiteViewsForView_export:whiteBg isBackup:isNotBackup];
}
- (void)makeWhiteViewsForView_export:(UIView *)whiteView isBackup:(BOOL)isBackup{
    NSString *imgStr ;
    NSString *str ;
    NSString *str2 ;
    UIColor *color;
    if (isBackup) {
        imgStr = @"identityNotBackuped";
        str = @"未备份身份";
        str2 = @"身份未备份，请确保已安全备份身份助记词";
        color = [UIColor im_textColor_three];
    }else{
        imgStr = @"alarm";
        str = @"风险提示";
        str2 = @"复制Keystore存在风险，剪贴板容易被第三方应用监控或滥用;建议使用二维码形式，直接扫码进行钱包转移";
        color = COLORFORRGB(0xe24d35);
    }
    
    UIImageView *icon = [ZZCustomView imageViewInitView:whiteView imageName:imgStr];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(whiteView).offset(CGFloatScale(40));
        make.width.height.mas_equalTo(CGFloatScale(60));
    }];
    UILabel *title = [ZZCustomView labelInitWithView:whiteView text:str textColor:color font:GCSFontMedium(18)];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.top.equalTo(icon.mas_bottom).offset(12);
    }];
    
    UILabel *detail = [ZZCustomView labelInitWithView:whiteView text:str2 textColor:COLORFORRGB(0x54565e) font:GCSFontRegular(15)];
    detail.numberOfLines = 0;
    detail.textAlignment = NSTextAlignmentCenter;
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.left.equalTo(whiteView).offset(CGFloatScale(25));
        make.right.equalTo(whiteView).offset(-CGFloatScale(25));
        make.top.equalTo(title.mas_bottom).offset(12);
        make.bottom.equalTo(whiteView).offset(-40);
    }];
}

#pragma mark 退出登录|| 备份提示
- (void)makeAlertViewWithIcon:(NSString *)icon
                        title:(NSString *)title
                      content:(NSString *)content
                      btnText:(NSString *)btnText
                   btnBgColor:(UIColor *)bgColor{
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];

    [self.bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(15));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];
    UIButton *nextStepBtn = [ZZCustomView buttonInitWithView:self.bgView title:btnText titleColor:[UIColor whiteColor] titleFont:GCSFontRegular(16) bgColor:bgColor];
    nextStepBtn.layer.cornerRadius = 8;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.left.equalTo(self.bgView).offset(10);
        make.bottom.equalTo(self.bgView).offset(-CGFloatScale(45));
        make.height.mas_equalTo(CGFloatScale(45));
    }];
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = 8;
    [self.bgView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeBtn.mas_bottom).offset(CGFloatScale(10));
        make.bottom.equalTo(nextStepBtn.mas_top).offset(-CGFloatScale(10));
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.right.equalTo(self.bgView).offset(-CGFloatScale(10));

    }];
    
    UIImageView *iconImg = [ZZCustomView imageViewInitView:whiteBg imageName:icon];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteBg).offset(CGFloatScale(40));
        make.centerX.equalTo(whiteBg);
        make.width.height.mas_equalTo(CGFloatScale(60));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:whiteBg text:title textColor:[UIColor blackColor] font:GCSFontRegular(18)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteBg);
        make.top.equalTo(iconImg.mas_bottom).offset(CGFloatScale(12));
    }];
 
    UILabel *detail = [ZZCustomView labelInitWithView:whiteBg text:content textColor:COLORFORRGB(0x54565e) font:GCSFontRegular(14)];
    detail.numberOfLines = 0;
    detail.textAlignment = NSTextAlignmentCenter;
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteBg).offset(CGFloatScale(25));
        make.right.equalTo(whiteBg).offset(-CGFloatScale(25));
        make.top.equalTo(titleLbl.mas_bottom).offset(12);
        make.bottom.equalTo(whiteBg).offset(-CGFloatScale(40));
    }];
}

- (void)tapGestureAction{
    [self removeSubviews];
}
- (void)closeBtnAction{
    [self removeSubviews];
}
//退出登录 || 备份提示 下一步按钮
- (void)nextStepBtnAction{
    if(self.clickBtnAction){
        self.clickBtnAction();
    }
    [self removeSubviews];
}
- (void)copyBtnAction{
    //仍要复制
    if (self.bottomClickItemAction) {
        self.bottomClickItemAction(1);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(warningAlertSheetViewAction)]) {
        [self.delegate warningAlertSheetViewAction];
    }
    [self removeSubviews];
}

- (void)removeSubviews{
    [self removeFromSuperview];
}
@end
