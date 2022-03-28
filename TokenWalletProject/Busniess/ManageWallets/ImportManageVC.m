//
//  ImportManageVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/20.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ImportManageVC.h"
#import "SecretFreeViewController.h"
#import "BackupTipsViewController.h"
#import "ETHWalletManageVC.h"
#import "PasswordTipsVC.h"


@interface ImportManageVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) BOOL isSeniorState;

@end

@implementation ImportManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"管理"];
    [self makeViews];

    // Do any additional setup after loading the view.
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// MARK: TableViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if(section == 1){
        BOOL isTips = self.wallet.walletPasswordTips;
        if (self.isSeniorState) {
            //高级模式
            return isTips?6:5;
        }else{
            
            return isTips?4:3;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mainCell";
    
    UITableViewCell *mainCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mainCell) {
        mainCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    for (UIView *subView in mainCell.contentView.subviews) {
        [[subView viewWithTag:10] removeFromSuperview];
        [[subView viewWithTag:11] removeFromSuperview];
        [[subView viewWithTag:12] removeFromSuperview];

    }
    UIImageView *arrowImg = [ZZCustomView imageViewInitView:mainCell.contentView imageName:@"arrowRightGray"];
    arrowImg.tag = 10;
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainCell.contentView).offset(-CGFloatScale(20));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(15), CGFloatScale(15)));
        make.centerY.equalTo(mainCell.contentView);
    }];
    mainCell.contentView.backgroundColor = [UIColor whiteColor];
    mainCell.textLabel.font = GCSFontRegular(16);
    mainCell.textLabel.textColor = [UIColor im_textColor_three];
    [mainCell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainCell.contentView).offset(CGFloatScale(20));
        make.centerY.equalTo(mainCell.contentView);
    }];
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            mainCell.textLabel.text = @"钱包地址";
            arrowImg.hidden = YES;
            [mainCell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mainCell.contentView).offset(CGFloatScale(20));
                make.top.equalTo(mainCell.contentView).offset(CGFloatScale(8));
            }];
            UILabel *addrLbl = [ZZCustomView labelInitWithView:mainCell.contentView text:self.wallet.address textColor:[UIColor im_textColor_six] font:GCSFontRegular(13)];
            addrLbl.tag = 11;

            [addrLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mainCell.contentView).offset(CGFloatScale(20));
                make.top.equalTo(mainCell.textLabel.mas_bottom);
                make.right.equalTo(mainCell.contentView).offset(-10);
            }];
            
        }else{
            mainCell.textLabel.text = @"钱包名称";
            UILabel *nameLbl = [ZZCustomView labelInitWithView:mainCell.contentView text:self.wallet.walletName textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
            nameLbl.tag = 12;

            [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(arrowImg.mas_left).offset(-12);
                make.centerY.equalTo(mainCell.contentView);
            }];
            
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0 || (indexPath.row == 1 && self.wallet.walletPasswordTips)) {
            mainCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth*2);
        }
        [self changeItemWithCell:mainCell indexPath:indexPath arrowImg:arrowImg];
       
    }else if (indexPath.section == 2) {
        mainCell.textLabel.text = @"以太坊2.0钱包管理";

    }else {
        arrowImg.hidden = YES;
        mainCell.textLabel.text = @"移除";
//        mainCell.textLabel.textAlignment = NSTextAlignmentCenter;
        mainCell.textLabel.textColor = [UIColor im_redColor];
        [mainCell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(mainCell.contentView);
        }];
    }
    
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return mainCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGFloatScale(56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFloatScale(15);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            //钱包地址
            if (indexPath.row == 0) {
                [UITools pasteboardWithStr:self.wallet.address toast:@"地址已复制"];
            }else{
                //钱包名称
                [self changeWalletName];
            }
        }
            break;
        case 1:{
            BOOL isTips = self.wallet.walletPasswordTips;

            if (indexPath.row == 0) {
                //备份钱包
                [self backupWallet];
            }else if (indexPath.row == 1) {
                //免密支付
                SecretFreeViewController *vc = [[SecretFreeViewController alloc] init];
                vc.wallet = self.wallet;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 2) {
                if (isTips) {
                    //密码提示
                    PasswordTipsVC *vc = [[PasswordTipsVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    //高级模式
                    self.isSeniorState = !self.isSeniorState;
                    [tableView reloadData];
                }
                
            }else if (indexPath.row == 3) {
                if (isTips) {
                    //高级模式
                    self.isSeniorState = !self.isSeniorState;
                    [tableView reloadData];
                    
                }else{
                    // 导出keystore | 导出私钥
                    [self exportKeystoreAndKeyWithIndexPath:indexPath];
                }
                
            }else{
                // 导出keystore | 导出私钥
                [self exportKeystoreAndKeyWithIndexPath:indexPath];
            }
        }
            break;
        case 2:{
            //2.0钱包管理
            ETHWalletManageVC *vc = [[ETHWalletManageVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            //移除钱包
            [self deleteWallet];
        }
            break;
    }
            
}
// 导出keystore | 导出私钥
- (void)exportKeystoreAndKeyWithIndexPath:(NSIndexPath *)indexPath{
    [TokenAlertView showInputPasswordWithTitle:@"请输入密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
        if (![self.wallet.walletPassword isEqualToString:inputText]) {
            [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"好"];
        }else{
            BOOL isTips = self.wallet.walletPasswordTips ?indexPath.row==4:indexPath.row==3;
            kBackupType type = isTips?kBackupTypeKeystore:kBackupTypePrivateKey;
            BackupTipsViewController *vc = [[BackupTipsViewController alloc] initWithType:type];
            vc.wallet = self.wallet;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
}
//移除钱包
- (void)deleteWallet{
    [TokenAlertView showInputPasswordWithTitle:@"请输入密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
        if (![self.wallet.walletPassword isEqualToString:inputText]) {
            [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"好"];
        }else{
            [[WalletManager shareWalletManager] deleteWallet:self.wallet];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }

    }];
}
//备份钱包
- (void)backupWallet{
    [TokenAlertView showInputPasswordWithTitle:@"请输入密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
        if (![self.wallet.walletPassword isEqualToString:inputText]) {
            [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"好"];
        }else{
            BackupTipsViewController *vc = [[BackupTipsViewController alloc] initWithType:kBackupTypeMnemonic];
            vc.wallet = self.wallet;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
}
//钱包名称
- (void)changeWalletName{
    [TokenAlertView showViewWithTitle:@"钱包名称" textField_p:self.wallet.walletName action:^(NSInteger index, NSString * _Nonnull inputText) {
//        if (![inputText isEmptyStr]) {
            self.wallet.walletName = inputText;
            [[WalletManager shareWalletManager] updataWallet:self.wallet];
            NSIndexPath *te = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadWalletNotification" object:nil];
//        }
    }];
}
- (void)changeItemWithCell:(UITableViewCell *)mainCell indexPath:(NSIndexPath *)indexPath arrowImg:(UIImageView *)arrowImg{
    BOOL isTips = self.wallet.walletPasswordTips;

    switch (indexPath.row) {
        case 0:{
            mainCell.textLabel.text = @"备份钱包";
        }
            break;
        case 1:{
            mainCell.textLabel.text = @"免密支付";
        }
            break;
        case 2:{
            if (isTips) {
                mainCell.textLabel.text = @"密码提示";
            }else{
                mainCell.textLabel.text = @"高级模式";
                if (self.isSeniorState) {
                    arrowImg.image = ImageNamed(@"arrowTopGray");
                }else{
                    arrowImg.image = ImageNamed(@"arrowDownGray");
                }
            }
        }
            break;
        case 3:{
            if (isTips) {
                mainCell.textLabel.text = @"高级模式";
                if (self.isSeniorState) {
                    arrowImg.image = ImageNamed(@"arrowTopGray");
                }else{
                    arrowImg.image = ImageNamed(@"arrowDownGray");
                }
            }else{
                mainCell.textLabel.text = @"导出Keystore";
                mainCell.textLabel.font = GCSFontRegular(14);
                mainCell.textLabel.textColor = [UIColor im_textLightGrayColor];
                mainCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH * 2);
            }
           
        }
            break;
        case 4:{
            if (isTips) {
                mainCell.textLabel.text = @"导出Keystore";
                mainCell.textLabel.font = GCSFontRegular(14);
                mainCell.textLabel.textColor = [UIColor im_textLightGrayColor];
                mainCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH * 2);
            }else{
                mainCell.textLabel.text = @"导出私钥";
                mainCell.textLabel.font = GCSFontRegular(14);
                mainCell.textLabel.textColor = [UIColor im_textLightGrayColor];
            }
            
        }
            break;
        case 5:{
            if (isTips) {
                mainCell.textLabel.text = @"导出私钥";
                mainCell.textLabel.font = GCSFontRegular(14);
                mainCell.textLabel.textColor = [UIColor im_textLightGrayColor];
            }
        }
            break;
    }
}
#pragma mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor im_tableBgColor];
    if (@available(iOS 11.0, *)) {
    
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   }
    return _tableView;
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
