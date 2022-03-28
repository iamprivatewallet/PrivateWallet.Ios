//
//  ETH2.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ETHWalletManageVC.h"

@interface ETHWalletManageVC ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *keyAddrLbl;

@end

@implementation ETHWalletManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"" rightImg:@"helpBlack" rightAction:@selector(navRightItemAction)];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)navRightItemAction{
    
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    UILabel *title = [ZZCustomView labelInitWithView:self.view text:@"以太坊2.0钱包管理" textColor:[UIColor blackColor] font:GCSFontSemibold(25)];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(CGFloatScale(25));
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight+15);
    }];
    
    self.bgView = [ZZCustomView viewInitWithView:self.view bgColor:COLORFORRGB(0xd1f3fa)];
    self.bgView.layer.cornerRadius = 14;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(CGFloatScale(15));
        make.right.equalTo(self.view).offset(-CGFloatScale(15));
        make.top.equalTo(title.mas_bottom).offset(CGFloatScale(10));
        make.height.mas_equalTo(145);
    }];
    self.iconImage = [ZZCustomView imageViewInitView:self.bgView imageName:@"eth2StakingFullLogo"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.height.mas_equalTo(82);
        make.width.mas_equalTo(55);
    }];
    
    self.createButton = [ZZCustomView buttonInitWithView:self.bgView title:@"创建" titleColor:[UIColor whiteColor] titleFont:GCSFontMedium(15) bgColor:COLORFORRGB(0x76c8da)];
    [self.createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.createButton.layer.cornerRadius = 19;
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(140);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
        make.top.equalTo(self.bgView).offset(CGFloatScale(25));
    }];
    [self.keyAddrLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(20));
        make.top.equalTo(self.titleLbl.mas_bottom).offset(CGFloatScale(15));
    }];
    [self makeBottomLabels];
        
    self.keyAddrLbl.attributedText = [UITools appendImageWithLabelText:@"3njekjekgwh3hgkh" image:@"eth2Copy"];
}

- (void)makeBottomLabels{
    NSArray *list = @[
        @"Eth2公钥由当前Eth1钱包的助记词生成",
        @"你可以使用当前Eth1钱包的助记词管理Eth2",
        @"请安全备份Eth1钱包助记词"
    ];
    UIView *lastView = nil;
    for (int i = 0; i<list.count; i++) {
        
        UILabel *title = [ZZCustomView labelInitWithView:self.view text:list[i] textColor:[UIColor im_textColor_nine] font:GCSFontRegular(13)];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(CGFloatScale(35));
            make.top.equalTo(lastView?lastView.mas_bottom:self.bgView.mas_bottom).offset(lastView?5:20);
        }];
        
        UIView *spotView = [ZZCustomView viewInitWithView:self.view bgColor:[UIColor im_textColor_nine]];
        [spotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(2, 2));
            make.centerY.equalTo(title);
            make.right.equalTo(title.mas_left).offset(-5);
        }];
        
        lastView = title;
    }
}

- (void)createButtonAction{
    [TokenAlertView showInputPasswordWithTitle:@"钱包密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
        if (index == 1) {
            [self changeBgView];
        }
    }];
}
- (void)changeBgView{
    self.bgView.backgroundColor = COLORFORRGB(0x75c8da);
    self.createButton.hidden = YES;
    self.titleLbl.hidden = NO;
    self.keyAddrLbl.hidden = NO;
    self.iconImage.alpha = 0.15;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"公钥地址" textColor:[UIColor whiteColor] font:GCSFontMedium(15)];
        _titleLbl.hidden = YES;
    }
    return _titleLbl;
}

- (UILabel *)keyAddrLbl{
    if (!_keyAddrLbl) {
        _keyAddrLbl = [ZZCustomView labelInitWithView:self.bgView text:@"" textColor:[UIColor whiteColor] font:GCSFontRegular(13)];
        _keyAddrLbl.numberOfLines = 0;
        _keyAddrLbl.hidden = YES;
    }
    return _keyAddrLbl;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
