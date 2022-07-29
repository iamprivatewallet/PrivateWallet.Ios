//
//  PW_NFTChainTypeView.m
//  TokenWalletProject
//
//  Created by mnz on 2022/7/29.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_NFTChainTypeView.h"

@interface PW_NFTChainTypeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PW_TableView *tableView;

@end

@implementation PW_NFTChainTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)showInView:(UIView *)view {
    if (view==nil) {
        return;
    }
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
- (void)dismiss {
    [self removeFromSuperview];
}
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    CGFloat height = self.tableView.contentSize.height+20;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(10);
        make.bottom.offset(-10);
        make.height.mas_equalTo(height);
    }];
}
- (void)makeViews {
    [self addSubview:self.maskView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(PW_NavStatusHeight);
        make.width.mas_equalTo(160);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(10);
        make.bottom.offset(-10);
        make.height.mas_equalTo(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTChainTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTChainTypeCell.class)];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
    if (self.clickBlock) {
        self.clickBlock();
    }
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [_tableView registerClass:PW_NFTChainTypeCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTChainTypeCell.class)];
    }
    return _tableView;
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor g_maskColor];
        [_maskView addTapTarget:self action:@selector(dismiss)];
    }
    return _maskView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
        [_contentView setCornerRadius:10];
    }
    return _contentView;
}

@end

@interface PW_NFTChainTypeCell ()

@property (nonatomic, strong) UIImageView *iconIv;
@property (nonatomic, strong) UILabel *nameLb;

@end
@implementation PW_NFTChainTypeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeViews];
    }
    return self;
}
- (void)makeViews {
    [self.contentView addSubview:self.iconIv];
    [self.contentView addSubview:self.nameLb];
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(40);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIv.mas_right).offset(5);
        make.centerY.offset(0);
        make.right.mas_lessThanOrEqualTo(-5);
    }];
}
#pragma mark - lazy
- (UIImageView *)iconIv {
    if (!_iconIv) {
        _iconIv = [[UIImageView alloc] init];
    }
    return _iconIv;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [PW_ViewTool labelSemiboldText:@"--" fontSize:15 textColor:[UIColor g_textColor]];
    }
    return _nameLb;
}

@end
