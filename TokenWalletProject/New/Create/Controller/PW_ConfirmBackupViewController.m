//
//  PW_ConfirmBackupViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/31.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_ConfirmBackupViewController.h"

@interface PW_ConfirmBackupViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIView *showMnemonicsView;
@property (nonatomic, weak) UIView *mnemonicsView;
@property (nonatomic, weak) UIButton *nextBtn;

@property (nonatomic, copy) NSArray *wordArr;
@property (nonatomic, copy) NSArray *randomWordArr;
@property (nonatomic, strong) NSMutableArray *seletedArr;

@end

@implementation PW_ConfirmBackupViewController

- (void)setWordStr:(NSString *)wordStr {
    _wordStr = wordStr;
    self.wordArr = [self.wordStr componentsSeparatedByString:@" "];
}

- (NSArray *)randomWordArr {
    if(!_randomWordArr){
        _randomWordArr = [self.wordArr random];
    }
    return _randomWordArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_createWallet")];
    [self makeViews];
}
- (void)nextAction {
    if([self compareSuccess]){
        if (self.isFirst) {
            if (self.wallet) {//创建单个钱包
                self.wallet.isImport = @"1";
                if ([self.wallet.type isEqualToString:kWalletTypeSolana]) {
                    [[PW_WalletManager shared] saveWallet:self.wallet];
                    [self showSuccess:LocalizedStr(@"text_finishedWalletCreate")];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    self.nextBtn.userInteractionEnabled = NO;
                    [self.view showLoadingIndicator];
                    [FchainTool genWalletWithMnemonic:self.wordStr withWallet:self.wallet block:^(BOOL sucess) {
                        [self.view hideLoadingIndicator];
                        self.nextBtn.userInteractionEnabled = YES;
                        if (sucess) {
                            [self showSuccess:LocalizedStr(@"text_finishedWalletCreate")];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }];
                }
            }else{
                if (![User_manager isBackup]) {
                    User_manager.currentUser.user_is_backup = YES;
                    [User_manager saveTask];
                }
                [self showSuccess:LocalizedStr(@"text_finishedWalletCreate")];
                [TheAppDelegate switchToTabBarController];
            }
        }else{
            if (![User_manager isBackup]) {
                User_manager.currentUser.user_is_backup = YES;
                [User_manager saveTask];
            }
            [self showSuccess:LocalizedStr(@"text_backupSuccess")];
            NSArray *array = self.navigationController.viewControllers;
            if (array.count>2) {
                UIViewController *vc = array[array.count-3];
                [self.navigationController popToViewController:vc animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
- (BOOL)compareSuccess {
    if(self.seletedArr.count<=self.wordArr.count){
        BOOL isEqual = YES;
        for (NSInteger i=0; i<self.seletedArr.count; i++) {
            NSString *text = self.seletedArr[i];
            if (![text isEqualToString:self.wordArr[i]]) {
                isEqual = NO;
                break;
            }
        }
        if(!isEqual){
            [self showError:LocalizedStr(@"text_verifyMnemonicError")];
        }
        return isEqual&&self.seletedArr.count==self.wordArr.count;
    }else{
        [self showError:LocalizedStr(@"text_verifyMnemonicError")];
        return NO;
    }
}
- (void)makeViews {
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:bodyView];
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
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
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_verifyMnemonic") fontSize:20 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(36);
    }];
    UILabel *descLb = [PW_ViewTool labelText:LocalizedStr(@"text_verifyMnemonicTip") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(titleLb.mas_bottom).offset(6);
    }];
    UIView *showMnemonicsView = [[UIView alloc] init];
    showMnemonicsView.backgroundColor = [UIColor g_bgCardColor];
    [showMnemonicsView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [self.contentView addSubview:showMnemonicsView];
    self.showMnemonicsView = showMnemonicsView;
    UIView *mnemonicsView = [[UIView alloc] init];
    [self.contentView addSubview:mnemonicsView];
    self.mnemonicsView = mnemonicsView;
    [showMnemonicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(descLb.mas_bottom).offset(12);
        make.height.equalTo(mnemonicsView);
    }];
    [mnemonicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(36);
        make.right.offset(-36);
        make.top.equalTo(showMnemonicsView.mas_bottom);
    }];
    UIButton *nextBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_nextStep") fontSize:16 titleColor:[UIColor whiteColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(nextAction)];
    [self.contentView addSubview:nextBtn];
    self.nextBtn = nextBtn;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(mnemonicsView.mas_bottom).offset(35);
        make.height.offset(55);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.offset(-35);
    }];
    [self updateMnemonicsItems];
}
- (void)deleteClick:(UIButton *)btn {
    [self.seletedArr removeObjectAtIndex:btn.tag];
    [self updateMnemonicsItems];
    [self updateMnemonicsShowItems];
}
- (void)updateMnemonicsShowItems {
    [self.showMnemonicsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger column = 3;
    CGFloat padding = 20;
    CGFloat rowSpace = 15;
    CGFloat columnSpace = 12;
    CGFloat itemW = (SCREEN_WIDTH-72-2*padding-(column-1)*columnSpace)/column;
    UIView *lastView = nil;
    NSInteger count = self.seletedArr.count;
    for (NSInteger i=0; i<count; i++) {
        NSString *text = self.seletedArr[i];
        UIView *bodyView = [[UIView alloc] init];
        [self.showMnemonicsView addSubview:bodyView];
        UIButton *button = [PW_ViewTool buttonTitle:text fontSize:13 weight:UIFontWeightRegular titleColor:[UIColor g_boldTextColor] cornerRadius:10 backgroundColor:nil target:nil action:nil];
        button.layer.borderColor = [UIColor g_borderDarkColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = NO;
        button.tag = i;
        [bodyView addSubview:button];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        deleteBtn.tag = i;
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_close_danger"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [bodyView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_right);
            make.centerY.equalTo(button.mas_top);
        }];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.width.offset(itemW);
            make.left.bottom.offset(0);
        }];
        [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView==nil){
                make.top.offset(padding-rowSpace);
            }else{
                if(i%column>0){
                    make.top.equalTo(lastView);
                }else{
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                }
            }
            if(i%column==0){
                make.left.offset(padding);
            }else{
                make.left.equalTo(lastView.mas_right).offset(0);
            }
            make.height.offset(30+rowSpace);
            make.width.offset(itemW+columnSpace);
        }];
        lastView = bodyView;
    }
}
- (void)itemClick:(UIButton *)btn {
    btn.enabled = NO;
    btn.layer.opacity = 0.5;
    [self.seletedArr addObject:btn.titleLabel.text];
    [self updateMnemonicsShowItems];
    [self compareSuccess];
}
- (void)updateMnemonicsItems {
    [self.mnemonicsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger column = 3;
    CGFloat padding = 20;
    CGFloat rowSpace = 15;
    CGFloat columnSpace = 12;
    CGFloat itemW = (SCREEN_WIDTH-72-2*padding-(column-1)*columnSpace)/column;
    UIView *lastView = nil;
    NSInteger count = self.randomWordArr.count;
    for (NSInteger i=0; i<count; i++) {
        NSString *text = self.randomWordArr[i];
        UIButton *button = [PW_ViewTool buttonTitle:text fontSize:13 weight:UIFontWeightRegular titleColor:[UIColor g_boldTextColor] cornerRadius:10 backgroundColor:nil target:nil action:nil];
        BOOL isSeleted = [self.seletedArr containsObject:text];
        button.enabled = !isSeleted;
        button.layer.opacity = isSeleted?0.5:1;
        button.layer.borderColor = [UIColor g_borderDarkColor].CGColor;
        button.layer.borderWidth = 1;
        button.tag = i;
        [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mnemonicsView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
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
            if(i==count-1){
                make.bottom.offset(-padding);
            }
        }];
        lastView = button;
    }
}

- (NSMutableArray *)seletedArr {
    if(!_seletedArr){
        _seletedArr = [NSMutableArray array];
    }
    return _seletedArr;
}

@end
