//
//  MessageDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/3/16.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageSystemModel.h"

@interface MessageDetailViewController ()

@property (nonatomic, strong) MessageSystemModel *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *authorLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topCons.constant = kNavBarAndStatusBarHeight;
    [self setNav_NoLine_WithLeftItem:@"详情"];
    self.scrollView.hidden = YES;
    [self loadData];
}
- (void)loadData {
    [self requestWallet:WalletMessageSysItemURL params:@{@"id":self.mid} completeBlock:^(id data) {
        self.scrollView.hidden = NO;
        self.model = [MessageSystemModel mj_objectWithKeyValues:data];
        [self makeData];
    } errBlock:^(NSString *msg) {
        [NoDataShowView showView:self.view image:@"noResult" text:msg];
    }];
}
- (void)makeData {
    self.titleLb.text = self.model.title;
    self.descLb.text = self.model.context;
    self.timeLb.text = self.model.createTime;
    self.authorLb.text = self.model.author;
}

@end
