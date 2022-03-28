//
//  UpgradePopUpView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/18.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "UpgradePopUpView.h"

static NSString * const LocalIgnoreVersionKey = @"LocalIgnoreVersionKey";

@interface UpgradePopUpView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *downloadBtn;

@property (nonatomic, strong) VersionModel *model;

@end

@implementation UpgradePopUpView

+ (nullable UpgradePopUpView *)showUpgradePopUpViewWithModel:(VersionModel *)model {
    return [self showUpgradePopUpViewWithModel:model userTake:NO];
}
+ (nullable UpgradePopUpView *)showUpgradePopUpViewWithModel:(VersionModel *)model userTake:(BOOL)userTake{
    if(model.code<=[APPBuild integerValue]){
        return nil;
    }
    if(!model.isForce&&userTake==NO){
        NSInteger version = [[NSUserDefaults standardUserDefaults] integerForKey:LocalIgnoreVersionKey];
        if(version>=model.code){
            return nil;
        }
    }
    UpgradePopUpView *backView = nil;
    [SVProgressHUD dismiss];
    for (UpgradePopUpView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[UpgradePopUpView alloc] initWithModel:model];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 600);
    [UIView animateWithDuration:0.2 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    return backView;
}

- (instancetype)initWithModel:(VersionModel *)model {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _model = model;
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    self.backgroundColor = COLORA(0, 0, 0, 0.5);
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor navAndTabBackColor];
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
    [self.bgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.bgView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.right.offset(-30);
        make.centerY.offset(0);
        make.height.mas_lessThanOrEqualTo(SCREEN_HEIGHT*0.6);
    }];
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.text = NSStringWithFormat(@"更新至 %@ 最新版本",APPName);
    self.titleLb.textColor = [UIColor blackColor];
    self.titleLb.font = [UIFont systemFontOfSize:18];
    self.titleLb.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(25);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(0).priorityLow();
    }];
    [self setTextViewText:self.model.content];
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.downloadBtn setTitle:@"去更新" forState:UIControlStateNormal];
    self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.downloadBtn.layer.cornerRadius = 6;
    self.downloadBtn.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageWithColor:[UIColor im_blueColor] size:CGSizeMake(SCREEN_WIDTH-100, 45)];
    [self.downloadBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.downloadBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.downloadBtn];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.mas_equalTo(50);
        make.bottom.mas_lessThanOrEqualTo(-20);
    }];
    
    if(!self.model.isForce){
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeBtn setTitle:@"稍后再说" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downloadBtn.mas_bottom).offset(15);
            make.centerX.offset(0);
            make.bottom.offset(-15);
        }];
    }
}
- (void)setTextViewText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGFloat height = [self.textView.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+20;
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(25);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(height).priorityLow();
    }];
}
- (void)downloadAction {
    [self dissmissView];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppTestflightUrl] options:@{} completionHandler:nil];
}
- (void)closeBtnAction{
    [[NSUserDefaults standardUserDefaults] setInteger:self.model.code forKey:LocalIgnoreVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dissmissView];
}
- (void)dissmissView{
    [self removeFromSuperview];
}

@end
