//
//  PW_DappFavoritesViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/15.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappFavoritesViewController.h"
#import "PW_DappFavoritesCell.h"

@interface PW_DappFavoritesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, copy) NSMutableArray<PW_DappModel *> *dataArr;

@end

@implementation PW_DappFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_favorites")];
    [self setupNavBgPurple];
    [self makeViews];
    self.noDataView.hidden = self.dataArr.count>0;
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.right.bottom.offset(0);
    }];
}
- (void)deleteWithModel:(PW_DappModel *)model {
    [[PW_DappFavoritesManager shared] deleteWithUrlStr:model.appUrl];
    [self.dataArr removeObject:model];
    self.noDataView.hidden = self.dataArr.count>0;
    [self.tableView reloadData];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_DappFavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DappFavoritesCell"];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.favoriteBlock = ^(PW_DappModel * _Nonnull model) {
        [weakSelf deleteWithModel:model];
    };
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
        [self deleteWithModel:model];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if(!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PW_DappFavoritesCell class] forCellReuseIdentifier:@"PW_DappFavoritesCell"];
        _tableView.rowHeight = 74;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeBottomInset, 0);
    }
    return _tableView;
}
- (NSMutableArray<PW_DappModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:[[PW_DappFavoritesManager shared] getList]];
    }
    return _dataArr;
}

@end
