//
//  MinersfeeSettingVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MinersfeeSettingVC.h"
#import "MinerFeeCell.h"
#import "GasPriceTableViewCell.h"
#import "FeeCustomCell.h"

@interface MinersfeeSettingVC ()
<
FeeCustomCellDelegate
>
@property (nonatomic, strong) UIButton *ensureBtn;
@property (nonatomic, copy) NSString *priceStr;
@property (nonatomic, copy) NSString *gasStr;
@property (nonatomic, copy) NSString *gasGwei;
@property(nonatomic, assign) NSInteger chooseIndex;

@property (nonatomic, strong) NSMutableArray *gasPriceList;
@property (nonatomic, strong) GasPriceModel *gasModel;

@property (nonatomic, strong) FeeCustomCell *customCell;



@end

@implementation MinersfeeSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"矿工费设置"];
    [self makeViews];
    [self requestEstimateGas];
    // Do any additional setup after loading the view.
}

- (void)backPrecious{
    if (self.isDAppsPush) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)requestEstimateGas {
    [[PWWalletContractTool shared] estimateGasToAddress:nil completionHandler:^(NSString * _Nullable gasPrice, NSString * _Nullable gas, NSString * _Nullable errorDesc) {
        if(gas){
            NSString *gas_gwei = [gasPrice stringDownDividingBy10Power:9];
            self.gasGwei = gas_gwei;
            self.gasStr = gas;
            [self makeGasPriceGwei:gas_gwei];
        }
    }];
//    NSDictionary *parmDic = @{
//                    @"id":@"67",
//                    @"jsonrpc":@"2.0",
//                    @"method":@"eth_estimateGas",
//                    @"params":@[self.params]
//                    };
//    [AFNetworkClient requestPostWithUrl:User_manager.currentUser.current_Node withParameter:parmDic withBlock:^(id data, NSError *error) {
//        if (data) {
//            self.gasStr = @([data[@"result"] stringTo10]).stringValue;
//            [self makeGasPriceData];
//        }
//    }];
}
- (void)makeGasPriceGwei:(NSString *)gas_gwei {
    NSString *chainId = User_manager.currentUser.current_chainId;
    if([chainId isEqualToString:kETHChainId]||[chainId stringTo10]==kETHChainId.integerValue){
        NSString *fastest = [gas_gwei stringDownAdding:@"30" decimal:3];
        NSString *fast = [gas_gwei stringDownAdding:@"15" decimal:3];
        NSString *general = [gas_gwei stringDownDecimal:3];
        NSString *slow = [gas_gwei stringDownSubtracting:@"15" decimal:3];
        NSArray *titleList = @[@"最快",@"快速",@"一般",@"缓慢"];
        NSArray *gweiList = @[fastest,fast,general,slow];
        NSArray *timeList = @[@"< 0.5分钟",@"< 2分钟",@"< 5分钟",@"< 30分钟"];
        for (int i =0; i< titleList.count; i++) {
            GasPriceModel *model = [[GasPriceModel alloc] init];
            model.gas_speed = titleList[i];
            model.gas_gwei = gweiList[i];
            model.gas_time = timeList[i];
            model.gas = self.gasStr;
            double all_gasAmount = [[[model.gas_gwei stringDownMultiplyingBy:model.gas] stringDownDividingBy10Power:9] doubleValue];
            model.all_gasAmount = all_gasAmount;
            [self.gasPriceList addObject:model];
            if (i == 1) {
                self.gasModel = model;
                self.chooseIndex = 1;
            }
        }
    }else{
        GasPriceModel *model = [[GasPriceModel alloc] init];
        model.gas_speed = @"推荐";
        model.gas_gwei = gas_gwei;
        model.gas_time = @"< 2分钟";
        model.gas = self.gasStr;
        double all_gasAmount = [[[model.gas_gwei stringDownMultiplyingBy:model.gas] stringDownDividingBy10Power:9] doubleValue];
        model.all_gasAmount = all_gasAmount;
        [self.gasPriceList addObject:model];
        self.gasModel = model;
        self.chooseIndex = 0;
    }
    self.priceStr = nil;
    [self.tableView reloadData];
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    [self.view addSubview:self.ensureBtn];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(45);
    }];
    self.tableView.contentSize = CGSizeMake(0, SCREEN_HEIGHT-kNavBarAndStatusBarHeight+10);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.ensureBtn.mas_top);
    }];
}

