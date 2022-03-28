//
//  ChooseWalletView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/2.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "ChooseWalletView.h"
#import "WalletLeftView.h"
#import "ManageWalletCell.h"

@interface ChooseWalletView()
<UITableViewDelegate,
UITableViewDataSource,
WalletLeftViewDelegate>
@property (nonatomic, strong) WalletLeftView *leftView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *orignList;
@property (nonatomic, strong) NSMutableArray *importList;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
@implementation ChooseWalletView

+(ChooseWalletView *)getChooseWallet{
    
    ChooseWalletView *backView = nil;
    [SVProgressHUD dismiss];
    for (ChooseWalletView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[ChooseWalletView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[ChooseWalletView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    
    backView.bgWhiteView.transform = CGAffineTransformMakeTranslation(0, 700);

    [UIView animateWithDuration:0.2 animations:^{
        backView.bgWhiteView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    
    return backView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.walletType = kChooseWalletTypeAll;
        [self.leftView chooseItem:self.walletType];
        [self makeViews];
        [self changeDataList];
    }
    return self;
}
- (void)changeDataList{
    if (self.orignList.count > 0) {
        [self.orignList removeAllObjects];
    }
    if (self.importList.count > 0) {
        [self.importList removeAllObjects];
    }
    if (self.walletType == kChooseWalletTypeAll) {
        
        NSArray *orignList = [[WalletManager shareWalletManager] getOrignWallets];
        [self.orignList addObjectsFromArray:orignList];
        
        NSArray *importList = [[WalletManager shareWalletManager] getImportWallets];
        [self.importList addObjectsFromArray:importList];
        
    }else{
        NSArray *list = [[WalletManager shareWalletManager] selectWalletWithType:[self getWalletType]];
        [self.orignList addObjectsFromArray:list];
    }
    [self.tableView reloadData];

}

- (NSString *)getWalletType{
    NSString *type;
    switch (self.walletType) {
        case kChooseWalletTypeETH:{
            return @"ETH";
        }
            break;
//        case kChooseWalletTypeHECO:{
//            return @"HECO";
//        }
//            break;
//        case kChooseWalletTypeBSC:{
//            return @"BSC";
//        }
//            break;
        case kChooseWalletTypeCVN:{
            return @"CVN";
        }
            break;
        default:
            break;
    }
    return type;
}

- (void)makeViews{
    [self addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.bgWhiteView];
    [self.bgWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(kNavBarAndStatusBarHeight);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:ImageNamed(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];

    [self.bgWhiteView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgWhiteView).offset(CGFloatScale(10));
        make.top.equalTo(self.bgWhiteView).offset(CGFloatScale(15));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
    }];
    
    UILabel *title = [ZZCustomView labelInitWithView:self.bgWhiteView text:@"选择钱包" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(17)];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgWhiteView);
        make.top.equalTo(self.bgWhiteView).offset(CGFloatScale(15));
    }];
    
    UIButton *manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageBtn addTarget:self action:@selector(manageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgWhiteView addSubview:manageBtn];
    [manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgWhiteView);
        make.top.equalTo(self.bgWhiteView).offset(CGFloatScale(15));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(100), CGFloatScale(25)));
    }];
    UILabel *manageLbl = [ZZCustomView labelInitWithView:manageBtn text:@"管理" textColor:[UIColor im_blueColor] font:GCSFontRegular(17)];
    [manageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(manageBtn).offset(-CGFloatScale(15));
        make.top.equalTo(manageBtn);
    }];
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.layer.cornerRadius = 12;
    [self.bgWhiteView addSubview:whiteBg];
    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgWhiteView).offset(10);
        make.right.equalTo(self.bgWhiteView).offset(-10);
        make.top.equalTo(closeBtn.mas_bottom).offset(CGFloatScale(10));
        make.bottom.equalTo(self.bgWhiteView).offset(-kBottomSafeHeight-20);
    }];
    
    [whiteBg addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(whiteBg);
        make.top.equalTo(whiteBg);
        make.width.mas_equalTo(80);
    }];
    [whiteBg addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteBg);
        make.left.equalTo(self.leftView.mas_right);
        make.top.equalTo(self.leftView);
        make.bottom.equalTo(whiteBg);
    }];
}

- (void)closeBtnAction{
    [self dismiss];
}
- (void)manageBtnAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToManageVC)]) {
        [self.delegate jumpToManageVC];
        [self dismiss];
    }
}

- (void)dismiss{
    self.bgWhiteView.transform = CGAffineTransformMakeTranslation(0, 0);

    [UIView animateWithDuration:0.2 animations:^{
        self.bgWhiteView.transform = CGAffineTransformMakeTranslation(0,700);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.walletType == kChooseWalletTypeAll) {
        if (section == 1) {
            return self.importList.count;
        }
        return self.orignList.count;
    }
    
    return self.orignList.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.walletType == kChooseWalletTypeAll && self.importList.count>0) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ManageWalletCell";
    
    ManageWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ManageWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier isChooseWallet:YES];
    }
    Wallet *wallet;
    if (indexPath.section == 1) {
        wallet = self.importList[indexPath.row];
    }else{
        wallet = self.orignList[indexPath.row];
    }
    
    [cell setViewWithData:wallet];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFloatScale(48);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]init];
    NSString *title = nil;
    if (self.walletType == kChooseWalletTypeAll) {
        if (section == 1) {
            title = @"创建/导入";
        }else{
            title = @"身份钱包";
        }
    }else {
        title = [self getWalletType];
    }
    UILabel *titleLabel = [ZZCustomView labelInitWithView:bgView text:title textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(15)];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.bottom.equalTo(bgView).offset(-10);
    }];
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseWallet:)]) {
        Wallet *wallet;
        if (self.walletType == kChooseWalletTypeAll) {
            if (indexPath.section == 1) {
                wallet = self.importList[indexPath.row];
                
            }else{
                wallet = self.orignList[indexPath.row];
            }
        }else{
            wallet = self.orignList[indexPath.row];
        }
        
        [self.delegate chooseWallet:wallet];
        
        [User_manager updateChooseWallet:wallet];
        [self dismiss];

    }
}
    

//MARK: WalletLeftViewDelegate
- (void)clickTagButtonIndex:(NSInteger)index{
    self.walletType = index;
    [self changeDataList];
}

#pragma mark getter
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = COLORA(0, 0, 0,0.5);
    }
    return _shadowView;
}
- (UIView *)bgWhiteView{
    if (!_bgWhiteView) {
        _bgWhiteView = [[UIView alloc] init];
        _bgWhiteView.layer.cornerRadius = 12;
        _bgWhiteView.backgroundColor = [UIColor navAndTabBackColor];
    }
    return _bgWhiteView;
}
- (WalletLeftView *)leftView{
    if (!_leftView) {
        _leftView = [[WalletLeftView alloc] init];
        _leftView.backgroundColor = [UIColor clearColor];
        _leftView.delegate = self;
    }
    return _leftView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = CGFloatScale(70);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];

   }
    return _tableView;
}
- (NSMutableArray *)orignList{
    if (!_orignList) {
        _orignList = [[NSMutableArray alloc] init];
    }
    return _orignList;
}
- (NSMutableArray *)importList{
    if (!_importList) {
        _importList = [[NSMutableArray alloc] init];
    }
    return _importList;
}
@end
