//
//  SearchViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "SearchViewController.h"
#import "HotAssetsTableViewCell.h"

@interface SearchViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NoDataShowView *noDataView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithRightTitle:@"取消" rightAction:@selector(navRightItemAction)];
    [self makeNavSearchBar];
    [self makeViews];
    self.noDataView.hidden = NO;
}
- (void)makeNavSearchBar{
    UIView *bgView = [ZZCustomView viewInitWithView:self.naviBar bgColor:COLORFORRGB(0xf2f3f5)];
    bgView.layer.cornerRadius = 15;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.naviBar).offset(-3);
        make.right.equalTo(self.rightBtn.mas_left).offset(-10);
        make.left.equalTo(self.naviBar).offset(10);
        make.height.equalTo(@35);
    }];
    UIImageView *img = [ZZCustomView imageViewInitView:bgView imageName:@"search"];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(7);
        make.centerY.equalTo(bgView);
        make.width.height.equalTo(@17);
    }];
   
    UITextField *textField = [ZZCustomView textFieldInitFrame:CGRectZero view:bgView placeholder:@"" delegate:self font:GCSFontRegular(13)];
    NSString *placeholder = @"输入Token名称或合约地址";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor im_grayColor]} range:NSMakeRange(0, placeholder.length)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES;
    textField.attributedPlaceholder = att;
    [textField becomeFirstResponder];
//    [textField addTarget:self action:@selector(textFieldChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(5);
        make.right.equalTo(bgView.mas_right);
        make.top.bottom.equalTo(bgView);
    }];
}
//- (void)textFieldChangeValue:(UITextField *)sender{
//    if (self.searchList.count>0) {
//        [self.searchList removeAllObjects];
//    }
//    NSArray *list = [[AssetCoinListManager sharedInstance] getArray];
//    if (sender.text.length>0) {
//        self.noDataView.hidden = YES;
//    }else{
//        self.noDataView.hidden = NO;
//    }
//    BOOL isHas = NO;
//    for (NSDictionary *dic in list) {
//        NSString *nameStr = dic[@"tokenName"];
//        if([nameStr compare:sender.text
//                    options:NSCaseInsensitiveSearch |NSNumericSearch] == NSOrderedSame){
//            AssetCoinModel *model = [AssetCoinModel mj_objectWithKeyValues:dic];
//            [self.searchList addObject:model];
//            isHas = YES;
//        }
//    }
//    if (!isHas) {
//        self.noDataView =[NoDataShowView showView:self.view image:@"noResult" text:@"未找到相关搜索"];
//    }
//    [self.tableView reloadData];
//}
- (void)navRightItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.view);
    }];
}
- (void)requestDataWithValue:(NSString *)value {
    NSString *chainId = User_manager.currentUser.current_chainId;
    NSDictionary *paramsDict = @{
        @"tokenChain":chainId,
        @"tokenContract":value,
        @"isTop":@"1"
    };
    [self.view showLoadingIndicator];
    [self requestApi:WalletTokenIconURL params:paramsDict completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        self.searchList = [AssetCoinModel mj_objectArrayWithKeyValuesArray:data];
        [self.searchList enumerateObjectsUsingBlock:^(AssetCoinModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            User *user = User_manager.currentUser;
            AssetCoinModel *exitModel = [[WalletCoinListManager shareManager] isExit:user.chooseWallet_address type:user.chooseWallet_type tokenAddress:model.tokenContract chainId:model.tokenChain];
            model.isExit = exitModel!=nil;
        }];
        [self.tableView reloadData];
        if (self.searchList.count>0) {
            self.noDataView.hidden = YES;
        }else{
            self.noDataView.hidden = NO;
        }
    } errBlock:^(NSString *msg) {
        [self.view hideLoadingIndicator];
        [self showFailMessage:msg];
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self requestDataWithValue:[textField.text trim]];
    return [[textField.text trim] isNoEmpty];
}
#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HotAssetsTableViewCell";
    HotAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HotAssetsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    AssetCoinModel *model = self.searchList[indexPath.row];
    [cell setViewWithData:model];
    __weak typeof(self) weakSelf = self;
    cell.addBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(model.isExit){
            return;
        }
        User *user = User_manager.currentUser;
        model.sortIndex = [[WalletCoinListManager shareManager] getMaxIndex]+1;
        model.walletType = user.chooseWallet_type;
        model.walletAddress = user.chooseWallet_address;
        model.createTime = [NSDate new].timeIntervalSince1970;
        [[WalletCoinListManager shareManager] saveCoin:model];
        [strongSelf showSuccessMessage:@"添加成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoinList_Notification" object:nil];
        model.isExit = YES;
        [strongSelf.tableView reloadData];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
- (NSMutableArray *)searchList{
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc] init];
    }
    return _searchList;
}

- (NoDataShowView *)noDataView{
    if (!_noDataView) {
        _noDataView = [NoDataShowView showView:self.view image:@"noResult" text:NSStringWithFormat(@"%@支持所有ETH代币\n请输入代币名称或合约地址进行搜索",APPName)];
    }
    return _noDataView;
}

@end
