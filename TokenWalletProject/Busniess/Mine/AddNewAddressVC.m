//
//  AddNewAddressVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AddNewAddressVC.h"
#import "ChooseAddressTypeVC.h"

@interface AddNewAddressVC ()
<WBQRCodeDelegate>
@property (nonatomic, strong) UITextField *name_TF;
@property (nonatomic, strong) UITextField *address_TF;
@property (nonatomic, strong) UITextField *describe_TF;
@property (nonatomic, strong) UIButton *rightNavBtn;
@end

@implementation AddNewAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isEditAddr) {
        [self setNavTitle:@"编辑地址" leftTitle:@"取消" leftAction:@selector(backPrecious) rightTitle:@"保存" rightAction:@selector(rightNavItemAction) isNoLine:YES];
    }else{
        self.chooseModel.icon = @"icon_ETH";
        self.chooseModel.type = @"ETH";

        [self setNav_NoLine_WithLeftItem:@"新建地址"];
        self.rightNavBtn = [ZZCustomView buttonInitWithView:self.naviBar title:@"保存" titleColor:COLORA(0, 0, 0, 0.2) titleFont:GCSFontRegular(14)];
        self.rightNavBtn.userInteractionEnabled = NO;
        [self.rightNavBtn addTarget:self action:@selector(rightNavItemAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.naviBar addSubview:self.rightNavBtn];
        [self.rightNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.naviBar).offset(-12);
            make.bottom.equalTo(self.naviBar).offset(-10);
        }];
        
    }
    
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
   
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor navAndTabBackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
}

- (void)rightNavItemAction{
    if(![self.address_TF.text hasPrefix:@"0x"] && ![self.address_TF.text hasPrefix:@"CVN"]){
        return [self showAlertViewWithText:@"请输入格式正确的地址" actionText:@"知道了"];
    }
    if ([self.address_TF.text hasPrefix:@"0x"] && self.address_TF.text.length != 42) {
        return [self showAlertViewWithText:@"请输入格式正确的地址" actionText:@"知道了"];
    }
    if ([self.address_TF.text hasPrefix:@"CVN"] && self.address_TF.text.length != 43) {
        return [self showAlertViewWithText:@"请输入格式正确的地址" actionText:@"知道了"];
    }
    if (!self.isEditAddr) {
        if ([[SettingManager sharedInstance] isExistAddress:self.address_TF.text]) {
            return [self showAlertViewWithText:@"地址已存在" actionText:@"知道了"];
        }
    }
    //保存
    NSDictionary *dic = @{
        @"address":self.address_TF.text,
        @"name":self.name_TF.text,
        @"type":self.chooseModel.type,
        @"icon":self.chooseModel.icon,
        @"describe":self.describe_TF.text
    };
    if (self.isEditAddr) {
        
        [[SettingManager sharedInstance] editOldAddress:self.chooseModel.address forNewAddress:dic];
    }else{
        [[SettingManager sharedInstance] addAddress:dic];
    }
    if (self.editAddressBlock) {
        self.editAddressBlock();
    }
    if (self.isScanCodeAddr) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)deleteButtonAction{
    //删除
    [self showAlertViewWithText:@"确定删除地址?" action:^(NSInteger index) {
        if (index == 1) {
            [[SettingManager sharedInstance] deleteAddress:self.chooseModel.address];
            [UITools showToastHelperWithText:@"删除成功"];
            if (self.editAddressBlock) {
                self.editAddressBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}
- (void)scanBtnAction{
    if (![CATCommon isHaveAuthorForCamer]) {
        return;
    }
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    WBVC.delegate = self;
    WBVC.zh_showCustomNav = YES;
    [UITools QRCodeFromVC:self scanVC:WBVC];
}
#pragma mark delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isEditAddr) {
        return 3;
    }
    return 2;
}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 1;
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGFloatScale(58);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGFloatScale(45);
    }else if (section == 2) {
        return CGFloatScale(20);
    }
    return CGFloatScale(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor navAndTabBackColor];
    if (section == 1) {
        UILabel *titleLbl = [ZZCustomView labelInitWithView:view text:@"地址信息" textColor:[UIColor im_textColor_three] font:GCSFontRegular(13)];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(5);
            make.bottom.equalTo(view).offset(-8);
        }];
        
    }
    return view;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        UITableViewCell *topCell = [self makeTopCell];
        cell = topCell;
    }else if (indexPath.section == 1){
        UITableViewCell *infoCell = [self makeInfoCellWithIndexPath:indexPath];
        cell = infoCell;
    }else{
        cell = [[UITableViewCell alloc] init];
        UIButton *deleteBtn = [ZZCustomView buttonInitWithView:cell.contentView title:@"删除" titleColor:[UIColor im_redColor] titleFont:GCSFontRegular(16)];
        [deleteBtn addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
    }
    return cell;
}

