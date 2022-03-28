//
//  MineViewController.m
//  TokenWalletProject
//
//  Created by MM on 2020/10/23.
//  Copyright © 2020 Zinkham. All rights reserved.
//

#import "MineViewController.h"
#import "MangeIDWalletVC.h"
#import "AddressBookViewController.h"
#import "UseSettingViewController.h"
#import "AboutUsViewController.h"
#import "MessageCenterViewController.h"
#import "MangeWalletsVC.h"
#import "BrowseWebViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, copy) NSArray *iconList;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我" rightImg:@"mine_noti" rightAction:@selector(messageCenterAction)];
    self.titleLable.font = GCSFontRegular(16);
    self.titleList = @[@"管理钱包",@"地址薄",@"设置",@"使用说明",@"建议与反馈",@"用户协议",@"关于我们"];
    self.iconList = @[@"mine_wallet",@"mine_contact",@"mine_setting",@"mine_help",@"mine_guid",@"mine_protocol",@"mine_aboutUs"];
    
    [self makeViews];
    // Do any additional setup after loading the view.
}

- (void)makeViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}

// MARK: TableViewDelegate & TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1) {
        return 2;
    }else{
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
       
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *iconImg = [[UIImageView alloc] init];
    [cell.contentView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(CGFloatScale(20));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(20), CGFloatScale(20)));
        make.centerY.equalTo(cell.contentView);
    }];
    cell.textLabel.textColor = [UIColor im_textColor_three];
    cell.textLabel.font = GCSFontRegular(15);
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImg.mas_right).offset(CGFloatScale(20));
        make.centerY.equalTo(cell.contentView);
    }];
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:ImageNamed(@"arrowRightGray")];
    [cell.contentView addSubview:arrowImg];
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
        make.size.mas_equalTo(CGSizeMake(CGFloatScale(15), CGFloatScale(15)));
        make.centerY.equalTo(cell.contentView);
    }];
    
    
    NSString *iconName;
    NSString *titleStr;

    if (indexPath.section == 0) {
       iconName = self.iconList[0];
       titleStr = self.titleList[0];
    }else if(indexPath.section == 1){
        iconName = self.iconList[indexPath.row+1];
        titleStr = self.titleList[indexPath.row+1];
    }else if(indexPath.section == 2){
        iconName = self.iconList[indexPath.row+3];
        titleStr = self.titleList[indexPath.row+3];
    }
    cell.textLabel.text = titleStr;
    iconImg.image = ImageNamed(iconName);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGFloatScale(56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFloatScale(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MangeWalletsVC *vc = [[MangeWalletsVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            AddressBookViewController *vc = [[AddressBookViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UseSettingViewController *vc = [[UseSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            BrowseWebViewController *webVc = [[BrowseWebViewController alloc] init];
            webVc.title = self.titleList[indexPath.row+3];
            if (indexPath.row == 0) {
                webVc.urlStr = WalletUseDirectionsUrl;
            }else if (indexPath.row == 1) {
                webVc.urlStr = WalletFeedbackUrl;
            }else if (indexPath.row == 2) {
                webVc.urlStr = WalletUserAgreementUrl;
            }
            [self.navigationController pushViewController:webVc animated:YES];
        }else if (indexPath.row == 3) {
            AboutUsViewController *vc = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor im_tableBgColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
    
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   }
    return _tableView;
}
//消息中心
- (void)messageCenterAction{
    MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
