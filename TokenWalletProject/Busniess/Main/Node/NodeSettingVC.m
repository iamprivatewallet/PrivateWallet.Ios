//
//  NodeSettingVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/1.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "NodeSettingVC.h"
#import "NodeSetTableCell.h"
#import "CustomNodeVC.h"

@interface NodeSettingVC ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NodeModel *nodeModel;;
@property (nonatomic, strong) NSMutableArray *mainNodeList;
@property (nonatomic, strong) NSMutableArray *otherNodeList;
@property (nonatomic, strong) NSMutableArray *customNodeList;

@end

@implementation NodeSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"ETHEREUM 节点设置" rightImg:@"addContact" rightAction:@selector(rightNavItemAction)];
    [self makeViews];
    [self makeNodeModel];

    // Do any additional setup after loading the view.
}

- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 75;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(CGFloatScale(10));
        make.right.equalTo(self.view).offset(-CGFloatScale(10));
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.view).offset(-CGFloatScale(25));
    }];
}
- (void)rightNavItemAction{
    [WarningAlertSheetView showClickViewWithItems:@[@"快捷添加",@"自定义"] action:^(NSInteger index) {
        if (index == 1) {
            //快捷添加
        }else if (index == 2){
            //自定义
            [WarningAlertSheetView showAlertViewWithIcon:@"alarm" title:@"自定义节点" content:@"请确认配置可信任第三方节点，避免产生潜在的风险。" btnText:@"知道了" btnBgColor:[UIColor im_btnSelectColor] action:^{
                CustomNodeVC *vc = [[CustomNodeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
    }];
}
- (void)makeNodeModel{
    NSArray *other_arr = @[@{@"name":@"Binance Smart Chain",@"chainId":kBSCChainId},
                           @{@"name":@"Huobi ECO Chain",@"chainId":kHECOChainId}];
    
    NodeModel *model = [[NodeModel alloc] init];
    model.node_name = @"Ethereum Mainnet";
    model.node_url = [[SettingManager sharedInstance] getNodeWithChainId:kETHChainId];
    model.node_chainID = kETHChainId;
    [self.mainNodeList addObject:model];
    
    for (int i = 0; i<other_arr.count; i++) {
        NodeModel *model = [[NodeModel alloc] init];
        model.node_name = other_arr[i][@"name"];
        NSString *chainId = other_arr[i][@"chainId"];
        model.node_chainID = chainId;
        model.node_url = [[SettingManager sharedInstance] getNodeWithChainId:chainId];
        [self.otherNodeList addObject:model];
    }
    
    NSArray *customArr = [[SettingManager sharedInstance] getCustomNodeArray];
    [customArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NodeModel *model = [NodeModel mj_objectWithKeyValues:obj];
        [self.customNodeList addObject:model];
    }];
    
    [self.tableView reloadData];
}
#pragma mark Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.customNodeList.count>0) {
        return 3;
    }
    return 2;
}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.mainNodeList.count;
    }else if (section == 1) {
        return self.otherNodeList.count;
    }else{
        return self.customNodeList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"NodeSetTableCell";
    NodeSetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[NodeSetTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if (indexPath.section == 0) {
       self.nodeModel = self.mainNodeList[indexPath.row];
    }else if (indexPath.section == 1) {
        self.nodeModel = self.otherNodeList[indexPath.row];
    }else{
        self.nodeModel = self.customNodeList[indexPath.row];
    }
    
    [cell fillData:self.nodeModel];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:view text:@"" textColor:[UIColor im_grayColor] font:GCSFontRegular(13)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(18);
        make.bottom.equalTo(view).offset(-8);
    }];
    if (section == 0) {
        titleLbl.text = @"主网络";
    }else if (section == 1) {
        titleLbl.text = @"其他网络";
    }else if (section == 2) {
        titleLbl.text = @"自定义网络";
    }else{
        titleLbl.text = @"测试网";
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            [UITools makeTableViewRadius:tableView displayCell:cell forRowAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NodeModel *model;
    if (indexPath.section == 0) {
        model = self.mainNodeList[indexPath.row];
        
    }else if (indexPath.section == 1) {
        model = self.otherNodeList[indexPath.row];
    }else{
        model = self.customNodeList[indexPath.row];
    }
    
    [User_manager updateCurrentNode:model.node_url chainId:model.node_chainID name:model.node_name];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChainNodeUpdateNotification object:model];
    self.nodeModel = model;
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSMutableArray *)mainNodeList{
    if (!_mainNodeList) {
        _mainNodeList = [[NSMutableArray alloc] init];
    }
    return _mainNodeList;
}
- (NSMutableArray *)otherNodeList{
    if (!_otherNodeList) {
        _otherNodeList = [[NSMutableArray alloc] init];
    }
    return _otherNodeList;
}
- (NSMutableArray *)customNodeList{
    if (!_customNodeList) {
        _customNodeList = [[NSMutableArray alloc] init];
    }
    return _customNodeList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.rowHeight = CGFloatScale(70);
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.separatorColor = [UIColor im_borderLineColor];
   }
    return _tableView;
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
