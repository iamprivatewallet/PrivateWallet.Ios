//
//  UseSettingViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "UseSettingViewController.h"

@interface UseSettingViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *languageStr;
@property (nonatomic, strong) Wallet *wallet;
@end

@implementation UseSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"设置"];
    self.wallet = [[WalletManager shareWalletManager] getWalletWithAddress:User_manager.currentUser.chooseWallet_address type:User_manager.currentUser.chooseWallet_type];
    [self makeViews];
    self.languageStr = @"简体中文";
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}
- (void)rightBtnAction:(UIButton *)sender{
    if (sender.tag == 10) {
        //Face ID
//        self.wallet.isOpenID = @"1";
//        [[WalletManager shareWalletManager] updataWalletOpenId:self.wallet.isOpenID WalletType:self.wallet.type];
        [self changeOpenID:sender];
    }else{
        sender.selected = !sender.selected;
        //隐藏余额
        SetUserDefaultsForKey(sender.selected?@"1":@"0", @"isHiddenWalletAmount");
        [UserDefaults synchronize];
    }
}
- (void)changeOpenID:(UIButton *)sender {
    if (!sender.selected) {
        [TokenAlertView showInputPasswordWithTitle:@"输入钱包密码" ViewWithAction:^(NSInteger index, NSString * _Nonnull inputText) {
            if (![inputText isEqualToString:self.wallet.walletPassword]) {
                return [self showAlertViewWithText:@"密码不正确" actionText:@"好"];
            }
            if (index == 1) {//确认
                //开启Face ID | Touch ID
                [SWFingerprintLock unlockWithResultBlock:^(UnlockResult result, NSString * _Nonnull errMsg) {
                    if (result == JUnlockSuccess) {
                        self.wallet.isOpenID = @"1";
                        [[WalletManager shareWalletManager] updataWalletOpenId:@"1" WalletType:self.wallet.type];
                        sender.selected = YES;
                        [self showSuccessMessage:@"设置成功"];
                    }else{
                        [self showFailMessage:errMsg];
                    }
                }];
            }
        }];
    }else{
        [self showAlertViewWithText:@"确认关闭免密支付？" action:^(NSInteger index) {
            if (index == 1) {//确认
                self.wallet.isOpenID = @"0";
                [[WalletManager shareWalletManager] updataWalletOpenId:@"0" WalletType:self.wallet.type];
                sender.selected = NO;
            }
        }];
    }
}
// MARK: TableViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 2){
        return 3;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = GCSFontRegular(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    NSString *titleStr;

    if (indexPath.section == 0) {
        titleStr = @"Face ID";
    }else if (indexPath.section == 1) {
        titleStr = @"隐藏余额";
    }else if(indexPath.section == 2){
        UIImageView *arrowImg = [[UIImageView alloc] init];
        arrowImg.image = ImageNamed(@"arrowRightGray");
        [cell.contentView addSubview:arrowImg];
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
            make.size.mas_equalTo(CGSizeMake(CGFloatScale(15), CGFloatScale(15)));
            make.centerY.equalTo(cell.contentView);
        }];
        switch (indexPath.row) {
            case 0:{
                titleStr = @"多语言";
                UILabel *languageLbl = [ZZCustomView labelInitWithView:cell.contentView text:self.languageStr textColor:[UIColor im_textColor_nine] font:GCSFontRegular(17)];
                [languageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(arrowImg.mas_left).offset(-CGFloatScale(8));
                    make.centerY.equalTo(cell.contentView);
                }];
            }
                break;
            case 1:{
                titleStr = @"节点设置";
            }
                break;
            case 2:{
                titleStr = @"DApp设置";
            }
                break;
        }
    }
    
    cell.textLabel.text = titleStr;
    cell.textLabel.textColor = [UIColor im_textColor_three];
    if (indexPath.section != 2) {
        UIButton *rightBtn = [ZZCustomView buttonInitWithView:cell.contentView imageName:@"switchClose"];
        [rightBtn setImage:ImageNamed(@"switchClose") forState:UIControlStateNormal];
        [rightBtn setImage:ImageNamed(@"switchOpen") forState:UIControlStateSelected];
        rightBtn.tag = indexPath.section+10;
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(indexPath.section==0){//FaceID
            rightBtn.selected = self.wallet.isOpenID.boolValue;
        }else{
            rightBtn.selected = [GetUserDefaultsForKey(@"isHiddenWalletAmount") boolValue];
        }
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
            make.size.mas_equalTo(CGSizeMake(CGFloatScale(50), CGFloatScale(40)));
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return CGFloatScale(40);
    }
    return CGFloatScale(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc] init];
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGFloatScale(20), 0, ScreenWidth, 30)];
        textLbl.text = @"开启隐私模式后钱包的资产和金额将会隐藏";
        textLbl.textColor = [UIColor im_grayColor];
        textLbl.font = GCSFontRegular(13);
        [bgView addSubview:textLbl];
        return bgView;
    }
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1) {
        
    }else if(indexPath.section == 2){
        
    }
}
#pragma mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor im_tableBgColor];
        _tableView.rowHeight = CGFloatScale(56);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
