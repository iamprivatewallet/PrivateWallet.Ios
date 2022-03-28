//
//  MnemonicsBackupVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/23.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MnemonicsBackupVC.h"
#import "MnemonicsView.h"
#import "MnemonicsConfirmVC.h"
#define TAGVIEW_H CGFloatScale(230)

@interface MnemonicsBackupVC ()
@property (nonatomic, strong) MnemonicsView *wordView;
@property (nonatomic, copy) NSString *wordStr;

@end

@implementation MnemonicsBackupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"" isWhiteBg:YES];
    [self makeViews];
    [self loadTagView];

    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.view text:@"备份助记词" textColor:[UIColor blackColor] font:GCSFontRegular(16)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
    UILabel *detailTitleLbl = [ZZCustomView labelInitWithView:self.view text:@"请按顺序抄写助记词，确保备份正确" textColor:[UIColor im_textColor_six] font:GCSFontRegular(14)];
    detailTitleLbl.numberOfLines = 0;
    [detailTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(titleLbl.mas_bottom);
    }];
    
    UILabel *tip1 = [ZZCustomView labelInitWithView:self.view text:@"妥善保管助记词至隔离网络的安全地方。" textColor:[UIColor im_textColor_six] font:GCSFontRegular(16)];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(detailTitleLbl.mas_bottom).offset(TAGVIEW_H+CGFloatScale(50));
    }];
    UIView *spot = [[UIView alloc] init];
    spot.backgroundColor = [UIColor im_textColor_nine];
    spot.layer.cornerRadius = 2.5;
    [self.view addSubview:spot];
    [spot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(tip1);
        make.width.height.mas_equalTo(5);
    }];
    
    UILabel *tip2 = [ZZCustomView labelInitWithView:self.view text:@"请勿将助记词在联网环境下分享和存储，比如邮件、相册、社交应用等。" textColor:[UIColor im_textColor_six] font:GCSFontRegular(16)];
    tip2.numberOfLines = 0;
    [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip1);
        make.right.equalTo(tip1);
        make.top.equalTo(tip1.mas_bottom).offset(10);
    }];
    UIView *spot2 = [[UIView alloc] init];
    spot2.backgroundColor = spot.backgroundColor;
    spot2.layer.cornerRadius = 2.5;
    [self.view addSubview:spot2];
    [spot2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spot);
        make.top.equalTo(tip2).offset(10);
        make.width.height.mas_equalTo(5);
    }];
   
    UIButton *nextStepBtn = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"已确认备份" titleFont:GCSFontRegular(16) enable:YES];
    [nextStepBtn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-25-kBottomSafeHeight);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(45);
    }];
}

- (void)loadTagView {

    if (self.wallet.mnemonic) {//如果是后导入的，备份钱包走这个
        self.wordStr = self.wallet.mnemonic;

    }else{
        //已有的身份钱包走这个
        self.wordStr = User_manager.currentUser.user_mnemonic;
    }
    
    self.wordView = [[MnemonicsView alloc] initWithFrame:CGRectMake(CGFloatScale(20), CGFloatScale(60)+kNavBarAndStatusBarHeight, ScreenWidth-CGFloatScale(40), TAGVIEW_H) words:[self.wordStr componentsSeparatedByCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]]];
    [self.view addSubview:self.wordView];
    //brass patch seek foot fatal comfort voice chief corn pave skate mask
}

- (void)nextStepAction{
    MnemonicsConfirmVC *vc = [[MnemonicsConfirmVC alloc] init];
    vc.wordStr = self.wordStr;
    vc.wallet = self.wallet;
    vc.isFirstBackup = self.isFirstBackup;
    [self.navigationController pushViewController:vc animated:YES];
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
