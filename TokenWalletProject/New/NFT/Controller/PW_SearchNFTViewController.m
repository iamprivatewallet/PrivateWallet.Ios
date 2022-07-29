//
//  PW_SearchNFTViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_SearchNFTViewController.h"
#import "PW_SearchNFTCell.h"
#import "PW_SearchNFTSectionHeaderView.h"
#import "PW_SearchRecordNFTCell.h"

@interface PW_SearchNFTViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableArray *searchRecordArr;
@property (nonatomic, assign) CGFloat searchRecordHeight;

@end

@implementation PW_SearchNFTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:@""];
    [self makeViews];
    [self.searchRecordArr addObjectsFromArray:@[@1,@2,@3,@4,@5,@6]];
}
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchAction {
    
}
- (void)makeViews {
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
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
    [self.view addSubview:searchBtn];
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
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return 0;
    }
    if (self.searchRecordArr.count!=0) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return 0;
    }
    if (self.searchRecordArr.count!=0&&section==0) {
        return 1;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isSearch&&indexPath.section==0&&self.searchRecordArr.count!=0) {
        PW_SearchRecordNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_SearchRecordNFTCell.class)];
        __weak typeof(self) weakSelf = self;
        cell.heightBlock = ^(CGFloat height) {
            if (fabs(weakSelf.searchRecordHeight-height)>1) {
                weakSelf.searchRecordHeight = height;
                [weakSelf.tableView reloadData];
            }
        };
        cell.dataArr = self.searchRecordArr;
        return cell;
    }
    PW_SearchNFTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_SearchNFTCell.class)];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_SearchNFTSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_SearchNFTSectionHeaderView.class)];
    view.showDelete = NO;
    if (self.isSearch) {
        return view;
    }
    if (self.searchRecordArr.count!=0&&section==0) {
        view.showDelete = YES;
        view.title = LocalizedStr(@"text_searchRecord");
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
        [_tableView registerClass:[PW_SearchRecordNFTCell class] forCellReuseIdentifier:NSStringFromClass(PW_SearchRecordNFTCell.class)];
    }
    return _tableView;
}
- (NSMutableArray *)searchRecordArr {
    if (!_searchRecordArr) {
        _searchRecordArr = [NSMutableArray array];
    }
    return _searchRecordArr;
}

@end
