//
//  PW_SegmentedControl.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SegmentedControl.h"

static CGFloat itemBtnTag = 100;
static CGFloat itemLineTag = 200;

@interface PW_SegmentedControl ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation PW_SegmentedControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = -1;
        [self makeViews];
    }
    return self;
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)view;
            btn.selected = btn.tag==selectedIndex+itemBtnTag;
        }
    }
}
- (void)btnAction:(UIButton *)btn {
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            ((UIButton *)view).selected = NO;
        }
    }
    btn.selected = YES;
    _selectedIndex = btn.tag-itemBtnTag;
    if (self.didClick) {
        self.didClick(_selectedIndex);
    }
}
- (void)setDataArr:(NSArray<NSString *> *)dataArr {
    _dataArr = dataArr;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = dataArr.count;
    UIView *lastView = nil;
    for (NSInteger i=0; i<count; i++) {
        NSString *title = dataArr[i];
        UIButton *btn = [PW_ViewTool buttonSemiboldTitle:title fontSize:14 titleColor:[UIColor g_textColor] imageName:nil target:self action:@selector(btnAction:)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = i+itemBtnTag;
        btn.selected = _selectedIndex==i;
        UIImage *image = [UIImage pw_imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 32)];
        UIImage *selectedImage = [UIImage pw_imageGradientSize:CGSizeMake(1, 32) gradientColors:@[[UIColor g_primaryNFTColor],[UIColor g_primaryColor]] gradientType:PW_GradientTopToBottom];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        if (i!=count-1) {
            UIView *lineView = [[UIView alloc] init];
            lineView.tag = i+itemLineTag;
            lineView.backgroundColor = [UIColor g_hex:@"#BFCDDB"];
            [self.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.offset(0);
                make.height.mas_equalTo(12);
                make.width.mas_equalTo(1);
                make.right.equalTo(btn.mas_right);
            }];
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(lastView);
            }else{
                make.left.offset(0);
            }
            make.top.bottom.offset(0);
            if (i==count-1) {
                make.right.offset(0);
            }
        }];
        lastView = btn;
    }
}
- (void)makeViews {
    [self setShadowColor:[UIColor g_hex:@"#39A8DA" alpha:0.5] offset:CGSizeMake(0, 2) radius:3];
    self.layer.borderColor = [UIColor g_primaryNFTColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 6;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView setCornerRadius:6];
    }
    return _contentView;
}

@end
