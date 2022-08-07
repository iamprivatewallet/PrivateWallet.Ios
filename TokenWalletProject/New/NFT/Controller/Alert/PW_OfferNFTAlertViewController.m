//
//  PW_OfferNFTAlertViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/8/7.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_OfferNFTAlertViewController.h"
#import "PW_OfferNFTAlertSectionHeaderView.h"
#import "PW_NFTDetailOfferCell.h"

@interface PW_OfferNFTAlertViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UITextField *priceTf;
@property (nonatomic, strong) UILabel *unitLb;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) PW_TableView *tableView;

@end

@implementation PW_OfferNFTAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor g_maskColor];
    [self clearBackground];
    [self makeViews];
}
- (void)sureAction {
    
}
- (void)show {
    [[PW_APPDelegate getRootCurrentNavc] presentViewController:self animated:NO completion:nil];
}
- (void)closeAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_NFTDetailOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PW_NFTDetailOfferCell.class)];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PW_OfferNFTAlertSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(PW_OfferNFTAlertSectionHeaderView.class)];
    return view;
}
- (void)makeViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_greaterThanOrEqualTo(400);
    }];
    UILabel *titleLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_auction") fontSize:15 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:titleLb];
    [self.contentView addSubview:self.closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24);
        make.left.offset(30);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UIView *bidView = [[UIView alloc] init];
    bidView.backgroundColor = [UIColor g_bgCardColor];
    [bidView setBorderColor:[UIColor g_lineColor] width:1 radius:8];
    [self.contentView addSubview:bidView];
    [bidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(92);
    }];
    UILabel *bidTipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_bid") fontSize:16 textColor:[UIColor g_textColor]];
    [bidView addSubview:bidTipLb];
    [bidTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(12);
    }];
    [bidView addSubview:self.priceTf];
    [bidView addSubview:self.unitLb];
    [self.priceTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.bottom.offset(-12);
        make.left.offset(12);
        make.right.equalTo(self.unitLb.mas_left).offset(-10);
    }];
    [self.unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.centerY.equalTo(self.priceTf);
    }];
    [self.contentView addSubview:self.sureBtn];
    [self.contentView addSubview:self.tableView];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bidView.mas_bottom).offset(15);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
}
- (void)addContentAnimation {
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.contentView.bounds.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addContentAnimation];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
}
#pragma mark - lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor g_bgColor];
    }
    return _contentView;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:self action:@selector(closeAction)];
    }
    return _closeBtn;
}
- (UITextField *)priceTf {
    if (!_priceTf) {
        _priceTf = [PW_ViewTool textFieldFont:[UIFont pw_regularFontOfSize:14] color:[UIColor g_textColor] placeholder:LocalizedStr(@"text_inputPrice")];
        _priceTf.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _priceTf;
}
- (UILabel *)unitLb {
    if (!_unitLb) {
        _unitLb = [PW_ViewTool labelMediumText:@"--" fontSize:14 textColor:[UIColor g_textColor]];
        [_unitLb setRequiredHorizontal];
    }
    return _unitLb;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:15 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:self action:@selector(sureAction)];
    }
    return _sureBtn;
}
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 28;
        _tableView.sectionHeaderHeight = 28;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, PW_SafeBottomInset+10, 0);
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:PW_OfferNFTAlertSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PW_OfferNFTAlertSectionHeaderView.class)];
        [_tableView registerClass:PW_NFTDetailOfferCell.class forCellReuseIdentifier:NSStringFromClass(PW_NFTDetailOfferCell.class)];
    }
    return _tableView;
}

@end
