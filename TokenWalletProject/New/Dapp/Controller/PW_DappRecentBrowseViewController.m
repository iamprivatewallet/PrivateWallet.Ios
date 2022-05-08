//
//  PW_DappRecentBrowseViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappRecentBrowseViewController.h"
#import "PW_DappRecentBrowseCell.h"

@interface PW_DappRecentBrowseViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, copy) NSMutableArray<PW_DappModel *> *dataArr;

@end

@implementation PW_DappRecentBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_recentBrowse") rightTitle:LocalizedStr(@"text_cleanAll") rightAction:@selector(clearAllAction)];
    [self makeViews];
    self.noDataView.hidden = self.dataArr.count>0;
}
- (void)clearAllAction {
    [[PW_DappManager shared] deleteAll];
    [self.dataArr removeAllObjects];
    self.noDataView.hidden = NO;
    [self.tableView reloadData];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_DappRecentBrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappRecentBrowseCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PW_DappModel *model = self.dataArr[indexPath.row];
        [[PW_DappManager shared] deleteWithUrlStr:model.appUrl];
        [self.dataArr removeObject:model];
        [tableView reloadData];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_DappRecentBrowseCell class] forCellReuseIdentifier:@"PW_DappRecentBrowseCell"];
        _tableView.rowHeight = 74;
        _tableView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    }
    return _tableView;
}
- (NSMutableArray<PW_DappModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:[[PW_DappManager shared] getList]];
    }
    return _dataArr;
}

@end
