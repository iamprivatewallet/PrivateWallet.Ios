//
//  CreateWalletView.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "CreateWalletView.h"
#import "CreateWalletInfoCell.h"


@interface CreateWalletView()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *bgWhiteView;
@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic, copy) NSString *walletType;
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation CreateWalletView

+(CreateWalletView *)getCreateWalletViewWithType:(NSString *)type{

    CreateWalletView *backView = nil;
    [SVProgressHUD dismiss];
    for (CreateWalletView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[CreateWalletView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!backView) {
        backView = [[CreateWalletView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:type];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
    }
    
    
    backView.bgWhiteView.transform = CGAffineTransformMakeTranslation(0, 700);

    [UIView animateWithDuration:0.2 animations:^{
        backView.bgWhiteView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
    
    return backView;
}

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.walletType = type;
        [self makeData];
        [self makeViews:type];
    }
    return self;
}
- (void)makeData{
    self.itemList = @[
    
        @{
            @"title":@"创建钱包",
            @"detailText":@"还未拥有钱包，点击创建",
            @"icon":@"mine_wallet"
        },
        @{
            @"title":@"助记词",
            @"detailText":@"助记词由单词组成，以空格隔开",
            @"icon":@"mnemonic"
        },
        @{
            @"title":@"私钥",
            @"detailText":@"明文私钥字符",
            @"icon":@"privateKey"
        },
        @{
            @"title":@"Keystore",
            @"detailText":@"加密的私钥JSON文件",
            @"icon":@"keystore"
        },
    ];
}
- (void)makeViews:(NSString *)type{
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
    
    UILabel *title = [ZZCustomView labelInitWithView:self.bgWhiteView text:type textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(15)];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgWhiteView);
        make.top.equalTo(self.bgWhiteView).offset(CGFloatScale(15));
    }];
    
    [self.bgWhiteView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgWhiteView).offset(10);
        make.right.equalTo(self.bgWhiteView).offset(-10);
        make.top.equalTo(closeBtn.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgWhiteView);
    }];
}
- (void)closeBtnAction{
    [self dismiss];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CreateWalletInfoCell";
    
    CreateWalletInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CreateWalletInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        [cell setViewWithData:self.itemList[0]];
    }else{
        [cell setViewWithData:self.itemList[indexPath.row+1]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return CGFloatScale(40);
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc]init];
    
    UILabel *titleLabel = [ZZCustomView labelInitWithView:bgView text:@"导入钱包" textColor:[UIColor im_textLightGrayColor] font:GCSFontRegular(14)];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.bottom.equalTo(bgView).offset(-8);
    }];
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index;
    if (indexPath.section == 0) {
        index = 0;
    }else{
        index = indexPath.row+1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCreateWalletItemIndex:)]) {
        [self dismiss];

        [self.delegate clickCreateWalletItemIndex:index];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            [UITools makeTableViewRadius:tableView displayCell:cell forRowAtIndexPath:indexPath];
        }
    }
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = CGFloatScale(75);
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
   }
    return _tableView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
