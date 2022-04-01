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
    
    [self setNavNoLineTitle:LocalizedStr(@"text_createWallet") rightImg:@"icon_share" rightAction:@selector(shareAction)];
    [self makeViews];
}
- (void)shareAction {
    
}
- (void)nextAction {
    if([self compareSuccess]){
        if (![User_manager isBackup]) {
            User_manager.currentUser.user_is_backup = YES;
            [User_manager saveTask];
        }
        [PW_ToastTool showSucees:LocalizedStr(@"text_finishedWalletCreate") toView:self.view];
        [TheAppDelegate switchToTabBarController];
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
            [PW_ToastTool showError:LocalizedStr(@"text_verifyMnemonicError") toView:self.view];
        }
        return isEqual&&self.seletedArr.count==self.wordArr.count;
    }else{
        [PW_ToastTool showError:LocalizedStr(@"text_verifyMnemonicError") toView:self.view];
        return NO;
    }
}
- (void)makeViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-SafeBottomInset);
    }];
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.width.equalTo(scrollView);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_verifyMnemonic") fontSize:15 textColor:[UIColor g_boldTextColor]];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(25);
    }];
    UILabel *descLb = [PW_ViewTool labelText:LocalizedStr(@"text_verifyMnemonicTip") fontSize:12 textColor:[UIColor g_grayTextColor]];
    [self.contentView addSubview:descLb];
    [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(-25);
        make.top.equalTo(titleLb.mas_bottom).offset(6);
    }];
    UIView *showMnemonicsView = [[UIView alloc] init];
    showMnemonicsView.backgroundColor = [UIColor g_bgColor];
    showMnemonicsView.layer.cornerRadius = 8;
    showMnemonicsView.layer.borderWidth = 2;
    showMnemonicsView.layer.borderColor = [UIColor g_borderColor].CGColor;
    [self.contentView addSubview:showMnemonicsView];
    self.showMnemonicsView = showMnemonicsView;
    UIView *mnemonicsView = [[UIView alloc] init];
    [self.contentView addSubview:mnemonicsView];
    self.mnemonicsView = mnemonicsView;
    [showMnemonicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(descLb.mas_bottom).offset(12);
        make.height.equalTo(mnemonicsView);
    }];
    [mnemonicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(showMnemonicsView.mas_bottom);
    }];
    UIButton *nextBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_nextStep") fontSize:16 titleColor:[UIColor whiteColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(nextAction)];
    [self.contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mnemonicsView.mas_bottom).offset(35);
        make.height.offset(55);
        make.left.offset(25);
        make.right.offset(-25);
        make.bottom.offset(-40);
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
    CGFloat itemW = (SCREEN_WIDTH-40-2*padding-(column-1)*columnSpace)/column;
    UIView *lastView = nil;
    NSInteger count = self.seletedArr.count;
    for (NSInteger i=0; i<count; i++) {
        NSString *text = self.seletedArr[i];
        UIButton *button = [PW_ViewTool buttonSemiboldTitle:text fontSize:15 titleColor:[UIColor g_boldTextColor] cornerRadius:17.5 backgroundColor:nil target:nil action:nil];
        button.layer.borderColor = [UIColor g_borderColor].CGColor;
        button.layer.borderWidth = 1;
        button.tag = i;
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        deleteBtn.tag = i;
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"icon_close_warn"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-4);
            make.top.offset(2);
        }];
        [self.showMnemonicsView addSubview:button];
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
            make.height.offset(35);
            make.width.offset(itemW);
        }];
        lastView = button;
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
    CGFloat itemW = (SCREEN_WIDTH-40-2*padding-(column-1)*columnSpace)/column;
    UIView *lastView = nil;
    NSInteger count = self.randomWordArr.count;
    for (NSInteger i=0; i<count; i++) {
        NSString *text = self.randomWordArr[i];
        UIButton *button = [PW_ViewTool buttonSemiboldTitle:text fontSize:15 titleColor:[UIColor g_boldTextColor] cornerRadius:17.5 backgroundColor:nil target:nil action:nil];
        BOOL isSeleted = [self.seletedArr containsObject:text];
        button.enabled = !isSeleted;
        button.layer.opacity = isSeleted?0.5:1;
        button.layer.borderColor = [UIColor g_borderColor].CGColor;
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
            make.height.offset(35);
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
