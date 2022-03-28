//
//  ExportCopyCodeView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ExportCopyCodeView.h"
#import "SGQRCode.h"

@interface ExportCopyCodeView()
@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIButton *showCodeButton;

@end
@implementation ExportCopyCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];

    }
    return self;
}
- (void)setCodeViewIsKeystore:(BOOL)isKeystore data:(id)data{
    NSString *str;
    if (isKeystore) {
        if ([data isKindOfClass:[NSString class]]) {
            str = data;
        }
    }else{
        if (data && [data isKindOfClass:[Wallet class]]) {
            Wallet *wallet = data;
            str = wallet.priKey;
        }
    }

    UIImage *img = [SGQRCodeObtain generateQRCodeWithData:str size:200];
    [self.codeButton setBackgroundImage:img forState:UIControlStateNormal];
}
- (void)makeViews{
    self.backgroundColor = [UIColor whiteColor];
    NSArray *list = @[
        @{
            @"title":@"仅供直接扫描",
            @"detail":@"二维码禁止保存、截图、以及拍照。仅供用户在安全环境下直接扫描来方便的导入钱包"
        },
        @{
            @"title":@"在安全环境下使用",
            @"detail":@"请在确保四周无人及无摄像头的情况下使用。二.维码一旦被他人获取将造成不可挽回的资产损失"
        },
       
    ];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor im_bgViewLightGray];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor im_borderLineColor];
    [bgView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    UIView *lastView = nil;
    for (int i = 0; i<list.count; i++) {
        UILabel *titleLbl = [ZZCustomView labelInitWithView:bgView text:list[i][@"title"] textColor:COLORFORRGB(0x146cb4) font:GCSFontRegular(14)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(CGFloatScale(20));
            make.right.equalTo(bgView).offset(-CGFloatScale(20));
            make.top.equalTo(lastView?lastView.mas_bottom:bgView).offset(lastView?13:33);
        }];
        
        UILabel *detailLbl = [ZZCustomView labelInitWithView:bgView text:list[i][@"detail"] textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(14)];
        detailLbl.numberOfLines = 0;
        [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleLbl);
            make.top.equalTo(titleLbl.mas_bottom);
            if (i == list.count-1) {
                make.bottom.equalTo(bgView).offset(-CGFloatScale(30));
            }
        }];
        lastView = detailLbl;
        
    }
    
    
    UIView *codeBgView = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBgView.backgroundColor = [UIColor im_bgViewLightGray];
    codeBgView.layer.cornerRadius = 8;
    [self addSubview:codeBgView];
    [codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(CGFloatScale(57));
        make.left.equalTo(self).offset(CGFloatScale(55));
        make.right.equalTo(self).offset(-CGFloatScale(55));
        make.height.mas_equalTo(ScreenWidth-CGFloatScale(110));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [codeBgView addRoundShandowoffset:CGSizeMake(0, 1) opacity:0.15 radius:8 circle:8];
    });
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton addTarget:self action:@selector(codeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [codeBgView addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(codeBgView).offset(CGFloatScale(25));
        make.right.bottom.equalTo(codeBgView).offset(-CGFloatScale(25));
    }];
    self.codeButton.hidden = YES;

    self.iconImage = [ZZCustomView imageViewInitView:codeBgView imageName:@"anonymous"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeBgView);
        make.top.equalTo(codeBgView).offset(CGFloatScale(25));
        make.width.height.mas_equalTo(CGFloatScale(80));
    }];
       
    self.showCodeButton = [ZZCustomView buttonInitWithView:codeBgView title:@"显示二维码" titleColor:[UIColor whiteColor] titleFont:GCSFontRegular(15) bgColor:[UIColor im_btnSelectColor]];
    self.showCodeButton.layer.cornerRadius = 7;
    [self.showCodeButton addTarget:self action:@selector(showCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.showCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeBgView.mas_bottom).offset(-CGFloatScale(25));
        make.centerX.equalTo(codeBgView);
        make.height.mas_equalTo(CGFloatScale(30));
        make.width.mas_equalTo(CGFloatScale(95));
    }];
}

- (void)showCodeButtonAction:(UIButton *)sender{
    self.iconImage.hidden = YES;
    self.showCodeButton.hidden = YES;
    self.codeButton.hidden = NO;
}
- (void)codeButtonAction:(UIButton *)sender{
    self.iconImage.hidden = NO;
    self.showCodeButton.hidden = NO;
    self.codeButton.hidden = YES;
}
@end
