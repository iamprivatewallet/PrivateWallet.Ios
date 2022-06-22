//
//  PW_NodeListViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/18.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NodeListViewController.h"
#import "PW_NodeListCell.h"

@interface PW_NodeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_NetworkModel *> *dataArr;
@property (nonatomic, strong) UIView *addNodeView;

@end

@implementation PW_NodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:NSStringWithFormat(@"%@%@",self.model.title,LocalizedStr(@"text_nodeSet")) rightTitle:LocalizedStr(@"text_save") rightAction:@selector(saveAction)];
    [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    [self makeViews];
}
- (void)addNodeAction {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:LocalizedStr(@"text_addNode") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField pw_setPlaceholder:@"https://"];
        textField.textColor = [UIColor g_whiteTextColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalizedStr(@"text_cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:LocalizedStr(@"text_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addNodeWith:alertVc.textFields.firstObject.text];
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}
- (void)addNodeWith:(NSString *)rpcUrl {
    if (![rpcUrl isNoEmpty]||![rpcUrl isHttpsURL]) {
        [self showError:LocalizedStr(@"text_error")];
        return;
    }
    PW_NetworkModel *model = [PW_NetworkModel mj_objectWithKeyValues:self.model.mj_JSONObject];
    model.rpcUrl = rpcUrl;
    [[PW_NodeManager shared] saveNodeModel:model];
    [self.dataArr addObject:model];
    [self.tableView reloadData];
    [self showSuccess:LocalizedStr(@"text_saveSuccess")];
}
- (void)saveAction {
    PW_NetworkModel *model = nil;
    for (PW_NetworkModel *obj in self.dataArr) {
        [[PW_NodeManager shared] updateNode:obj];
        if (obj.selected) {
            model = obj;
        }
    }
    if (model) {
        if(self.changeBlock){
            self.changeBlock(model);
        }
        [User_manager updateCurrentNode:model.rpcUrl chainId:model.chainId name:model.title];
        [[NSNotificationCenter defaultCenter] postNotificationName:kChainNodeUpdateNotification object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_NodeListCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        PW_NetworkModel *model = self.dataArr[indexPath.row];
        [[PW_NodeManager shared] deleteNodeModel:model];
        [self.dataArr removeObject:model];
        [tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NetworkModel *model = self.dataArr[indexPath.row];
    for (PW_NetworkModel *obj in self.dataArr) {
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
        _tableView.rowHeight = 74;
        [_tableView registerClass:[PW_NodeListCell class] forCellReuseIdentifier:@"PW_NodeListCell"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeBottomInset, 0);
        _tableView.tableFooterView = self.addNodeView;
    }
    return _tableView;
}
- (UIView *)addNodeView {
    if (!_addNodeView) {
        _addNodeView = [[UIView alloc] init];
        _addNodeView.frame = CGRectMake(0, 0, 0, 54);
        UIButton *addBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_addCustomNode") fontSize:15 titleColor:[UIColor g_grayTextColor] imageName:@"icon_add" target:self action:@selector(addNodeAction)];
        addBtn.frame = CGRectMake(20, 10, SCREEN_WIDTH-72, 44);
        [addBtn setDottedLineColor:[UIColor g_dottedColor] lineWidth:1 length:3 space:3 radius:12];
        [_addNodeView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(36);
            make.right.offset(-36);
            make.height.offset(44);
        }];
    }
    return _addNodeView;
}
- (NSMutableArray<PW_NetworkModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:[[PW_NodeManager shared] getNodeListWithChainId:self.model.chainId]];
    }
    return _dataArr;
}

@end
