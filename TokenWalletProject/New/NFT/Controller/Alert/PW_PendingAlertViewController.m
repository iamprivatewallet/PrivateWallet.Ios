//
//  PW_PendingAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PendingAlertViewController.h"

@interface PW_PendingAlertViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIImageView *stateIv;
@property (nonatomic, strong) UILabel *textLb;
@property (nonatomic, strong) UILabel *descLb;

@end

@implementation PW_PendingAlertViewController

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
- (void)setType:(NSInteger)type {
    _type = type;
    [self refreshContentView];
}
- (void)setText:(NSString *)text {
    _text = text;
    self.textLb.text = text;
}
- (void)show {
    [[PW_APPDelegate getRootCurrentNavc] presentViewController:self animated:NO completion:nil];
}
- (void)closeAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(366);
    }];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.offset(-30);
        make.width.height.mas_equalTo(24);
    }];
    [self refreshContentView];
}
- (void)refreshContentView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.stateIv];
    [self.stateIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(62);
        make.centerX.offset(0);
    }];
    if (self.type==PW_PendingAlertPending) {
        self.stateIv.image = [UIImage imageNamed:@"icon_pending"];
        [self addAnimation];
        UILabel *tipLb = [PW_ViewTool labelSemiboldText:@"Waiting for confirmation" fontSize:21 textColor:[UIColor g_textColor]];
        tipLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:tipLb];
        [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateIv.mas_bottom).offset(24);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        [self.contentView addSubview:self.textLb];
        [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLb.mas_bottom).offset(10);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        self.descLb.text = @"Confirm this transactiong in your wallet.";
        [self.contentView addSubview:self.descLb];
        [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLb.mas_bottom).offset(15);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(50);
        }];
    }else if(self.type==PW_PendingAlertSuccess) {
        self.stateIv.image = [UIImage imageNamed:@"icon_success"];
        [self.contentView addSubview:self.textLb];
        [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateIv.mas_bottom).offset(16);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        self.descLb.text = @"Transaction submitted";
        [self.contentView addSubview:self.descLb];
        [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLb.mas_bottom).offset(8);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(50);
        }];
        UIButton *closeBtn = [PW_ViewTool buttonSemiboldTitle:@"DISMISS" fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(closeAction)];
        [self.contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLb.mas_bottom).offset(30);
            make.width.mas_equalTo(142);
            make.height.mas_equalTo(50);
            make.centerX.offset(0);
        }];
    }else if(self.type==PW_PendingAlertError) {
        self.stateIv.image = [UIImage imageNamed:@"icon_fail"];
        UILabel *textLb = [PW_ViewTool labelSemiboldText:self.text?self.text:@"Error" fontSize:17 textColor:[UIColor g_errorColor]];
        textLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLb];
        [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateIv.mas_bottom).offset(16);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        self.descLb.text = @"Transaction rejected";
        [self.contentView addSubview:self.descLb];
        [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLb.mas_bottom).offset(8);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(50);
        }];
        UIButton *closeBtn = [PW_ViewTool buttonSemiboldTitle:@"CLOSE" fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(closeAction)];
        [self.contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLb.mas_bottom).offset(30);
            make.width.mas_equalTo(142);
            make.height.mas_equalTo(50);
            make.centerX.offset(0);
        }];
    }
}
- (void)addAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI*2);
    animation.duration = 3;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = LONG_MAX;
    animation.removedOnCompletion = NO;
    [self.stateIv.layer addAnimation:animation forKey:nil];
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
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    }
    return _closeBtn;
}
- (UIImageView *)stateIv {
    if (!_stateIv) {
        _stateIv = [[UIImageView alloc] init];
    }
    return _stateIv;
}
- (UILabel *)textLb {
    if (!_textLb) {
        _textLb = [PW_ViewTool labelSemiboldText:self.text fontSize:17 textColor:[UIColor g_primaryNFTColor]];
        _textLb.textAlignment = NSTextAlignmentCenter;
    }
    return _textLb;
}
- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [PW_ViewTool labelSemiboldText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
        _descLb.textAlignment = NSTextAlignmentCenter;
    }
    return _descLb;
}

@end
