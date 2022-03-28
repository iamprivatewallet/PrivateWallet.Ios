//
//  MnemonicsBackupConfirmVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/23.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MnemonicsConfirmVC.h"
#import "WalletTagView.h"

#define TAGVIEW_H CGFloatScale(260)*2
@interface MnemonicsConfirmVC ()
@property (nonatomic, strong) WalletTagView *tagView;
@property (nonatomic, strong) UIButton *nextStepBtn;

@end

@implementation MnemonicsConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"" isWhiteBg:YES];

    [self makeViews];
   
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.view text:@"确认助记词" textColor:[UIColor blackColor] font:GCSFontRegular(16)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
    UILabel *detailTitleLbl = [ZZCustomView labelInitWithView:self.view text:@"请按顺序点击助记词，以确认您正确备份。" textColor:[UIColor im_textColor_six] font:GCSFontRegular(14)];
    detailTitleLbl.numberOfLines = 0;
    [detailTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(titleLbl.mas_bottom);
    }];
    
    self.tagView = [[WalletTagView alloc] initWithFrame:CGRectMake(CGFloatScale(20), CGFloatScale(60)+kNavBarAndStatusBarHeight, ScreenWidth-CGFloatScale(40),TAGVIEW_H)
                                                     isEdit:YES
                                                      words:[self.wordStr componentsSeparatedByCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]]];
    [self.view addSubview:self.tagView];
    
    
    self.nextStepBtn = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"下一步" titleFont:GCSFontRegular(16) enable:YES];
    [self.nextStepBtn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-25-kBottomSafeHeight);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(45);
    }];
}

- (void)nextStepAction{
    if (!self.tagView.isFinished) {
        [UITools showToast:@"请正确填写助记词"];
        return;
    }
    [self showSuccessMessage:@"助记词正确"];
    if (self.isFirstBackup) {
        if (self.wallet) {
            //创建单个钱包
            self.wallet.isImport = @"1";
            [FchainTool genWalletWithMnemonic:self.wordStr withWallet:self.wallet block:^(BOOL sucess) {
                self.nextStepBtn.userInteractionEnabled = YES;
                if (sucess) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
            }];
        }else{
            
            User_manager.currentUser.user_is_backup = YES;
            [User_manager saveTask];
            [TheAppDelegate switchToTabBarController];            
        }
    }else{
        if (![User_manager isBackup]) {
            User_manager.currentUser.user_is_backup = YES;
            [User_manager saveTask];
        }
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"MangeIDWalletVC")]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:vc animated:YES];
                });
            }
        }
    }
    
}

@end