- (UITableViewCell *)makeTopCell{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UIImageView *iconImg = [ZZCustomView imageViewInitView:cell.contentView imageName:self.chooseModel.icon];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.equalTo(cell.contentView);
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:cell.contentView text:self.chooseModel.type textColor:[UIColor im_textColor_three] font:GCSFontRegular(15)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImg.mas_right).offset(15);
        make.centerY.equalTo(cell.contentView);
    }];
    
    UIImageView *arrowImg = [ZZCustomView imageViewInitView:cell.contentView imageName:@"arrowRightGray"];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.centerY.equalTo(cell.contentView);
    }];
    
    return cell;
}
- (UITableViewCell *)makeInfoCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentCell"];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.tag = indexPath.row;
    tf.font = GCSFontRegular(14);
    if (indexPath.row == 0) {
        tf.placeholder = @"请输入地址";
        self.address_TF = tf;
    }else if (indexPath.row == 1) {
        tf.placeholder = @"名称";
        self.name_TF = tf;
    }else{
        tf.placeholder = @"描述（选填）";
        self.describe_TF = tf;
    }
    if (self.isEditAddr || self.isScanCodeAddr) {
        self.address_TF.text = self.chooseModel.address;
        self.name_TF.text = self.chooseModel.name;
        self.describe_TF.text = self.chooseModel.describe;
    }
    
    [tf addTarget:self action:@selector(infoTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [cell.contentView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.top.bottom.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).offset(-60);
    }];
    if (indexPath.row != 2) {
        UIView *line = [ZZCustomView viewInitWithView:cell.contentView bgColor:[UIColor im_borderLineColor]];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.height.equalTo(@1);
        }];
    }
   
    if (indexPath.row == 0) {
        UIButton *scanBtn = [ZZCustomView buttonInitWithView:cell.contentView imageName:@"scan"];
        [scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ChooseAddressTypeVC *vc = [[ChooseAddressTypeVC alloc] init];
        vc.chooseModel = self.chooseModel;
        vc.chooseBlock = ^(id model) {
            ChooseCoinTypeModel *coinModel = model;
            self.chooseModel = coinModel;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)infoTextFieldAction:(UITextField *)sender{

    if (!self.isEditAddr) {
        if (self.address_TF.text.length > 0 && self.name_TF.text.length > 0) {
            self.rightNavBtn.userInteractionEnabled = YES;
            [self.rightNavBtn setTitleColor:[UIColor im_blueColor] forState:UIControlStateNormal];
        }else{
            self.rightNavBtn.userInteractionEnabled = NO;
            [self.rightNavBtn setTitleColor:COLORA(0, 0, 0, 0.2) forState:UIControlStateNormal];
        }
    }
    
}


//MARK: WBQRCodeDelegate
- (void)scanNoPopWithResult:(NSString*)result{
    self.address_TF.text = result;
}

- (ChooseCoinTypeModel *)chooseModel{
    if (!_chooseModel) {
        _chooseModel = [[ChooseCoinTypeModel alloc] init];
    }
    return _chooseModel;
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
