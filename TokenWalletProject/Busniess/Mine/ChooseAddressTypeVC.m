//
//  ChooseAddressTypeVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ChooseAddressTypeVC.h"
#import "ChooseAddressCell.h"

@interface ChooseAddressTypeVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ChooseAddressTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"选择地址类型"];
    [self makeData];
    [self makeViews];
    
    // Do any additional setup after loading the view.
}
- (void)makeData{
    NSArray *list = @[
        @{
            @"icon":@"icon_ETH",
            @"type":@"ETH",
            @"detailTitle":@"Ethereum"
        },
//        @{
//            @"icon":@"icon_BSC",
//            @"type":@"BSC",
//            @"detailTitle":@"BSCToken"
//        },
//        @{
//            @"icon":@"icon_HECO",
//            @"type":@"HECO",
//            @"detailTitle":@"Huobi ECO Chain"
//        },
        @{
            @"icon":@"icon_CVN",
            @"type":@"CVN",
            @"detailTitle":@"cvn"
        },
    ];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChooseCoinTypeModel *model = [ChooseCoinTypeModel mj_objectWithKeyValues:obj];
        [self.dataList addObject:model];
        
    }];
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ChooseAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor im_tableBgColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ChooseCoinTypeModel *model = self.dataList[indexPath.row];
    [cell setViewWithData:model];
    if ([self.chooseModel.type isEqualToString:model.type]) {
        cell.checkIconBtn.hidden = NO;
    }else{
        cell.checkIconBtn.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseCoinTypeModel *model = self.dataList[indexPath.row];
    self.chooseModel = model;
    [self.tableView reloadData];
    self.chooseBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor im_tableBgColor];
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.rowHeight = CGFloatScale(65);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 45, 0, 15);
   }
    return _tableView;
}
- (NSMutableArray *)dataList{
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
