//
//  PW_CancelOfferNFTAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_CancelOfferNFTAlertViewController.h"

@interface PW_CancelOfferNFTAlertViewController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation PW_CancelOfferNFTAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor g_maskColor];
    [self clearBackground];
    [self makeViews];
}
- (void)show {
    [[PW_APPDelegate getRootCurrentNavc] presentViewController:self animated:NO completion:nil];
}
- (void)closeAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)sureAction {
    
}
#pragma mark - views
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(284);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_confirmCancel") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:titleLb];
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    [self.contentView addSubview:closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-30);
        make.width.height.mas_equalTo(24);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_primaryColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(55);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(1);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_withdrawOfferTip") fontSize:16 textColor:[UIColor g_textColor]];
    tipLb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(55);
        make.left.offset(42);
        make.right.offset(-42);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(58);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(50);
        make.bottom.offset(-PW_SafeBottomInset-10);
    }];
}
- (void)addContentAnimation {
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.bounds.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addContentAnimation];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}
#pragma mark - lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
    }
    return _contentView;
}

@end
