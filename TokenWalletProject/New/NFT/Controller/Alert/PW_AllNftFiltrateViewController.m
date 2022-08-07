//
//  PW_AllNftFiltrateViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AllNftFiltrateViewController.h"
#import "PW_AllNftFiltrateCell.h"

@interface PW_AllNftFiltrateViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, copy) NSArray<PW_AllNftFiltrateGroupModel *> *dataArr;

@end

@implementation PW_AllNftFiltrateViewController

- (void)setFiltrateArr:(NSArray<PW_AllNftFiltrateGroupModel *> *)filtrateArr {
    _filtrateArr = filtrateArr;
    [self resetAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
}
- (void)resetAction {
    NSMutableArray *array = [NSMutableArray array];
    for (PW_AllNftFiltrateGroupModel *model in self.filtrateArr) {
        [array addObject:[model mutableCopy]];
    }
    self.dataArr = [array copy];
    [self.tableView reloadData];
}
- (void)sureAction {
    if (self.sureBlock) {
        self.sureBlock(self.dataArr);
    }
    [self closeAction];
}
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(465+PW_SafeBottomInset);
    }];
    UIView *headerView = [[UIView alloc] init];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
        make.right.offset(-35);
        make.height.mas_equalTo(25);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_filtrate") fontSize:15 textColor:[UIColor g_textColor]];
    [headerView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.offset(0);
    }];
    [headerView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.bottom.offset(0);
    }];
    [self.contentView addSubview:self.tableView];
    UIButton *resetBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_reset") fontSize:15 titleColor:[UIColor whiteColor] cornerRadius:6 backgroundColor:[UIColor g_darkBgColor] target:self action:@selector(resetAction)];
    [self.contentView addSubview:resetBtn];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_sure") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:6 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    [self.contentView addSubview:sureBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.left.right.offset(0);
        make.bottom.equalTo(resetBtn.mas_top).offset(-10);
    }];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35);
        make.height.mas_equalTo(50);
        make.bottom.offset(-20-PW_SafeBottomInset);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resetBtn.mas_right).offset(20);
        make.bottom.width.height.equalTo(resetBtn);
        make.right.offset(-35);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_AllNftFiltrateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_AllNftFiltrateCell.class)];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.clickBlock = ^(PW_AllNftFiltrateGroupModel * _Nonnull groupModel, PW_AllNftFiltrateItemModel * _Nonnull model) {
        BOOL selected = model.selected;
        for (PW_AllNftFiltrateItemModel *itemModel in groupModel.items) {
            itemModel.selected = NO;
        }
        model.selected = !selected;
        [weakSelf.tableView reloadData];
    };
    return cell;
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        [_tableView registerClass:PW_AllNftFiltrateCell.class forCellReuseIdentifier:NSStringFromClass(PW_AllNftFiltrateCell.class)];
    }
    return _tableView;
}

@end
