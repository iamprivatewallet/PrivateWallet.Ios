//
//  ManageViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ManageViewController.h"
#import "ManageTopTableViewCell.h"
#import "MangeIDWalletVC.h"
#import "BackupTipsViewController.h"
#import "SecretFreeViewController.h"
#import "ETHWalletManageVC.h"

@interface ManageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ManageTopTableViewCell *topCell;

@property(nonatomic, assign) BOOL isSeniorState;
@end

@implementation ManageViewController

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
    if(section == 1){
        return 2;
    }else if(section == 2){
        if (self.isSeniorState) {
            //高级模式
            return 4;
        }else{
            return 2;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mainCell";

    UITableViewCell *manageCell = nil;
    if (indexPath.section == 0) {
        ManageTopTableViewCell *topCell = [[ManageTopTableViewCell alloc] init];
        manageCell = topCell;
    }else{
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
       
        if (indexPath.section == 1) {
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
        }else if (indexPath.section == 2) {
            switch (indexPath.row) {
                case 0:{
                    mainCell.textLabel.text = @"免密支付";

                }
                    break;
                case 1:{
                    mainCell.textLabel.text = @"高级模式";
                    if (self.isSeniorState) {
                        arrowImg.image = ImageNamed(@"arrowTopGray");
                    }else{
                        arrowImg.image = ImageNamed(@"arrowDownGray");
                    }
                }
                    break;
                case 2:{
                    mainCell.textLabel.text = @"导出Keystore";
                    mainCell.textLabel.font = GCSFontRegular(14);
                    mainCell.textLabel.textColor = [UIColor im_textLightGrayColor];
                    mainCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH * 2);
                }
                    break;
                case 3:{
                    mainCell.textLabel.text = @"导出私钥";
                    mainCell.textLabel.font = GCSFontRegular(14);
                    mainCell.textLabel.textColor = [UIColor im_textLightGrayColor];
                }
                    break;
                
            }
        }else{
            mainCell.textLabel.text = @"以太坊2.0钱包管理";

        }
        manageCell = mainCell;
    }
    manageCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return manageCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGFloatScale(76);
    }
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
            MangeIDWalletVC *vc = [[MangeIDWalletVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            if (indexPath.row == 1) {
                [TokenAlertView showViewWithTitle:@"钱包名称" textField_p:self.wallet.walletName action:^(NSInteger index, NSString * _Nonnull inputText) {
                    if (![inputText isEmptyStr]) {
                        self.wallet.walletName = inputText;
                        [[WalletManager shareWalletManager] updataWallet:self.wallet];
                        [self.tableView reloadData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadWalletNotification" object:nil];
                    }
                    
                }];
            }
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                //免密支付
                SecretFreeViewController *vc = [[SecretFreeViewController alloc] init];
                vc.wallet = self.wallet;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (indexPath.row == 1) {
                self.isSeniorState = !self.isSeniorState;
                [tableView reloadData];
                
            }else{
                [TokenAlertView showInputPasswordWithTitle:@"请输入密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
                    if (![self.wallet.walletPassword isEqualToString:inputText]) {
                        [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"好"];
                    }else{
                        BackupTipsViewController *vc = [[BackupTipsViewController alloc] initWithType:indexPath.row==2?kBackupTypeKeystore:kBackupTypePrivateKey];
                        vc.wallet = self.wallet;
                        [self.navigationController pushViewController:vc animated:YES];
                    }

                }];
            }
        }
            break;
        case 3:{
            ETHWalletManageVC *vc = [[ETHWalletManageVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
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
