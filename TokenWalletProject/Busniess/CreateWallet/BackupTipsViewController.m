//
//  MnemonicsBackupTipsVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/23.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BackupTipsViewController.h"
#import "WarningAlertSheetView.h"
#import "MnemonicsBackupVC.h"
#import "ExportKeystoreAndPrivateKeyVC.h"

@interface BackupTipsViewController ()
@property (nonatomic, strong) UIButton *backupNowBtn;
@property (nonatomic, strong) UIButton *backupLaterBtn;

@property (nonatomic, strong) WarningAlertSheetView *shotView;
@property(nonatomic, assign) kBackupType backupType;
@end

@implementation BackupTipsViewController

- (instancetype)initWithType:(kBackupType)backupType
{
    if (self = [super init]) {
        self.backupType = backupType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFirstBackup && !self.wallet) {
        [self setNavTitle:@"" isNoLine:YES isWhiteBg:YES];
        //禁止返回
        id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
        [self.view addGestureRecognizer:pan];
    }else{
        [self setNav_NoLine_WithLeftItem:@"" isWhiteBg:YES];
    }
    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:ImageNamed(@"backup")];
    [self.view addSubview:iconImage];
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(CGFloatScale(40)+kNavBarAndStatusBarHeight);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(CGFloatScale(80));
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.view text:@"备份提示" textColor:[UIColor blackColor] font:GCSFontRegular(18)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(iconImage.mas_bottom).offset(35);
    }];
    NSString *detailStr;
    NSString *tipStr1 = @"使用纸笔正确抄写，并保管至安全的地方。";
    NSString *tipStr2;

    if (self.backupType == kBackupTypeMnemonic) {
        detailStr = @"获得助记词等于拥有钱包资产所有权";
        tipStr1 = @"助记词由英文单词组成，请抄写并妥善保管。";
        tipStr2 = @"助记词丢失，无法找回，请务必备份助记词。";
    }else if (self.backupType == kBackupTypePrivateKey) {
        detailStr = @"获得私钥等于拥有钱包资产所有权";
        tipStr2 = @"私钥丢失，无法找回，请务必备份私钥。";
    }else{
        detailStr = @"获得Keystore和密码等于拥有钱包资产所有权";
        tipStr2 = @"Keystore丢失，无法找回，请务必备份Keystore。";
    }
    UILabel *detailLbl = [ZZCustomView labelInitWithView:self.view text:detailStr textColor:[UIColor im_textColor_six] font:GCSFontRegular(16)];
    [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.top.equalTo(titleLbl.mas_bottom).offset(5);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor mp_lineGrayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailLbl);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(detailLbl.mas_bottom).offset(18);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *tip1 = [ZZCustomView labelInitWithView:self.view text:tipStr1 textColor:[UIColor im_textColor_six] font:GCSFontRegular(16)];
    tip1.numberOfLines = 0;
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
    UIView *spot = [[UIView alloc] init];
    spot.backgroundColor = [UIColor im_textColor_nine];
    spot.layer.cornerRadius = 2.5;
    [self.view addSubview:spot];
    [spot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.centerY.equalTo(tip1);
        make.width.height.mas_equalTo(5);
    }];
    
    
    UILabel *tip2 = [ZZCustomView labelInitWithView:self.view text:tipStr2 textColor:[UIColor im_textColor_six] font:GCSFontRegular(16)];
    tip2.numberOfLines = 0;
    [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip1);
        make.top.equalTo(tip1.mas_bottom).offset(20);
    }];
    UIView *spot2 = [[UIView alloc] init];
    spot2.backgroundColor = spot.backgroundColor;
    spot2.layer.cornerRadius = 2.5;
    [self.view addSubview:spot2];
    [spot2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spot);
        make.centerY.equalTo(tip2);
        make.width.height.mas_equalTo(5);
    }];
    NSString *btnStr;
    BOOL isTwoBtn = self.isFirstBackup && !self.wallet;
    if (isTwoBtn) {
        btnStr = @"立即备份";
        self.backupLaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backupLaterBtn setTitle:@"稍后备份" forState:UIControlStateNormal];
        [self.backupLaterBtn setTitleColor:[UIColor im_btnSelectColor] forState:UIControlStateNormal];
        self.backupLaterBtn.titleLabel.font = GCSFontRegular(16);
        [self.backupLaterBtn addTarget:self action:@selector(backupLaterBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backupLaterBtn];

        [self.backupLaterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.height.mas_equalTo(CGFloatScale(45));
            make.bottom.equalTo(self.view).offset(-45);
        }];
    }else{
        btnStr = @"下一步";
    }
    
    self.backupNowBtn = [ZZCustomView im_ButtonDefaultWithView:self.view title:btnStr titleFont:GCSFontRegular(16) enable:YES];
    [self.backupNowBtn addTarget:self action:@selector(backupNowBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backupNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(CGFloatScale(45));
        if (isTwoBtn) {
            make.bottom.equalTo(self.backupLaterBtn.mas_top).offset(-8);
        }else{
            make.bottom.equalTo(self.view).offset(-15-kBottomSafeHeight);
        }
    }];
}
//立即备份
- (void)backupNowBtnAction{
    [WarningAlertSheetView showAlertViewWithIcon:@"screenShotBan" title:@"请勿截屏" content:@"请勿截屏分享和存储，这将可能被第三方恶意软件收集，造成资产损失" btnText:@"知道了" btnBgColor:[UIColor im_btnSelectColor] action:^{
        [self warningAlertSheetViewAction];
    }];
}

//稍后备份
- (void)backupLaterBtnAction{
    [TheAppDelegate switchToTabBarController];
}

- (void)warningAlertSheetViewAction{
    if (self.backupType != kBackupTypeMnemonic) {
        //导出私钥、keystore
        ExportKeystoreAndPrivateKeyVC *vc = [[ExportKeystoreAndPrivateKeyVC alloc] init];
        vc.wallet = self.wallet;
        if(self.backupType == kBackupTypeKeystore){
            vc.exportType = kExportTypeKeystore;
        }else{
            vc.exportType = kExportTypePrivateKey;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //备份页
        MnemonicsBackupVC *vc = [[MnemonicsBackupVC alloc] init];
        vc.wallet = self.wallet;
        vc.isFirstBackup = self.isFirstBackup;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
