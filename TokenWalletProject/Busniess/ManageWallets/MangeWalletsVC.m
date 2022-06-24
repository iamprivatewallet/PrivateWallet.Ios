//
//  MangeWalletsVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "MangeWalletsVC.h"
#import "WalletLeftView.h"
#import "ManageWalletCell.h"
#import "AddCurrencyCell.h"
#import "ManageBottomView.h"
#import "MangeIDWalletVC.h"
#import "ManageViewController.h"
#import "AddWalletViewController.h"
#import "AddCurrencyViewController.h"
#import "ImportManageVC.h"
@interface MangeWalletsVC ()<UITableViewDelegate,UITableViewDataSource,WalletLeftViewDelegate>
@property (nonatomic, strong) WalletLeftView *leftView;
@property (nonatomic, strong) ManageBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, strong) NSMutableArray *orignList;
@property (nonatomic, strong) NSMutableArray *importList;

@end

@implementation MangeWalletsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"管理钱包"];
    [self makeViews];
    
    self.walletType = kManageWalletTypeAll;
    [self changeorignList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataList) name:@"ReloadWalletNotification" object:nil];
    // Do any additional setup after loading the view.
}

- (void)reloadDataList{
    [self changeorignList];
    [self.leftView refreshWalletLeftView];//刷新左边币种icon
}

- (void)changeorignList{
    if (self.orignList.count > 0) {
        [self.orignList removeAllObjects];
    }
    if (self.importList.count > 0) {
        [self.importList removeAllObjects];
    }
    if (self.walletType == kManageWalletTypeAll) {
        
        NSArray *orignList = [[WalletManager shareWalletManager] getOrignWallets];
        [self.orignList addObjectsFromArray:orignList];
        
        NSArray *importList = [[WalletManager shareWalletManager] getImportWallets];
        [self.importList addObjectsFromArray:importList];
        
    }else{
        NSArray *list = [[WalletManager shareWalletManager] selectWalletWithType:[self getWalletType]];
        [self.orignList addObjectsFromArray:list];
    }
    [self.tableView reloadData];
    [self.leftView chooseItem:self.walletType];

}

- (NSString *)getWalletType{
    NSString *type;
    switch (self.walletType) {
        
        case kManageWalletTypeETH:{
            return @"ETH";
        }
            break;
//        case kManageWalletTypeHECO:{
//            return @"HECO";
//        }
//            break;
//        case kManageWalletTypeBSC:{
//            return @"BSC";
//
//        }
            break;
        case kManageWalletTypeCVN:{
            return @"CVN";

        }
            break;
        default:
            break;
    }
    
    return type;
}

- (void)manageBtnAction{
    //管理身份钱包
    MangeIDWalletVC *vc = [[MangeIDWalletVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(60);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
    }];
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(self.bottomView.mas_top);

    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.leftView.mas_right);
        make.top.equalTo(self.leftView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.walletType == kManageWalletTypeAll) {
        if (section == 1) {
            return self.importList.count;
        }
        return self.orignList.count+1;
    }
    
    return self.orignList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.walletType == kManageWalletTypeAll && self.importList.count>0) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ManageWalletCell";
    
    ManageWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ManageWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier isChooseWallet:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Wallet *wallet;
    if (indexPath.section == 1) {
        wallet = self.importList[indexPath.row];
       
    }else{
        //默认的身份钱包
        if (indexPath.row == self.orignList.count && self.walletType == kManageWalletTypeAll) {
            AddCurrencyCell *cell = [[AddCurrencyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        wallet = self.orignList[indexPath.row];
    }
    [cell setViewWithData:wallet];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFloatScale(48);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]init];
    NSString *title = nil;
    if (self.walletType == kManageWalletTypeAll) {
        if (section == 1) {
            title = @"创建/导入";
        }else{
            title = @"身份钱包";
            [self makeManageButtonFromView:bgView];
        }
    }else {
        
        title = [self getWalletType];
    }
    UILabel *titleLabel = [ZZCustomView labelInitWithView:bgView text:title textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(14)];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.bottom.equalTo(bgView).offset(-10);
    }];
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && self.walletType == kManageWalletTypeAll) {
        
        ImportManageVC *vc = [[ImportManageVC alloc] init];
        vc.wallet = self.importList[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        if (indexPath.row == self.orignList.count && self.walletType == kManageWalletTypeAll) {
            //添加币种页
            AddCurrencyViewController *vc = [[AddCurrencyViewController alloc] init];
            vc.isAddCurrency = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            ManageViewController *vc = [[ManageViewController alloc] init];
            vc.wallet = self.orignList[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

//MARK: WalletLeftViewDelegate
- (void)clickTagButtonIndex:(NSInteger)index{
    self.walletType = index;
    [self changeorignList];
}
- (void)makeManageButtonFromView:(UIView *)view{
        self.manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:self.manageBtn];
        [self.manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view);
            make.centerY.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
        [self.manageBtn addTarget:self action:@selector(manageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *icon = [ZZCustomView imageViewInitView:self.manageBtn imageName:@"changeWaiting"];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.manageBtn).offset(-17);
            make.bottom.equalTo(self.manageBtn).offset(-3);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        UILabel *title = [ZZCustomView labelInitWithView:self.manageBtn text:@"管理" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(14)];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(icon.mas_left).offset(-6);
            make.centerY.equalTo(icon);
        }];

}
#pragma mark getter

- (WalletLeftView *)leftView{
    if (!_leftView) {
        _leftView = [[WalletLeftView alloc] init];
        _leftView.delegate = self;
    }
    return _leftView;
}
- (ManageBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ManageBottomView alloc] init];
        @weakify(self);
        _bottomView.bottomActionBlock = ^(NSInteger index) {
            @strongify(self);
            if (index == 1) {
                //添加钱包
                AddWalletViewController *vc = [[AddWalletViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    return _bottomView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = CGFloatScale(75);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];

        if (@available(iOS 11.0, *)) {
        
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
        
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
   }
    return _tableView;
}
- (NSMutableArray *)orignList{
    if (!_orignList) {
        _orignList = [[NSMutableArray alloc] init];
    }
    return _orignList;
}
- (NSMutableArray *)importList{
    if (!_importList) {
        _importList = [[NSMutableArray alloc] init];
    }
    return _importList;
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
