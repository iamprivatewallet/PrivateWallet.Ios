//
//  BrowseViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/20.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BrowseViewController.h"
#import "DAppsShowAlertView.h"
#import "WebViewController.h"
#import "DAppsTopItemsView.h"
#import "DAppsCollocationView.h"
#import "DAppsTableViewCell.h"
#import "AllDAppsViewController.h"
#import "NSString+RegexCategory.h"
#import "TokenChainModel.h"

@interface BrowseViewController ()
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
WBQRCodeDelegate
>
@property (nonatomic, strong) DAppsTopItemsView *centerItems;
@property (nonatomic, strong) DAppsCollocationView *collectionView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *appsList;
@property (nonatomic, copy) NSArray *chainTypeArr;

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavSearchBar];
    [self makeViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView makeDataReload];
    [self loadChainList];
}
- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
}
- (void)makeNavSearchBar{
    [self setNavTitle:@"" isNoLine:NO];
    UIView *bgView = [ZZCustomView viewInitWithView:self.naviBar bgColor:[UIColor whiteColor]];
    bgView.layer.cornerRadius = 15;
    bgView.layer.borderColor = [UIColor im_borderLineColor].CGColor;
    bgView.layer.borderWidth = 1;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.naviBar).offset(-3);
        make.right.equalTo(self.naviBar).offset(-10);
        make.left.equalTo(self.naviBar).offset(10);
        make.height.equalTo(@35);
    }];
    UIImageView *img = [ZZCustomView imageViewInitView:bgView imageName:@"search"];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(7);
        make.centerY.equalTo(bgView);
        make.width.height.equalTo(@17);
    }];
    
    UIButton *scanBtn = [ZZCustomView buttonInitWithView:bgView imageName:@"scan"];
    [scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-15);
        make.centerY.equalTo(bgView);
        make.width.height.equalTo(@23);
    }];
   
    UITextField *textField = [ZZCustomView textFieldInitFrame:CGRectZero view:bgView placeholder:@"" delegate:self font:GCSFontRegular(13)];
    textField.keyboardType = UIKeyboardTypeURL;
    textField.returnKeyType = UIReturnKeyGo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSString *placeholder = @"搜索或输入DApp网址";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor im_grayColor]} range:NSMakeRange(0, placeholder.length)];
    textField.attributedPlaceholder = att;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(5);
        make.top.bottom.equalTo(bgView);
        make.right.equalTo(scanBtn.mas_left).offset(-5);
    }];
}
- (void)loadChainList {
    if(self.chainTypeArr&&self.chainTypeArr.count>0){
        return;
    }
    [self.view showLoadingIndicator];
    [self requestApi:WalletTokenChainURL params:nil completeBlock:^(id data) {
        [self.view hideLoadingIndicator];
        self.chainTypeArr = [TokenChainModel mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray *titleArr = [[NSMutableArray alloc] init];
        for (TokenChainModel *model in self.chainTypeArr) {
            if(![model.title isEmptyStr]){
                [titleArr addObject:model.title];
            }
        }
        [self.centerItems makeViewsWithArr:titleArr];
        [self loadRequestWithIndex:0];
    } errBlock:^(NSString *msg) {
        [self.view hideLoadingIndicator];
        [self showFailMessage:msg];
    }];
}
- (void)loadRequestWithIndex:(NSInteger)index {
    if(index<0||index>=self.chainTypeArr.count){return;}
    TokenChainModel *model = self.chainTypeArr[index];
    [self.appsList removeAllObjects];
    if(model.dappList&&model.dappList.count>0){
        [self.appsList addObjectsFromArray:model.dappList];
        [self.tableView reloadData];
        return;
    }
    [self.tableView reloadData];
    [self requestApi:WalletDappListURL params:@{@"chainId":model.chainId} completeBlock:^(id data) {
        self.appsList = [BrowseRecordsModel mj_objectArrayWithKeyValuesArray:data];
        model.dappList = self.appsList;
        [self.tableView reloadData];
    } errBlock:^(NSString *msg) {
        [self showFailMessage:msg];
    }];
}
- (void)changeItemWithIndex:(NSInteger)index{
    [self loadRequestWithIndex:index];
}
- (void)scanBtnAction{
    //扫描
    if (![CATCommon isHaveAuthorForCamer]) {
        return;
    }
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    WBVC.delegate = self;
    WBVC.zh_showCustomNav = YES;
    [UITools QRCodeFromVC:self scanVC:WBVC];
}
//MARK: WBQRCodeDelegate
- (void)scanNoPopWithResult:(NSString*)result {
    if([result isValidUrl]){
        BrowseRecordsModel *dataModel = [[BrowseRecordsModel alloc] init];
        dataModel.appUrl = result;
        WebViewController *vc = [WebViewController loadWebViewWithData:dataModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.appsList.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.centerItems];
    [self.centerItems mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.bottom.equalTo(view);
        make.height.equalTo(@50);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DAppsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DAppsTableViewCell"];
    if (!cell) {
        cell = [[DAppsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DAppsTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fillData:self.appsList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BrowseRecordsModel *model = self.appsList[indexPath.row];
    if([model.appUrl isEmptyStr]){
        return;
    }
    WebViewController *vc = [WebViewController loadWebViewWithData:model];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *urlStr = textField.text;
    if([NSURL URLWithString:urlStr]==nil){
        [self showFailMessage:@"链接不正确"];
        return YES;
    }
    BrowseRecordsModel *dataModel = [[BrowseRecordsModel alloc] init];
    dataModel.appUrl = urlStr;
    WebViewController *vc = [WebViewController loadWebViewWithData:dataModel];
    [self.navigationController pushViewController:vc animated:YES];
    return YES;
}
- (DAppsCollocationView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[DAppsCollocationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    }
    return _collectionView;
}
- (DAppsTopItemsView *)centerItems{
    if (!_centerItems) {
        _centerItems = [[DAppsTopItemsView alloc] init];
        __weak typeof(self) weakSelf = self;
        _centerItems.changeItemBlock = ^(NSInteger index) {
            [weakSelf changeItemWithIndex:index];
        };
    }
    return _centerItems;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 85;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 50;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.tableHeaderView = self.collectionView;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
   }
    return _tableView;
}
- (NSMutableArray *)appsList{
    if (!_appsList) {
        _appsList = [[NSMutableArray alloc] init];
    }
    return _appsList;
}
@end
