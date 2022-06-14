//
//  PW_SetUpViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SetUpViewController.h"
#import "PW_SetUpCell.h"
#import "PW_LanguageSetViewController.h"
#import "PW_DenominatedCurrencyViewController.h"
#import "PW_NodeSetViewController.h"

@interface PW_SetUpViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_SetUpModel *> *dataArr;

@end

@implementation PW_SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_setup")];
    [self makeViews];
    [self buildData];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.bottom.right.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.right.bottom.offset(0);
    }];
}
- (void)buildData {
    PW_SetUpModel *languageMdoel = [PW_SetUpModel SetUpIconName:@"icon_setup_language" title:LocalizedStr(@"text_multilingual") desc:[LanguageTool currentLanguage].name];
    PW_SetUpModel *denominatedModel = [PW_SetUpModel SetUpIconName:@"icon_setup_denominated" title:LocalizedStr(@"text_denominatedCurrency") desc:[PW_DenominatedCurrencyTool typeStr]];
    PW_SetUpModel *redGreenModel = [PW_SetUpModel SetUpIconName:@"icon_setup_redGreen" title:LocalizedStr(@"text_redRoseGreen") isSwitch:YES];
    redGreenModel.isOpen = [PW_RedRoseGreenFellTool isOpen];
    PW_SetUpModel *nodeSetModel = [PW_SetUpModel SetUpIconName:@"icon_setup_node" title:LocalizedStr(@"text_nodeSet")];
    [self.dataArr addObjectsFromArray:@[languageMdoel,denominatedModel,redGreenModel,nodeSetModel]];
    [self.tableView reloadData];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_SetUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_SetUpCell"];
    cell.model = self.dataArr[indexPath.row];
    cell.switchBlock = ^(PW_SetUpModel * _Nonnull model, BOOL isOn) {
        model.isOpen = isOn;
        [PW_RedRoseGreenFellTool setOpen:isOn];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_SetUpModel *obj = self.dataArr[indexPath.row];
    if (indexPath.row==0) {
        PW_LanguageSetViewController *vc = [[PW_LanguageSetViewController alloc] init];
        vc.changeBlock = ^(PW_LanguageModel * _Nonnull model) {
            obj.desc = model.name;
            [tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1) {
        PW_DenominatedCurrencyViewController *vc = [[PW_DenominatedCurrencyViewController alloc] init];
        vc.changeBlock = ^(PW_DenominatedCurrencyType type) {
            obj.desc = [PW_DenominatedCurrencyTool typeStr];
            [tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==3) {
        PW_NodeSetViewController *vc = [[PW_NodeSetViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 75;
        [_tableView registerClass:[PW_SetUpCell class] forCellReuseIdentifier:@"PW_SetUpCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_SetUpModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
