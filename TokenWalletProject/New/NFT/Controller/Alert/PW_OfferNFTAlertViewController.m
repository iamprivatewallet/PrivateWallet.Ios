//
//  PW_OfferNFTAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_OfferNFTAlertViewController.h"
#import "PW_OfferNFTAlertSectionHeaderView.h"
#import "PW_OfferNFTAlertCell.h"
#import "PW_ConfirmSellNFTAlertViewController.h"

@interface PW_OfferNFTAlertViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) UIButton *sortBtn;

@end

@implementation PW_OfferNFTAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeViews];
}
- (void)sortAction {
    self.sortBtn.selected = !self.sortBtn.isSelected;
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_OfferNFTAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_OfferNFTAlertCell.class)];
    __weak typeof(self) weakSelf = self;
    cell.sellBlock = ^{
        PW_ConfirmSellNFTAlertViewController *vc = [[PW_ConfirmSellNFTAlertViewController alloc] init];
        [weakSelf presentViewController:vc animated:NO completion:nil];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_OfferNFTAlertSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_OfferNFTAlertSectionHeaderView.class)];
    return view;
}
#pragma mark - views
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(310);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_offer") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:titleLb];
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    [self.contentView addSubview:closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.right.offset(-30);
        make.width.height.mas_equalTo(24);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_primaryColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(55);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.mas_equalTo(1);
    }];
    UILabel *tipLb = [PW_ViewTool labelText:LocalizedStr(@"text_auctionRecord") fontSize:13 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:tipLb];
    UILabel *priceLb = [PW_ViewTool labelText:LocalizedStr(@"text_price") fontSize:13 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:priceLb];
    [self.contentView addSubview:self.sortBtn];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(12);
        make.left.offset(30);
    }];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(12);
        make.right.offset(-44);
    }];
    [self.sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.equalTo(priceLb);
    }];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(40);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 28;
        _tableView.sectionHeaderHeight = 28;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        [_tableView registerClass:PW_OfferNFTAlertSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_OfferNFTAlertSectionHeaderView.class)];
        [_tableView registerClass:PW_OfferNFTAlertCell.class forCellReuseIdentifier:NSStringFromClass(PW_OfferNFTAlertCell.class)];
    }
    return _tableView;
}
- (UIButton *)sortBtn {
    if (!_sortBtn) {
        _sortBtn = [PW_ViewTool buttonImageName:@"icon_sort_desc" selectedImage:@"icon_sort_asc" target:self action:@selector(sortAction)];
    }
    return _sortBtn;
}

@end
