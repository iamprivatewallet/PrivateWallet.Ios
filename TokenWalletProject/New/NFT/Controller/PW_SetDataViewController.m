//
//  PW_SetDataViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SetDataViewController.h"

@interface PW_SetDataViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation PW_SetDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_setData")];
    [self makeViews];
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [bodyView addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.right.bottom.offset(0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(self.scrollView);
    }];
}
#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end
