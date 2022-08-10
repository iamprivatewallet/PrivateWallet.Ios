//
//  PW_AboutUsViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_AboutUsViewController.h"
#import "VersionTool.h"
#import "PW_MoreModel.h"
#import "PW_WebViewController.h"
#import "VersionModel.h"

@interface PW_AboutUsViewController ()

@property (nonatomic, strong) UIView *versionTipView;
@property (nonatomic, strong) UILabel *versionLb;
@property (nonatomic, assign) BOOL newVersion;

@end

@implementation PW_AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_aboutUs")];
    [self makeViews];
    [self requestData];
    __weak typeof(self) weakSelf = self;
    [RACObserve(self, newVersion) subscribeNext:^(NSNumber * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.versionTipView.hidden = !x.boolValue;
        if (x.boolValue) {
            [strongSelf.versionLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(strongSelf.versionTipView.mas_left).offset(-8);
                make.centerY.offset(0);
            }];
        }else{
            [strongSelf.versionLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-30);
                make.centerY.offset(0);
            }];
        }
    }];
}
- (void)checkVersion {
    [VersionTool requestAppVersionUserTake:YES completeBlock:^(BOOL isShow) {
        if(!isShow){
            [self showToast:LocalizedStr(@"text_noNewVersion")];
        }
    }];
}
- (void)openWebTitle:(NSString *)title urlStr:(NSString *)urlStr {
    PW_WebViewController *webVc = [[PW_WebViewController alloc] init];
    webVc.titleStr = title;
    webVc.urlStr = urlStr;
    [self.navigationController pushViewController:webVc animated:YES];
}
- (void)requestData {
    [self pw_requestApi:WalletVersionLastURL params:@{@"type":@"iOS",@"languageCode":@"zh_CN"} completeBlock:^(id data) {
        VersionModel *model = [VersionModel mj_objectWithKeyValues:data];
        self.newVersion = model.code>[APPBuild integerValue];
    } errBlock:nil];
}
- (void)makeViews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor g_bgColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(15);
        make.left.right.bottom.offset(0);
    }];
    [contentView setRadius:24 corners:(UIRectCornerTopLeft | UIRectCornerTopRight)];
    UIImageView *topIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_about_app"]];
    [contentView addSubview:topIv];
    [topIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom).offset(50);
        make.centerX.offset(0);
    }];
    __weak typeof(self) weakSelf = self;
    NSArray *dataArr = @[[PW_MoreModel MoreIconName:@"icon_about_update" title:LocalizedStr(@"text_updateVersion") desc:NSStringWithFormat(@"v%@(%@)",PW_APPVersion,PW_APPBuild) actionBlock:^(PW_MoreModel * _Nonnull model) {
        [weakSelf checkVersion];
    }],[PW_MoreModel MoreIconName:@"icon_about_webSite" title:LocalizedStr(@"text_webSite") actionBlock:^(PW_MoreModel * _Nonnull model) {
        [weakSelf openWebTitle:model.title urlStr:WalletWebSiteUrl];
    }],[PW_MoreModel MoreIconName:@"icon_about_bbs" title:LocalizedStr(@"text_bbs") actionBlock:^(PW_MoreModel * _Nonnull model) {
        
    }],[PW_MoreModel MoreIconName:@"icon_about_twitter" title:@"Twitter" actionBlock:^(PW_MoreModel * _Nonnull model) {
        
    }],[PW_MoreModel MoreIconName:@"icon_about_contact" title:LocalizedStr(@"text_contactUs") actionBlock:^(PW_MoreModel * _Nonnull model) {
        
    }]];
    UIView *otherView = [[UIView alloc] init];
    [contentView addSubview:otherView];
    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topIv.mas_bottom).offset(25);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    UIView *lastView = nil;
    for (NSInteger i=0; i<dataArr.count; i++) {
        PW_MoreModel *model = dataArr[i];
        UIView *rowView = [self createRowWithModel:model];
        [rowView addTapBlock:^(UIView * _Nonnull view) {
            if (model.actionBlock) {
                model.actionBlock(model);
            }
        }];
        [otherView addSubview:rowView];
        [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.offset(10);
            }
            make.left.right.offset(0);
            make.height.offset(70);
            if(i==dataArr.count-1){
                make.bottom.offset(-10);
            }
        }];
        lastView = rowView;
    }
}
- (UIView *)createRowWithModel:(PW_MoreModel *)model {
    UIView *rowView = [[UIView alloc] init];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.iconName]];
    [rowView addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelText:model.title fontSize:18 textColor:[UIColor g_textColor]];
    [rowView addSubview:titleLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [rowView addSubview:arrowIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rowView.mas_left).offset(22);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(56);
        make.centerY.offset(0);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
    }];
    if ([model.desc isNoEmpty]) {
        UILabel *descLb = [PW_ViewTool labelText:model.desc fontSize:14 textColor:[UIColor g_grayTextColor]];
        descLb.text = model.desc;
        [rowView addSubview:descLb];
        [descLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowIv.mas_left).offset(-22);
            make.centerY.offset(0);
        }];
    }
    return rowView;
}

@end
