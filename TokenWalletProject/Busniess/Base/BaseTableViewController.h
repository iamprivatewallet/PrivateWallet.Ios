//
//  BaseTableViewController.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/4.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseViewController
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) BOOL isSetRadius;
//- (void)setupTableView;

@end

NS_ASSUME_NONNULL_END
