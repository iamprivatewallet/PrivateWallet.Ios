//
//  PW_PendingAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/5.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_PendingAlertViewController.h"

@interface PW_PendingAlertViewController ()

@property (nonatomic, strong) UIImageView *stateIv;
@property (nonatomic, strong) UILabel *msgLb;
@property (nonatomic, strong) UILabel *tipLb;
@property (nonatomic, strong) UILabel *descLb;

@end

@implementation PW_PendingAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
}
- (void)setType:(NSInteger)type {
    _type = type;
    [self refreshContentView];
}
- (void)setMsg:(NSString *)msg {
    _msg = msg;
    self.msgLb.text = msg;
}
- (void)setDesc:(NSString *)desc {
    _desc = desc;
    self.descLb.text = desc;
}
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(366);
    }];
    [self refreshContentView];
}
- (void)refreshContentView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-30);
        make.width.height.mas_equalTo(24);
    }];
    [self.contentView addSubview:self.stateIv];
    [self.stateIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(62);
        make.centerX.offset(0);
    }];
    self.msgLb.font = [UIFont pw_semiBoldFontOfSize:17];
    self.msgLb.textColor = [UIColor g_primaryNFTColor];
    [self.stateIv.layer removeAllAnimations];
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
        [self.contentView addSubview:self.msgLb];
        [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLb.mas_bottom).offset(10);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        [self.contentView addSubview:self.descLb];
        [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgLb.mas_bottom).offset(15);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(40);
        }];
        self.tipLb.text = @"Confirm this transactiong in your wallet.";
        [self.contentView addSubview:self.tipLb];
        [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLb.mas_bottom).offset(15);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(50);
            make.bottom.mas_lessThanOrEqualTo(-65);
        }];
    }else if(self.type==PW_PendingAlertSuccess) {
        self.stateIv.image = [UIImage imageNamed:@"icon_success"];
        [self.contentView addSubview:self.msgLb];
        [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateIv.mas_bottom).offset(16);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        self.tipLb.text = @"Transaction submitted";
        [self.contentView addSubview:self.tipLb];
        [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgLb.mas_bottom).offset(8);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(50);
        }];
        UIButton *closeBtn = [PW_ViewTool buttonSemiboldTitle:@"DISMISS" fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(closeAction)];
        [self.contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLb.mas_bottom).offset(30);
            make.width.mas_equalTo(142);
            make.height.mas_equalTo(50);
            make.centerX.offset(0);
            make.bottom.mas_lessThanOrEqualTo(-56);
        }];
    }else if(self.type==PW_PendingAlertError) {
        self.stateIv.image = [UIImage imageNamed:@"icon_fail"];
        self.msgLb.textColor = [UIColor g_errorColor];
        self.msgLb.text = self.msg?self.msg:@"Error";
        self.msgLb.font = [UIFont pw_semiBoldFontOfSize:21];
        [self.contentView addSubview:self.msgLb];
        [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateIv.mas_bottom).offset(16);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(35);
        }];
        self.tipLb.text = @"Transaction rejected";
        [self.contentView addSubview:self.tipLb];
        [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgLb.mas_bottom).offset(8);
            make.centerX.offset(0);
            make.left.mas_greaterThanOrEqualTo(50);
        }];
        UIButton *closeBtn = [PW_ViewTool buttonSemiboldTitle:@"CLOSE" fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(closeAction)];
        [self.contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLb.mas_bottom).offset(30);
            make.width.mas_equalTo(142);
            make.height.mas_equalTo(50);
            make.centerX.offset(0);
            make.bottom.mas_lessThanOrEqualTo(-56);
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
#pragma mark - lazy
- (UIImageView *)stateIv {
    if (!_stateIv) {
        _stateIv = [[UIImageView alloc] init];
    }
    return _stateIv;
}
- (UILabel *)msgLb {
    if (!_msgLb) {
        _msgLb = [PW_ViewTool labelSemiboldText:self.msg fontSize:17 textColor:[UIColor g_primaryNFTColor]];
        _msgLb.textAlignment = NSTextAlignmentCenter;
    }
    return _msgLb;
}
- (UILabel *)tipLb {
    if (!_tipLb) {
        _tipLb = [PW_ViewTool labelSemiboldText:@"" fontSize:13 textColor:[UIColor g_grayTextColor]];
        _tipLb.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLb;
}
- (UILabel *)descLb {
    if (!_descLb) {
        _descLb = [PW_ViewTool labelBoldText:@"" fontSize:21 textColor:[UIColor g_textColor]];
        _descLb.textAlignment = NSTextAlignmentCenter;
    }
    return _descLb;
}

@end
