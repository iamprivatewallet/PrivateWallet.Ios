//
//  PW_BackupWalletViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/30.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BackupWalletViewController.h"
#import "PW_ConfirmBackupViewController.h"

@interface PW_BackupWalletViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *mnemonicsView;

@end

@implementation PW_BackupWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_backupWallet")];
    [self makeViews];
}
- (void)changeAction {
    
}
- (void)verifyAction {
    [PW_TipTool showBackupTipSureBlock:^{
        PW_ConfirmBackupViewController *vc = [[PW_ConfirmBackupViewController alloc] init];
        vc.isFirst = self.isFirst;
        vc.wordStr = self.wordStr;
        vc.wallet = self.wallet;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [bodyView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [bodyView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
        make.height.greaterThanOrEqualTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_backupMnemonics") fontSize:20 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(36);
    }];
    UILabel *descLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_backupMnemonicsDesc") fontSize:14 textColor:[UIColor g_errorColor]];
    [self.contentView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(titleLb.mas_bottom).offset(6);
    }];
    UILabel *tipLb = [PW_ViewTool labelText:LocalizedStr(@"text_backupMnemonicsTip") fontSize:14 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(descLb.mas_bottom).offset(30);
    }];
    UIView *mnemonicsView = [[UIView alloc] init];
    mnemonicsView.backgroundColor = [UIColor g_bgCardColor];
    [mnemonicsView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.contentView addSubview:mnemonicsView];
    self.mnemonicsView = mnemonicsView;
    [mnemonicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(tipLb.mas_bottom).offset(16);
    }];
//    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [changeBtn setTitleColor:[UIColor g_grayTextColor] forState:UIControlStateNormal];
//    [changeBtn setTitle:LocalizedStr(@"text_changeGroup") forState:UIControlStateNormal];
//    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:changeBtn];
//    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mnemonicsView.mas_bottom).offset(15);
//        make.right.offset(-28);
//    }];
    UILabel *tip1Label = [PW_ViewTool labelText:LocalizedStr(@"text_backupMnemonicsTip1") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:tip1Label];
    UILabel *tip2Label = [PW_ViewTool labelText:LocalizedStr(@"text_backupMnemonicsTip2") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:tip2Label];
    UILabel *tip3Label = [PW_ViewTool labelText:LocalizedStr(@"text_backupMnemonicsTip3") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:tip3Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mnemonicsView.mas_bottom).offset(32);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1Label.mas_bottom).offset(10);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip2Label.mas_bottom).offset(10);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    UIButton *verifyBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_haveBackupVerify") fontSize:16 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(verifyAction)];
    [self.contentView addSubview:verifyBtn];
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(tip3Label.mas_bottom).offset(40);
        make.height.offset(55);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(-35);
    }];
    [self updateMnemonicsItems];
}
- (void)updateMnemonicsItems {
    NSArray *textArr = [self.wordStr componentsSeparatedByString:@" "];
    [self.mnemonicsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger column = 3;
    CGFloat padding = 20;
    CGFloat rowSpace = 15;
    CGFloat columnSpace = 12;
    CGFloat itemW = (SCREEN_WIDTH-72-2*padding-(column-1)*columnSpace)/column;
    UIView *lastView = nil;
    for (NSInteger i=0; i<textArr.count; i++) {
        NSString *text = textArr[i];
        UILabel *label = [PW_ViewTool labelText:text fontSize:13 textColor:[UIColor g_boldTextColor]];
        label.backgroundColor = [UIColor g_bgColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.layer.borderColor = [UIColor g_borderDarkColor].CGColor;
        label.layer.borderWidth = 1;
        [self.mnemonicsView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView==nil){
                make.top.offset(padding);
            }else{
                if(i%column>0){
                    make.top.equalTo(lastView);
                }else{
                    make.top.equalTo(lastView.mas_bottom).offset(rowSpace);
                }
            }
            if(i%column==0){
                make.left.offset(padding);
            }else{
                make.left.equalTo(lastView.mas_right).offset(columnSpace);
            }
            make.height.offset(30);
            make.width.offset(itemW);
            if(i==textArr.count-1){
                make.bottom.offset(-padding);
            }
        }];
        lastView = label;
    }
}

@end
