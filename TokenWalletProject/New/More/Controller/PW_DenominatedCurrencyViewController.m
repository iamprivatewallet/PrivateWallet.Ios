//
//  PW_DenominatedCurrencyViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DenominatedCurrencyViewController.h"
#import "PW_DenominatedCurrencyCell.h"

@interface PW_DenominatedCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_DenominatedCurrencyModel *> *dataArr;
@property (nonatomic, assign) PW_DenominatedCurrencyType oldType;

@end

@implementation PW_DenominatedCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_denominatedCurrency") rightTitle:LocalizedStr(@"text_finish") rightAction:@selector(finishAction)];
    [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    self.oldType = [PW_DenominatedCurrencyTool getType];
    [self makeViews];
}
- (void)finishAction {
    PW_DenominatedCurrencyModel *model = nil;
    for (PW_DenominatedCurrencyModel *obj in self.dataArr) {
        if (obj.selected) {
            model = obj;
            break;
        }
    }
    if (model&&self.oldType!=model.type) {
        [PW_DenominatedCurrencyTool setType:model.type];
        if (self.changeBlock) {
            self.changeBlock(model.type);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    PW_DenominatedCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_DenominatedCurrencyCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_DenominatedCurrencyModel *model = self.dataArr[indexPath.row];
    for (PW_DenominatedCurrencyModel *obj in self.dataArr) {
        obj.selected = NO;
    }
    model.selected = YES;
    [tableView reloadData];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 72;
        [_tableView registerClass:[PW_DenominatedCurrencyCell class] forCellReuseIdentifier:@"PW_DenominatedCurrencyCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_DenominatedCurrencyModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        PW_DenominatedCurrencyModel *rmbModel = [PW_DenominatedCurrencyModel DenominatedCurrencyIconStr:@"￥" title:NSStringWithFormat(@"%@（￥）",LocalizedStr(@"text_rmb")) type:PW_DenominatedCurrencyRMB];
        rmbModel.selected = self.oldType==PW_DenominatedCurrencyRMB;
        PW_DenominatedCurrencyModel *dollarModel = [PW_DenominatedCurrencyModel DenominatedCurrencyIconStr:@"$" title:NSStringWithFormat(@"%@（$）",LocalizedStr(@"text_dollar")) type:PW_DenominatedCurrencyDollar];
        dollarModel.selected = self.oldType==PW_DenominatedCurrencyDollar;
        [_dataArr addObjectsFromArray:@[rmbModel,dollarModel]];
    }
    return _dataArr;
}

@end
