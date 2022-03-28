//
//  AllDAppsViewController.m
//  TokenWalletProject
//
//  Created by FChain on 2021/9/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "AllDAppsViewController.h"
#import "DAppsTableViewCell.h"
#import "WebViewController.h"
@interface AllDAppsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation AllDAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeViews];
    NSString *str;
    NSArray *list;
    if (self.dataList.count>0) {
        [self.dataList removeAllObjects];
    }
    if (self.allType == kAllDAppsTypeLately) {
        str = @"最近使用";
        list = [[VisitDAppsRecordManager sharedInstance] getDAppsVisitArray];
    }else{
        str = @"我的收藏";
        list = [[DAppsManager sharedInstance] getDAppsCollectionArray];
    }
    [self setNavTitleWithLeftItem:str rightTitle:@"编辑" rightAction:@selector(editItemAction) isNoLine:NO];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BrowseRecordsModel *model = [BrowseRecordsModel mj_objectWithKeyValues:obj];
        [self.dataList addObject:model];
    }];
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view.
}
- (void)makeViews{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarAndStatusBarHeight);
    }];
}

- (void)editItemAction{
    //编辑
    [self.tableView setEditing:YES animated:YES];
    
}
#pragma mark Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DAppsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DAppsTableViewCell"];
    if (!cell) {
        cell = [[DAppsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DAppsTableViewCell"];
    }
    [cell fillData:self.dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BrowseRecordsModel *model = self.dataList[indexPath.row];
    WebViewController *vc = [WebViewController loadWebViewWithData:model];
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowseRecordsModel *model = self.dataList[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataList removeObjectAtIndex:indexPath.row];
        if (self.allType == kAllDAppsTypeCollection) {
            [[DAppsManager sharedInstance] deleteDApps:model.appUrl];
        }else{
            [[VisitDAppsRecordManager sharedInstance] deleteDAppsRecord:model.appUrl];
        }
        [self.tableView reloadData];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor mp_lineGrayColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 85;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
   }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
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
