//
//  CreateWalletViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CreateWalletVC.h"
#import "BackupTipsViewController.h"
@interface CreateWalletVC ()

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UITextField *name_TF;
@property (nonatomic, strong) UITextField *pw_TF;
@property (nonatomic, strong) UITextField *repw_TF;
@property (nonatomic, strong) UITextField *pwTip_TF;
@property (nonatomic, copy) NSString *wordStr;
@end

@implementation CreateWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self setNav_NoLine_WithLeftItem:NSStringWithFormat(@"创建%@钱包",self.walletType)];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [bottomView addSubview:self.createButton];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.right.equalTo(bottomView).offset(-10);
        make.top.equalTo(bottomView).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.createButton.mas_top).offset(-10);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        
    }];
}
- (void)hiddenPwButtonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.repw_TF.secureTextEntry = NO;
        [sender setImage:ImageNamed(@"showAssets") forState:UIControlStateNormal];
    }else{
        self.repw_TF.secureTextEntry = YES;
        [sender setImage:ImageNamed(@"hideAssets") forState:UIControlStateNormal];
    }
}

- (void)createButtonAction{
    //创建钱包
    if (![self.pw_TF.text isEqualToString:self.repw_TF.text]) {
        return [self showAlertViewWithTitle:@"" text:@"密码不一致" actionText:@"好"];
    }
//    if (self.pwStr.length < 8) {
//        return [self showAlertViewWithTitle:@"" text:@"不少于8位字符，建议混合大小写字母、数字、符号" actionText:@"知道了"];
//    }
    //创建助记词
    [FchainTool generateMnemonicBlock:^(NSString * _Nonnull result) {
        Wallet *wallet = [[Wallet alloc] init];
        wallet.walletName = self.name_TF.text;
        wallet.walletPassword = self.repw_TF.text;
        wallet.walletPasswordTips = self.pwTip_TF.text;
        wallet.mnemonic = result;
        wallet.type = self.walletType;
        BackupTipsViewController *vc = [[BackupTipsViewController alloc] initWithType:kBackupTypeMnemonic];
        vc.isFirstBackup = YES;
        vc.wallet = wallet;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}

#pragma mark Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"createCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UITextField *textField = [[UITextField alloc] init];
        [textField addTarget:self action:@selector(textFieldAction) forControlEvents:UIControlEventEditingChanged];
        textField.tag = 100;
        [cell.contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(20);
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-50);
        }];
        if (indexPath.section == 1 && indexPath.row == 1) {
            UIButton *hiddenBtn = [ZZCustomView buttonInitWithView:cell.contentView imageName:@"hideAssets"];
            [hiddenBtn addTarget:self action:@selector(hiddenPwButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-20);
                make.centerY.equalTo(cell.contentView);
                make.width.height.mas_equalTo(22);
            }];
        }
    }
    UITextField *textField = [cell.contentView viewWithTag:100];
    textField.font = GCSFontRegular(14);
    
    NSString *placeholderStr;
    if (indexPath.section == 0) {
        placeholderStr = @"1~12位字符";
        self.name_TF = textField;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            placeholderStr = @"钱包密码";
            self.pw_TF = textField;
        }else{
            placeholderStr = @"重复输入密码";
            self.repw_TF = textField;
        }
        textField.secureTextEntry = YES;
    }else{
        placeholderStr = @"选填";
        self.pwTip_TF = textField;
    }
    [textField im_setPlaceholder:placeholderStr];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGFloatScale(55);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFloatScale(40);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]init];
    
    UILabel *titleLabel = [ZZCustomView labelInitWithView:bgView text:@"" textColor:[UIColor im_textColor_three] font:GCSFontRegular(14)];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(8);
        make.bottom.equalTo(bgView).offset(-8);
    }];
    
    switch (section) {
        case 0:
            titleLabel.text = @"钱包名称";

            break;
        case 1:
            titleLabel.text = @"密码";

            break;
        case 2:
            titleLabel.text = @"密码提示";

            break;
    }
    
    return bgView;
}
- (void)textFieldAction{
    if (self.name_TF.text.length>0 && self.pw_TF.text.length>0 && self.repw_TF.text.length>0) {
        self.createButton.userInteractionEnabled = YES;
        self.createButton.backgroundColor = [UIColor im_btnSelectColor];
    }
}

- (UIButton *)createButton{
    if (!_createButton) {
        _createButton = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"创建" titleFont:GCSFontRegular(16) enable:NO];
        [_createButton addTarget:self action:@selector(createButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
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
