//
//  PW_AllNftFiltrateItemCell.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AllNftFiltrateItemCell.h"

@interface PW_AllNftFiltrateItemCell ()

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation PW_AllNftFiltrateItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)setModel:(PW_AllNftFiltrateItemModel *)model {
    _model = model;
    self.titleLb.text = model.title;
    if (model.selected) {
        UIImage *image = [UIImage pw_imageGradientSize:CGSizeMake(self.itemWidth, 40) gradientColors:@[[UIColor g_hex:@"#368EF7"],[UIColor g_shadowPrimaryColor]] gradientType:PW_GradientLeftTopToRightBottom cornerRadius:20];
        self.bodyView.backgroundColor = [UIColor colorWithPatternImage:image];
        [self.bodyView setShadowColor:[UIColor g_shadowPrimaryColor] offset:CGSizeMake(0, 4) radius:8];
        self.titleLb.textColor = [UIColor whiteColor];
    }else{
        self.bodyView.backgroundColor = [UIColor g_bgColor];
        [self.bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 4) radius:8];
        self.titleLb.textColor = [UIColor g_textColor];
    }
}
- (void)makeViews {
    [self.contentView addSubview:self.bodyView];
    [self.bodyView addSubview:self.titleLb];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
#pragma mark - lazy
- (UIView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.backgroundColor = [UIColor g_bgColor];
        [_bodyView setShadowColor:[UIColor g_shadowGrayColor] offset:CGSizeMake(0, 4) radius:8];
        _bodyView.layer.cornerRadius = 20;
    }
    return _bodyView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

@end
