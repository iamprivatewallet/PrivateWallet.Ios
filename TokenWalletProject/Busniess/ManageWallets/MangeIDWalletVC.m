//
//  MangeIDWalletVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MangeIDWalletVC.h"
#import "WarningAlertSheetView.h"
#import "BackupTipsViewController.h"
#import "AddCurrencyViewController.h"
#import "IDInfoViewController.h"
#import "PasswordTipsVC.h"

@interface MangeIDWalletVC ()
<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WarningAlertSheetView *sheetView;

@end

@implementation MangeIDWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"管理身份钱包" rightImg:@"helpBlack" rightAction:@selector(navRightAction)];
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)navRightAction{
    
}

// MARK: TableViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2){
        NSString *tip = User_manager.currentUser.user_pass_tip;
        if (![tip isNoEmpty]) {
            return 1;
        }
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = GCSFontRegular(16);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section != 0) {
            [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(CGFloatScale(20));
                make.centerY.equalTo(cell.contentView);
            }];
        }
    }
    UIView *contentView = cell.contentView;
    [[contentView viewWithTag:10] removeFromSuperview];
    [[contentView viewWithTag:11] removeFromSuperview];
    [[contentView viewWithTag:12] removeFromSuperview];
    [[contentView viewWithTag:13] removeFromSuperview];
    
    if (indexPath.section != 3) {
        UIImageView *arrowImg = [[UIImageView alloc] init];
        [cell.contentView addSubview:arrowImg];
        arrowImg.tag = 12;
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
            make.size.mas_equalTo(CGSizeMake(CGFloatScale(15), CGFloatScale(15)));
            make.centerY.equalTo(cell.contentView);
        }];
    
        NSString *iconName;
        NSString *titleStr;

        if (indexPath.section == 0) {
            titleStr = User_manager.currentUser.user_name;
            UIImageView *iconImg = [[UIImageView alloc] init];
            iconImg.tag = 13;
            [cell.contentView addSubview:iconImg];
            [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(CGFloatScale(20));
                make.size.mas_equalTo(CGSizeMake(CGFloatScale(45), CGFloatScale(45)));
                make.centerY.equalTo(cell.contentView);
            }];
            iconImg.image = ImageNamed(@"defaultAvatar");
            [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImg.mas_right).offset(CGFloatScale(20));
                make.centerY.equalTo(cell.contentView);
            }];
        }else if (indexPath.section == 1) {
            titleStr = @"备份钱包";
            if (![User_manager isBackup]) {
                UIButton *backBtn = [ZZCustomView buttonInitWithView:cell.contentView title:@" 未备份" titleColor:[UIColor im_textLightGrayColor] titleFont:GCSFontRegular(14)];
                backBtn.tag = 10;
                [backBtn setImage:ImageNamed(@"backupWarnning") forState:UIControlStateNormal];
                [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(arrowImg.mas_left).offset(-15);
                    make.centerY.equalTo(cell.contentView);
                }];
            }
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                titleStr = @"添加币种";
                [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(CGFloatScale(20));
                    make.top.equalTo(cell.contentView).offset(CGFloatScale(15));
                }];
                UILabel *detailLbl = [ZZCustomView labelInitWithView:cell.contentView text:@"支持ETH、BSC、HECO" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(12)];
                detailLbl.tag = 11;
                [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(CGFloatScale(20));
                    make.top.equalTo(cell.textLabel.mas_bottom);
                }];
            }else{
                titleStr = @"密码提示";
            }
        }
        if (indexPath.section == 0 || (indexPath.section == 2 && indexPath.row == 0)) {
            iconName = @"arrow";
        }else{
            iconName = @"arrowRightGray";
        }
        arrowImg.image = ImageNamed(iconName);
        cell.textLabel.text = titleStr;
        cell.textLabel.textColor = [UIColor im_textColor_three];

    }else{
        cell.textLabel.text = @"退出";
        cell.textLabel.textColor = COLOR(229, 71, 59);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
        }];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGFloatScale(76);
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            return CGFloatScale(66);
        }
    }
    return CGFloatScale(56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return CGFloatScale(56);
    }
    return CGFloatScale(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc] init];
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGFloatScale(20), 8, ScreenWidth, 30)];
        textLbl.text = @"备份钱包以便将来恢复身份钱包下的多币种资产";
        textLbl.textColor = [UIColor im_grayColor];
        textLbl.font = GCSFontRegular(14);
        [bgView addSubview:textLbl];
        return bgView;
    }
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            IDInfoViewController *vc = [[IDInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //备份钱包
            [self jumpToBackup];
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                AddCurrencyViewController *vc = [[AddCurrencyViewController alloc] init];
                vc.isAddCurrency = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                PasswordTipsVC *vc = [[PasswordTipsVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:{
            //退出
            if (![User_manager isBackup]) {
                [WarningAlertSheetView showNotBackupAlertViewWithAction:^(NSInteger index) {
                    [self jumpToBackup];
                }];
            }else{
                [self loginOut];
            }
        }
            break;
        default:
            break;
    }

}

- (void)jumpToBackup{
    [TokenAlertView showInputPasswordWithTitle:@"请输入密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
        if (![User_manager.currentUser.user_pass isEqualToString:inputText]) {
            [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"好"];
        }else{
            BackupTipsViewController *vc = [[BackupTipsViewController alloc] initWithType:kBackupTypeMnemonic];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}


#pragma mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor im_tableBgColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
    
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   }
    return _tableView;
}

- (void)loginOut{
    [WarningAlertSheetView showAlertViewWithIcon:@"mine_quit" title:@"退出身份" content:@"退出身份后将删除所有钱包数据，请务必确保所有钱包已备份" btnText:@"确认退出" btnBgColor:COLOR(250, 90, 65) action:^{
        //确认退出
        [TokenAlertView showWithTitle:@"请输入密码" message:@"警告：若无妥善备份，删除钱包后将无法找回钱包，请慎重处理该操作" textField_p:@"密码" buttonTitles:@[@"取消",@"确认"] action:^(NSInteger index, NSString *inputText) {
            if (![inputText isEqualToString:User_manager.currentUser.user_pass]) {
                return [self showAlertViewWithText:@"密码不正确" actionText:@"好"];
            }
            [User_manager logout];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TheAppDelegate switchToCreateWalletVC];
            });
        }];
    }];
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