- (void)ensureBtnAction{//确认
    if (self.chooseIndex==-1&&[self.currentGasModel.gas_price doubleValue]<=0) {
        return;
    }
    if (self.chooseIndex==-1) {
        self.gasModel.gas_gwei = self.currentGasModel.gas_price;
        self.gasModel.gas = self.currentGasModel.gas;
    }
    CGFloat gweiETH = [self.gasModel.gas_gwei doubleValue]*[self.gasModel.gas doubleValue];
    self.gasModel.all_gasAmount = gweiETH/1000000000;
    if (self.chooseGasPriceBlock) {
        self.chooseGasPriceBlock(self.gasModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.gasPriceList.count;
    }else if(section == 2){
        if (self.chooseIndex==-1) {
            return 2;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGFloatScale(110);
    }else if(indexPath.section == 2){
        
        if (indexPath.row == 1) {
//            self.tableView.rowHeight =UITableViewAutomaticDimension;
//            self.tableView.estimatedRowHeight =270;
            return 270;
        }
       
    }
    return CGFloatScale(60);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor navAndTabBackColor];
    if (section == 1) {
        UILabel *textLbl = [ZZCustomView labelInitWithView:view text:@"Gas Price" textColor:[UIColor blackColor] font:GCSFontRegular(13)];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(12);
            make.bottom.equalTo(view).offset(-5);
        }];
        UILabel *detailLbl = [ZZCustomView labelInitWithView:view text:@"预计交易时间" textColor:[UIColor im_textColor_nine] font:GCSFontRegular(13)];
        [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-12);
            make.bottom.equalTo(view).offset(-5);
        }];
    }
    return view;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = NSStringWithFormat(@"cell%ld",(long)indexPath.section);
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        MinerFeeCell *topCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!topCell) {
            topCell = [[MinerFeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (self.priceStr) {
            [topCell fillData:self.currentGasModel];
        }else{
            [topCell fillData:self.gasModel];
        }
        cell = topCell;
    }else if(indexPath.section == 1){
        GasPriceTableViewCell *gasCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!gasCell) {
            gasCell = [[GasPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (self.chooseIndex == indexPath.row) {
            gasCell.checkImg.hidden = NO;
        }else{
            gasCell.checkImg.hidden = YES;
        }
        
        [gasCell setViewWithData:self.gasPriceList[indexPath.row]];
        cell = gasCell;
    }else {
        if (indexPath.row == 0) {
            UITableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
            if (!itemCell) {
                itemCell = [self getItemCell];
            }
            UIImageView *checkView = [itemCell.contentView viewWithTag:10];

            if (self.chooseIndex==-1) {
                checkView.hidden = NO;
                itemCell.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
            }else{
                checkView.hidden = YES;
                itemCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth);
            }
            cell = itemCell;
        }else{
            self.customCell= [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!self.customCell) {
                self.customCell = [[FeeCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                self.customCell.delegate = self;
            }
            [self.customCell fillDataWithPriceHighest:self.gasGwei gasHighest:self.gasStr];
            self.customCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth);

            cell = self.customCell;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        self.gasModel = self.gasPriceList[indexPath.row];
        self.chooseIndex = indexPath.row;
        self.priceStr = nil;
        self.customCell.priceTF.text = @"";
        [self.tableView reloadData];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //自定义
        //清空customCell里的数据
        self.priceStr = @"";
        self.currentGasModel.gas_price = @"";
        self.currentGasModel.gas = self.gasStr;
        self.chooseIndex = -1;
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)getItemCell{
    UITableViewCell *itemCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
    UIImageView *checkImg = [ZZCustomView imageViewInitView:itemCell.contentView imageName:@"checkBlue"];
    checkImg.tag = 10;
    checkImg.hidden = YES;
    [checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemCell.contentView).offset(15);
        make.top.equalTo(itemCell.contentView).offset(20);
        make.bottom.equalTo(itemCell.contentView).offset(-20);
        make.width.height.mas_equalTo(17);
    }];
    
    UILabel *titleLbl = [ZZCustomView labelInitWithView:itemCell.contentView text:@"自定义" textColor:[UIColor blackColor] font:GCSFontRegular(15)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkImg.mas_right).offset(12);
        make.centerY.equalTo(checkImg);
    }];
    return itemCell;
}

- (void)getCustomInfo:(UITextField *)textField{
    if (textField.tag == 10) {
        self.priceStr = textField.text;
    }else{
        self.gasStr = textField.text;
    }
   
    self.currentGasModel.gas_price = self.priceStr;
    self.currentGasModel.gas = self.gasStr;
    if (@available(iOS 11.0, *)) {
        [self.tableView performBatchUpdates:^{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        } completion:nil];
    } else {
        // Fallback on earlier versions
        
    }

}



- (NSMutableArray *)gasPriceList{
    if (!_gasPriceList) {
        _gasPriceList = [[NSMutableArray alloc] init];
    }
    return _gasPriceList;
}
- (UIButton *)ensureBtn{
    if (!_ensureBtn) {
        _ensureBtn = [ZZCustomView im_ButtonDefaultWithView:self.view title:@"确认" titleFont:GCSFontRegular(15) enable:YES];
        [_ensureBtn addTarget:self action:@selector(ensureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}
- (CurrentGasPriceModel *)currentGasModel{
    if (!_currentGasModel) {
        _currentGasModel = [[CurrentGasPriceModel alloc] init];
        _currentGasModel.gas = @"21000";
        _currentGasModel.gas_price = @"0";
    }
    return _currentGasModel;
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
