//
//  PW_NoDataView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NoDataView.h"

@interface PW_NoDataView ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_NoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self addSubview:self.iconIv];
        [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.offset(0);
        }];
        [self addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIv.mas_bottom).offset(30);
            make.left.right.offset(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
    }
    return self;
}

+ (instancetype)showView:(UIView *)view {
    return [self showView:view offsetY:-kNavBarAndStatusBarHeight];
}
+ (instancetype)showView:(UIView *)view offsetY:(CGFloat)offsetY {
    PW_NoDataView *backView = nil;
    for (PW_NoDataView *subv in view.subviews) {
        if ([subv isKindOfClass:[PW_NoDataView class]]) {
            [subv removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[PW_NoDataView alloc] init];
//        backView.backgroundColor = [UIColor whiteColor];
        [view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.centerY.offset(offsetY);
        }];
    }
    return backView;
}
- (void)setOffsetY:(CGFloat)offsetY {
    _offsetY = offsetY;
    if (self.superview) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.superview);
            make.centerY.offset(offsetY);
        }];
    }
}
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.iconIv.image = [UIImage imageNamed:imageName];
}
- (void)setText:(NSString *)text {
    _text = text;
    self.titleLb.text = text;
}
- (void)dismissView {
    [self removeFromSuperview];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_noData"]];
    }
    return _iconIv;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_noData") fontSize:16 textColor:[UIColor g_grayTextColor]];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

@end
