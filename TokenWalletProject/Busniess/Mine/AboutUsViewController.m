//
//  AboutUsViewController.m
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AboutUsViewController.h"
#import "VersionTool.h"

@interface AboutUsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitleWithLeftItem:@"关于我们"];
    [self makeViews];
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}
// MARK: TableViewDelegate & TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = GCSFontRegular(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr;
    if (indexPath.section == 0) {
        UIImageView *arrowImg = [[UIImageView alloc] init];
        [cell.contentView addSubview:arrowImg];
        CGFloat size_w = 15;
        if (indexPath.row == 0) {
            titleStr = @"应用评分";
            arrowImg.image = ImageNamed(@"dappStarred");
            size_w = 20;
//        }else if (indexPath.row == 1) {
//            titleStr = @"版本日志";
//            arrowImg.image = ImageNamed(@"arrowRightGray");
        }else{
            titleStr = @"版本更新";
        }
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
            make.size.mas_equalTo(CGSizeMake(CGFloatScale(size_w), CGFloatScale(size_w)));
            make.centerY.equalTo(cell.contentView);
        }];
    }else if (indexPath.section == 1) {
        UILabel *languageLbl = [ZZCustomView labelInitWithView:cell.contentView text:WalletWebSiteUrl textColor:[UIColor im_blueColor] font:GCSFontRegular(14)];
        [languageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-CGFloatScale(20));
            make.centerY.equalTo(cell.contentView);
        }];
        switch (indexPath.row) {
            case 0:{
                titleStr = @"网站";
            }
                break;
            case 1:{
                titleStr = @"论坛";
            }
                break;
            case 2:{
                titleStr = @"Twitter";
            }
                break;
            case 3:{
                titleStr = @"微信公众号";
            }
                break;
        }
    }
    cell.textLabel.text = titleStr;
    cell.textLabel.textColor = [UIColor im_textColor_three];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFloatScale(15);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            
        }else if(indexPath.row==1){
            [VersionTool requestAppVersionUserTake:YES completeBlock:^(BOOL isShow) {
                if(!isShow){
                    [self showToastMessage:@"暂无新版本"];
                }
            }];
        }
    }
}
#pragma mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.rowHeight = CGFloatScale(56);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self makeTableHeaderView];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}
- (UIView *)makeTableHeaderView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFloatScale(160))];
    UIImageView *icon = [ZZCustomView imageViewInitView:bgView imageName:@"logo"];
    icon.layer.cornerRadius = 8;
    icon.layer.masksToBounds = YES;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(CGFloatScale(30));
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UILabel *nameLb = [ZZCustomView labelInitWithView:bgView text:APPName textColor:[UIColor blackColor] font:GCSFontSemibold(16)];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(icon.mas_bottom).offset(CGFloatScale(5));
    }];
    
    UILabel *detailLbl = [ZZCustomView labelInitWithView:bgView text:NSStringWithFormat(@"v%@(%@)",APPVersion,APPBuild) textColor:[UIColor lightGrayColor] font:GCSFontRegular(13)];
    [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(nameLb.mas_bottom).offset(CGFloatScale(5));
    }];
    return bgView;
}

@end
