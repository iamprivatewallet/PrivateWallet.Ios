//
//  PW_MessageDetailViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_MessageDetailViewController.h"
#import "MessageSystemModel.h"

@interface PW_MessageDetailViewController ()

@property (nonatomic, strong) MessageSystemModel *model;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UILabel *timeLb;
@property (nonatomic, strong) UILabel *authorLb;
@property (strong, nonatomic) UILabel *descLb;

@end

@implementation PW_MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_detail")];
    self.scrollView.hidden = YES;
    [self makeViews];
    [self loadData];
}
- (void)loadData {
    [self pw_requestApi:WalletMessageSysItemURL params:@{@"id":self.mid} completeBlock:^(id data) {
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
- (void)makeViews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [self.scrollView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
        make.height.greaterThanOrEqualTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    self.titleLb = [PW_ViewTool labelText:@"--" fontSize:26 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    self.timeLb = [PW_ViewTool labelText:@"--" fontSize:14 textColor:[UIColor g_grayTextColor]];
    [self.timeLb setRequiredHorizontal];
    self.timeLb.numberOfLines = 1;
    [self.contentView addSubview:self.timeLb];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    self.authorLb = [PW_ViewTool labelText:@"" fontSize:14 textColor:[UIColor g_grayTextColor]];
    self.authorLb.numberOfLines = 1;
    [self.contentView addSubview:self.authorLb];
    [self.authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.timeLb.mas_right).offset(10);
        make.centerY.equalTo(self.timeLb);
        make.right.offset(-36);
    }];
    self.descLb = [PW_ViewTool labelText:@"--" fontSize:16 textColor:[UIColor g_textColor]];
    [self.contentView addSubview:self.descLb];
    [self.descLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLb.mas_bottom).offset(15);
        make.left.offset(36);
        make.right.offset(-36);
        make.bottom.mas_lessThanOrEqualTo(-20);
    }];
}

@end
