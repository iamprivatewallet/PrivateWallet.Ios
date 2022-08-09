//
//  PW_SearchNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchNFTViewController.h"
#import "PW_HotSearchNFTCell.h"
#import "PW_SearchNFTCell.h"
#import "PW_SearchNFTSectionHeaderView.h"
#import "PW_SearchRecordNFTCell.h"
#import "PW_SearchNFTModel.h"

@interface PW_SearchNFTViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray<PW_NFTSearchDBModel *> *searchRecordArr;
@property (nonatomic, assign) CGFloat searchRecordHeight;

@property (nonatomic, copy) NSArray<PW_NFTTokenModel *> *hotArr;
@property (nonatomic, strong) PW_SearchNFTModel *model;

@end

@implementation PW_SearchNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@""];
    [self makeViews];
    [self requestData];
    [self refreshSearchRecordData];
}
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchAction {
    [self requestDataWithSearchStr:self.searchTF.text.trim];
}
- (void)requestData {
    User *user = User_manager.currentUser;
    [self pw_requestNFTApi:NFTSearchMainURL params:@{@"chainId":user.current_chainId,@"address":user.chooseWallet_address} completeBlock:^(id  _Nonnull data) {
        self.hotArr = [PW_NFTTokenModel mj_objectArrayWithKeyValuesArray:data[@"hots"]];
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
    }];
}
- (void)requestDataWithSearchStr:(NSString *)searchStr {
    [self.searchTF resignFirstResponder];
    self.isSearch = YES;
    [self.tableView reloadData];
    PW_NFTSearchDBModel *model = [[PW_NFTSearchDBModel alloc] init];
    model.text = searchStr.trim;
    [[PW_NFTSearchManager shared] saveModel:model];
    [self refreshSearchRecordData];
    User *user = User_manager.currentUser;
    [self showLoading];
    [self pw_requestNFTApi:NFTSearchMainURL params:@{@"chainId":user.current_chainId,@"address":user.chooseWallet_address,@"search":searchStr} completeBlock:^(id  _Nonnull data) {
        [self dismissLoading];
        self.model = [PW_SearchNFTModel mj_objectWithKeyValues:data];
        [self.tableView reloadData];
    } errBlock:^(NSString * _Nonnull msg) {
        [self showError:msg];
        [self dismissLoading];
    }];
}
- (void)refreshSearchRecordData {
    [self.searchRecordArr removeAllObjects];
    NSArray *array = [[PW_NFTSearchManager shared] getList];
    if (array&&array.count>0) {
        [self.searchRecordArr addObjectsFromArray:array];
    }
    [self.tableView reloadData];
}
- (void)deleteAllSearchRecord {
    [[PW_NFTSearchManager shared] deleteAll];
    [self.searchRecordArr removeAllObjects];
    [self.tableView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self requestDataWithSearchStr:textField.text.trim];
    return YES;
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return 3;
    }
    if (self.searchRecordArr.count!=0) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        if (section==0) {
            return self.model.collections.count;
        }
        if (section==1) {
            return self.model.accounts.count;
        }
        return self.model.items.count;
    }
    if (self.searchRecordArr.count!=0&&section==0) {
        return 1;
    }
    return self.hotArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isSearch) {
        if(indexPath.section==0&&self.searchRecordArr.count!=0) {
            PW_SearchRecordNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_SearchRecordNFTCell.class)];
            __weak typeof(self) weakSelf = self;
            cell.heightBlock = ^(CGFloat height) {
                if (fabs(weakSelf.searchRecordHeight-height)>1) {
                    weakSelf.searchRecordHeight = height;
                    [weakSelf.tableView reloadData];
                }
            };
            cell.didClick = ^(PW_NFTSearchDBModel * _Nonnull model) {
                weakSelf.searchTF.text = model.text;
                [weakSelf requestDataWithSearchStr:model.text];
            };
            cell.dataArr = self.searchRecordArr;
            return cell;
        }
        PW_HotSearchNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_HotSearchNFTCell.class)];
        cell.model = self.hotArr[indexPath.row];
        return cell;
    }
    PW_SearchNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_SearchNFTCell.class)];
    if (indexPath.section==0) {
        cell.collectionModel = self.model.collections[indexPath.row];
    }else if (indexPath.section==1) {
        cell.accountModel = self.model.accounts[indexPath.row];
    }else{
        cell.itemModel = self.model.items[indexPath.row];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_SearchNFTSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_SearchNFTSectionHeaderView.class)];
    view.showDelete = NO;
    if (self.isSearch) {
        if (section==0) {
            view.title = @"Collections";
        }else if (section==1) {
            view.title = @"Accounts";
        }else{
            view.title = @"Items";
        }
        return view;
    }
    if (self.searchRecordArr.count!=0&&section==0) {
        view.showDelete = YES;
        view.title = LocalizedStr(@"text_searchRecord");
        __weak typeof(self) weakSelf = self;
        view.deleteBlock = ^{
            [weakSelf deleteAllSearchRecord];
        };
        return view;
    }
    view.title = LocalizedStr(@"text_hotSearch");
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isSearch&&indexPath.section==0&&self.searchRecordArr.count!=0) {
        return self.searchRecordHeight;
    }
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - views
- (void)makeViews {
    UIView *searchView = [[UIView alloc] init];
    [self.naviBar addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBtn);
        make.left.equalTo(self.leftBtn.mas_right).offset(18);
        make.right.offset(-72);
        make.height.offset(46);
    }];
    UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_bg"]];
    [searchView addSubview:bgIv];
    [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *searchIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_white"]];
    [searchView addSubview:searchIv];
    [searchIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    UITextField *searchTF = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:16] color:[UIColor g_whiteTextColor] placeholder:LocalizedStr(@"text_searchNFTContract")];
    [searchTF pw_setPlaceholder:LocalizedStr(@"text_searchNFTContract") color:[UIColor g_placeholderWhiteColor]];
    searchTF.delegate = self;
    searchTF.borderStyle = UITextBorderStyleNone;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.enablesReturnKeyAutomatically = YES;
    [searchView addSubview:searchTF];
    self.searchTF = searchTF;
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(45);
        make.right.offset(-5);
    }];
    UIButton *searchBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_search") fontSize:16 titleColor:[UIColor g_primaryColor] imageName:nil target:self action:@selector(searchAction)];
    [self.naviBar addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.centerY.equalTo(searchView).offset(0);
    }];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    [contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 56;
        _tableView.sectionHeaderHeight = 36;
        _tableView.sectionFooterHeight = 12;
        [_tableView registerClass:PW_SearchNFTSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_SearchNFTSectionHeaderView.class)];
        [_tableView registerClass:[PW_SearchNFTCell class] forCellReuseIdentifier:NSStringFromClass(PW_SearchNFTCell.class)];
        [_tableView registerClass:PW_HotSearchNFTCell.class forCellReuseIdentifier:NSStringFromClass(PW_HotSearchNFTCell.class)];
        [_tableView registerClass:[PW_SearchRecordNFTCell class] forCellReuseIdentifier:NSStringFromClass(PW_SearchRecordNFTCell.class)];
    }
    return _tableView;
}
- (NSMutableArray<PW_NFTSearchDBModel *> *)searchRecordArr {
    if (!_searchRecordArr) {
        _searchRecordArr = [NSMutableArray array];
    }
    return _searchRecordArr;
}

@end
