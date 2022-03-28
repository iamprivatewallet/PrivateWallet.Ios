//
//  AddressBookViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookCell.h"
#import "AddNewAddressVC.h"

@interface AddressBookViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NoDataShowView *noDataView;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self setNav_NoLine_WithLeftItem:@"地址薄" rightImg:@"addDapp" rightAction:@selector(navRightItemAction)];
    [self makeViews];
    [self reloadDataList];
    // Do any additional setup after loading the view.
}

- (void)reloadDataList{
    if (self.dataList.count > 0) {
        [self.dataList removeAllObjects];
    }
    NSArray *array = [[SettingManager sharedInstance] getAddressArray];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChooseCoinTypeModel *model = [ChooseCoinTypeModel mj_objectWithKeyValues:obj];
        [self.dataList addObject:model];
    }];
    [self.tableView reloadData];
    
    if (array.count <= 0) {
        self.noDataView = [NoDataShowView showView:self.view image:@"noResult" text:@"暂无数据"];
    }else{
       [self.noDataView dismissView];
    }
}

- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
    
}


- (void)navRightItemAction{
    AddNewAddressVC *vc = [[AddNewAddressVC alloc] init];
    vc.isEditAddr = NO;
    vc.editAddressBlock = ^() {
        [self reloadDataList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setViewWithData:self.dataList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isChooseAddr) {
        ChooseCoinTypeModel *model = self.dataList[indexPath.row];
        if (self.chooseAddressBlock) {
            self.chooseAddressBlock(model.address);
        }
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [WarningAlertSheetView showClickViewWithItems:@[@"复制地址",@"编辑"] action:^(NSInteger index) {
            if (index == 1) {
                //复制地址
                ChooseCoinTypeModel *model = self.dataList[indexPath.row];
                [UITools pasteboardWithStr:model.address toast:@"复制成功"];
            }else{
                //编辑
                AddNewAddressVC *vc = [[AddNewAddressVC alloc] init];
                vc.isEditAddr = YES;
                vc.chooseModel = self.dataList[indexPath.row];
                vc.editAddressBlock = ^() {
                    [self reloadDataList];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.estimatedRowHeight = 80;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    }
    return _tableView;
}
-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
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
