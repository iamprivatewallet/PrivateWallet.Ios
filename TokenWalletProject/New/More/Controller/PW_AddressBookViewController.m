//
//  PW_AddressBookViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AddressBookViewController.h"
#import "PW_AddressBookCell.h"
#import "PW_AddContactViewController.h"

@interface PW_AddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_AddressBookModel *> *dataArr;
@property (nonatomic, strong) UIView *addView;

@property (nonatomic, assign) BOOL isEdit;

@end

@implementation PW_AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_addressBook") rightTitle:LocalizedStr(@"text_edit") rightAction:@selector(editAction)];
    [self makeViews];
}
- (void)editAction {
    self.isEdit = !self.isEdit;
    if(self.isEdit){
        [self.rightBtn setTitle:LocalizedStr(@"text_finish") forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:LocalizedStr(@"text_edit") forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor g_textColor] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}
- (void)addAction {
    PW_AddContactViewController *vc = [[PW_AddContactViewController alloc] init];
    vc.saveBlock = ^(PW_AddressBookModel * _Nonnull model) {
        [self.dataArr insertObject:model atIndex:0];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_AddressBookCell"];
    cell.model = self.dataArr[indexPath.row];
    cell.isEdit = self.isEdit;
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(PW_AddressBookModel * _Nonnull model) {
        [[PW_AddressBookManager shared] deleteModel:model];
        [weakSelf.dataArr removeObject:model];
        [weakSelf.tableView reloadData];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.chooseBlock) {
        self.chooseBlock(self.dataArr[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 180;
        [_tableView registerClass:[PW_AddressBookCell class] forCellReuseIdentifier:@"PW_AddressBookCell"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _tableView.tableFooterView = self.addView;
    }
    return _tableView;
}
- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] init];
        _addView.frame = CGRectMake(0, 0, 0, 54);
        UIButton *addBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addContact") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addAction)];
        addBtn.frame = CGRectMake(20, 10, SCREEN_WIDTH-40, 44);
        [addBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
        [_addView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(20);
            make.right.offset(-20);
            make.height.offset(44);
        }];
    }
    return _addView;
}
- (NSMutableArray<PW_AddressBookModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:[[PW_AddressBookManager shared] getList]];
    }
    return _dataArr;
}

@end
