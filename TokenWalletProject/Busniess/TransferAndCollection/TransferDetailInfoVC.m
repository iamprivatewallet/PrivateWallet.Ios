//
//  TransferDetailInfoVC.m
//  TokenWalletProject
//
//  Created by fchain on 2021/8/30.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "TransferDetailInfoVC.h"
#import "TransferDetailInfoCell.h"
#import "BrowseWebViewController.h"

@interface TransferDetailInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *statusImg;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TransferDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav_NoLine_WithLeftItem:@"详情" rightImg:@"" rightAction:@selector(navRightItemAction)];
    [self makeViews];
    
    // Do any additional setup after loading the view.
}
- (void)navRightItemAction{
    
}
- (void)makeViews{
    self.view.backgroundColor = [UIColor navAndTabBackColor];
    self.tableView.estimatedRowHeight = 65;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
}

- (UIView *)setTopView{
    NSString *imageStr = @"registering";
    NSString *textStr = @"确认中";
    if ([self.recordModel isKindOfClass:[WalletRecord class]]) {
        WalletRecord *model = self.recordModel;
        imageStr = model.status==0?@"registering":(model.status==1?@"registerSuccess":@"registerFail");
        textStr = model.status==0?@"确认中":(model.status==1?@"成功":@"失败");
    }else if ([self.recordModel isKindOfClass:[RecordModel class]]) {
        imageStr = @"registerSuccess";
        textStr = @"成功";
    }
    UIView *view = [[UIView alloc] init];
    self.statusImg = [ZZCustomView imageViewInitView:view imageName:imageStr];
    [self.statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(40);
        make.width.height.equalTo(@50);
    }];
    self.statusLbl = [ZZCustomView labelInitWithView:view text:textStr textColor:COLORFORRGB(0x6ec5a1) font:GCSFontMedium(15)];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(self.statusImg.mas_bottom).offset(12);
    }];
    
    NSString *timeStr;
    if ([self.recordModel isKindOfClass:[RecordModel class]]) {
        RecordModel *recordModel = (RecordModel *)self.recordModel;
        timeStr = [UITools timeLabelWithTimeInterval:recordModel.timeStamp];
    }else{
        WalletRecord *recordModel = (WalletRecord *)self.recordModel;
        timeStr = recordModel.create_time;
    }
    
    self.timeLbl = [ZZCustomView labelInitWithView:view text:timeStr textColor:[UIColor im_grayColor] font:GCSFontRegular(11)];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(self.statusLbl.mas_bottom);
    }];
    return view;
}

#pragma mark Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 2;
    }
    return 1;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransferDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransferDetailInfoCell"];
    if (!cell) {
        cell = [[TransferDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TransferDetailInfoCell"];
    }
    NSString *titleStr;
    NSString *contentStr;
    if (indexPath.section == 0) {
        titleStr = @"金额";
        if ([self.recordModel isKindOfClass:[RecordModel class]]) {
            RecordModel *recordModel = (RecordModel *)self.recordModel;
            contentStr = NSStringWithFormat(@"%@%@ %@",recordModel.is_out?@"-":@"+",recordModel.value,recordModel.token_name);
        }else{
            WalletRecord *recordModel = (WalletRecord *)self.recordModel;
            contentStr = NSStringWithFormat(@"%@%@ %@",recordModel.is_out?@"-":@"+",recordModel.amount,recordModel.token_name);
        }
    }else if (indexPath.section == 1) {
        if ([self.recordModel isKindOfClass:[RecordModel class]]) {
            RecordModel *recordModel = (RecordModel *)self.recordModel;
            if (indexPath.row == 0) {
                titleStr = @"矿工费";
                if (!recordModel.gasPrice) {
                    contentStr = NSStringWithFormat(@"%@ %@",@"0",recordModel.token_name);
                }else{
                    NSString *gwei = [recordModel.gasPrice stringDownDividingBy10Power:recordModel.decimals scale:9];
                    NSString *useGasToken = [gwei stringDownMultiplyingBy:recordModel.gasUsed decimal:8];
                    contentStr = NSStringWithFormat(@"%@ %@",useGasToken,recordModel.token_name);
                }
            }else if (indexPath.row == 1) {
                titleStr = @"收款地址";
                contentStr = recordModel.to;
            }else{
                titleStr = @"付款地址";
                contentStr = recordModel.from;
            }
        }else{
            WalletRecord *recordModel = (WalletRecord *)self.recordModel;
            if (indexPath.row == 0) {
                titleStr = @"矿工费";
                if (!recordModel.gas_price) {
                    contentStr = NSStringWithFormat(@"%@ %@",@"0",recordModel.token_name);
                }else{
                    NSString *gwei = [recordModel.gas_price stringDownDividingBy10Power:recordModel.decimals scale:9];
                    NSString *useGasToken = [gwei stringDownMultiplyingBy:recordModel.gas decimal:8];
                    contentStr = NSStringWithFormat(@"%@ %@",useGasToken,recordModel.token_name);
                }
            }else if (indexPath.row == 1) {
                titleStr = @"收款地址";
                contentStr = recordModel.to_addr;
            }else{
                titleStr = @"付款地址";
                contentStr = recordModel.from_addr;
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            titleStr = @"交易号";
            if ([self.recordModel isKindOfClass:[RecordModel class]]) {
                RecordModel *recordModel = (RecordModel *)self.recordModel;
                contentStr = recordModel.hashStr;
            }else{
                WalletRecord *recordModel = (WalletRecord *)self.recordModel;
                contentStr = recordModel.trade_id;
            }
        }else{
            titleStr = @"查询详细信息";
        }
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        [cell setArrowImgWithTitle:titleStr];
    }else{
        [cell setViewWithTitle:titleStr content:contentStr];
    }
    BOOL isFirst = indexPath.section == 1 && indexPath.row == 0;
    BOOL isSecond = indexPath.section == 2 && indexPath.row == 0;

    if (isFirst || isSecond) {
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, ScreenWidth*2);
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2){
        if(indexPath.row==1){
            if ([self.recordModel isKindOfClass:[RecordModel class]]) {
                RecordModel *recordModel = (RecordModel *)self.recordModel;
                if([recordModel.detaInfoUrl isNoEmpty]){
                    BrowseWebViewController *webVc = [[BrowseWebViewController alloc] init];
                    webVc.title = @"详细信息";
                    webVc.urlStr = recordModel.detaInfoUrl;
                    [self.navigationController pushViewController:webVc animated:YES];
                }
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self setTopView];
    }
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 155;
    }
    return 15;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            
            [UITools makeTableViewRadius:tableView displayCell:cell forRowAtIndexPath:indexPath];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat sectionHeaderHeight = 155;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor navAndTabBackColor];
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
        _tableView.showsVerticalScrollIndicator = NO;
        
   }
    return _tableView;
}
@end
