//
//  ExportCopyTextView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ExportCopyTextView.h"


@interface ExportCopyTextView()<WarningAlertSheetViewDelegate>
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *nextStepButton;
@property(nonatomic, assign) BOOL isKeystore;
@property (nonatomic, strong) UIView *contentBgView;

@end
@implementation ExportCopyTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];

    }
    return self;
}
- (void)setViewIsKeystore:(BOOL)isKeystore data:(id)data{
    self.isKeystore = isKeystore;
    if (isKeystore) {
        [self.nextStepButton setTitle:@"复制Keystore" forState:UIControlStateNormal];
        self.contentTextView.text = data;
        [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGFloatScale(140));
        }];
    }else{
        [self.nextStepButton setTitle:@"复制私钥" forState:UIControlStateNormal];
        Wallet *wallet = data;
        self.contentTextView.text = wallet.priKey;
    }
   
}
- (void)makeViews{
    self.backgroundColor = [UIColor whiteColor];
    NSArray *list = @[
        @{
            @"title":@"离线保存",
            @"detail":@"切勿保存至邮箱、记事本、网盘、聊天工具等，非常危险"
        },
        @{
            @"title":@"请勿使用网络传输",
            @"detail":@"请勿通过网络工具传输，一旦被黑客获取将造成不可挽回的资产损失。建议离线设备通过扫二维码方式传输。"
        },
        @{
            @"title":@"密码管理工具保存",
            @"detail":@"建议使用密码管理工具管理"
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
    
    self.contentBgView = [[UIView alloc] init];
    self.contentBgView.backgroundColor = [UIColor im_bgViewLightGray];
    self.contentBgView.layer.cornerRadius = 8;
    self.contentBgView.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    self.contentBgView.layer.borderWidth = 1;
    [self addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CGFloatScale(20));
        make.right.equalTo(self).offset(-CGFloatScale(20));
        make.top.equalTo(bgView.mas_bottom).offset(CGFloatScale(57));

    }];
    
    self.contentTextView = [ZZCustomView textViewInitFrame:CGRectZero view:self.contentBgView delegate:nil font:GCSFontRegular(13) textColor:[UIColor im_textColor_three]];
    self.contentTextView.backgroundColor = self.contentBgView.backgroundColor;
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBgView);
        make.left.equalTo(self.contentBgView).offset(10);
        make.right.equalTo(self.contentBgView).offset(-10);
        make.bottom.equalTo(self.contentBgView).offset(-5);
        make.height.mas_equalTo(CGFloatScale(45));

    }];
    
    self.nextStepButton = [ZZCustomView im_ButtonDefaultWithView:self title:@"" titleFont:GCSFontRegular(18) enable:YES];
    [self.nextStepButton addTarget:self action:@selector(nextStepButtonAction) forControlEvents: UIControlEventTouchUpInside];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CGFloatScale(20));
        make.right.equalTo(self).offset(-CGFloatScale(20));
        make.top.equalTo(self.contentBgView.mas_bottom).offset(CGFloatScale(35));
        make.height.mas_equalTo(45);
    }];
}

- (void)nextStepButtonAction{
   WarningAlertSheetView *sheetView = [WarningAlertSheetView showExportAlertViewIsKeystore:self.isKeystore];
    sheetView.delegate = self;
}

- (void)warningAlertSheetViewAction{
    
    [UITools pasteboardWithStr:self.contentTextView.text toast:@"已复制"];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
