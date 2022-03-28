//
//  NodeChangeView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/9/1.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "NodeChangeView.h"
#import "NodeTableViewCell.h"
#import "TokenMessageView.h"

@interface NodeChangeView()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *shadowBgView;

@property (nonatomic, strong) NSMutableArray *mainNodeList;
@property (nonatomic, strong) NSMutableArray *otherNodeList;
@property (nonatomic, strong) NSMutableArray *customNodeList;

@property (nonatomic, strong) NodeModel *nodeModel;;

@end

@implementation NodeChangeView
+(NodeChangeView *)showNodeView{
    NodeChangeView *backView = nil;

    [SVProgressHUD dismiss];
    for (NodeChangeView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            backView = subView;
        }
    }
    if (!backView) {
        backView = [[NodeChangeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.bgView.layer.cornerRadius = 12;

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    backView.bgView.transform = CGAffineTransformMakeTranslation(0, 800);

    [UIView animateWithDuration:0.2 animations:^{
        backView.bgView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    return backView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
        [self makeNodeModel];
    }
    return self;
}

- (void)makeNodeModel{
//    [NetworkTool requestWallet:WalletTokenChainURL params:nil completeBlock:^(id  _Nonnull data) {
//        
//    } errBlock:^(NSString * _Nonnull msg) {
//        
//    }];
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

- (void)makeViews{
    self.shadowBgView = [[UIView alloc] init];
    self.shadowBgView.backgroundColor = COLORA(0, 0, 0,0.5);
    [self addSubview:self.shadowBgView];
    
    [self.shadowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor im_tableBgColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(10);
        make.top.equalTo(self).offset(kStatusBarHeight+15);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(CGFloatScale(10));
        make.top.equalTo(self.bgView).offset(CGFloatScale(10));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];
    UILabel *titleLbl = [ZZCustomView labelInitWithView:self.bgView text:@"网络切换" textColor:[UIColor im_textColor_three] font:GCSFontMedium(15)];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(CGFloatScale(10));
        make.centerX.equalTo(self.bgView);
    }];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:ImageNamed(@"settingBlack") forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-CGFloatScale(13));
        make.top.equalTo(self.bgView).offset(CGFloatScale(10));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];

    self.tableView = [ZZCustomView tableViewInitFrame:CGRectZero view:self.bgView delegate:self dataSource:self separatorStyle:UITableViewCellSeparatorStyleNone scrollEnabled:YES bgColor:[UIColor im_tableBgColor] tableviewstyle:UITableViewStylePlain];
    self.tableView.rowHeight = 65;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(closeBtn.mas_bottom).offset(5);
        make.bottom.equalTo(self.bgView).offset(-CGFloatScale(25));
    }];
}
- (void)closeBtnAction{
    self.shadowBgView.alpha = 0.5;
    self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView animateWithDuration:0.8 animations:^{
        self.shadowBgView.alpha = 0;
        self.bgView.transform = CGAffineTransformMakeTranslation(0,800);
        [self dissmissView];

    }];
}
- (void)setBtnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToNodeSettingVC)]) {
        [self.delegate jumpToNodeSettingVC];
    }
    [self dissmissView];
}
- (void)dissmissView{
    [self removeFromSuperview];
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
    static NSString *identifer = @"NodeTableViewCell";
    NodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[NodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    if (indexPath.section == 0) {
       self.nodeModel = self.mainNodeList[indexPath.row];
    }else if (indexPath.section == 1) {
        self.nodeModel = self.otherNodeList[indexPath.row];
    }else{
        self.nodeModel = self.customNodeList[indexPath.row];
    }
    
    [cell setViewWithData:self.nodeModel];
    
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
    
    self.nodeModel = model;
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseNodeWithModel:)]) {
        [self.delegate chooseNodeWithModel:model];
    }
    
    [self dissmissView];

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
@end
