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
#import "BrowseWebViewController.h"
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
    BrowseWebViewController *webVc = [[BrowseWebViewController alloc] init];
    webVc.title = title;
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
    UIImageView *topIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_about_app"]];
    [self.view addSubview:topIv];
    [topIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(50);
        make.centerX.offset(0);
    }];
    UILabel *nameLb = [PW_ViewTool labelBoldText:PW_APPName fontSize:16 textColor:[UIColor g_boldTextColor]];
    [self.view addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topIv.mas_bottom).offset(22);
        make.centerX.offset(0);
    }];
    UIView *updateView = [[UIView alloc] init];
    [updateView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.view addSubview:updateView];
    [updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLb.mas_bottom).offset(56);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(45);
    }];
    UIView *updateItemView = [self createRowIconName:@"icon_about_update" title:LocalizedStr(@"text_updateVersion")];
    [updateItemView addTapTarget:self action:@selector(checkVersion)];
    [updateView addSubview:updateItemView];
    self.versionLb = [PW_ViewTool labelText:NSStringWithFormat(@"v%@(%@)",PW_APPVersion,PW_APPBuild) fontSize:13 textColor:[UIColor g_grayTextColor]];
    [updateItemView addSubview:self.versionLb];
    self.versionTipView = [[UIView alloc] init];
    self.versionTipView.backgroundColor = [UIColor g_primaryColor];
    self.versionTipView.layer.cornerRadius = 2.5;
    self.versionTipView.hidden = YES;
    [updateItemView addSubview:self.versionTipView];
    [updateItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.versionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.centerY.offset(0);
    }];
    [self.versionTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.width.height.offset(5);
        make.centerY.offset(0);
    }];
    __weak typeof(self) weakSelf = self;
    NSArray *dataArr = @[[PW_MoreModel MoreIconName:@"icon_about_webSite" title:LocalizedStr(@"text_webSite") actionBlock:^(PW_MoreModel * _Nonnull model) {
        [weakSelf openWebTitle:model.title urlStr:WalletWebSiteUrl];
    }],[PW_MoreModel MoreIconName:@"icon_about_bbs" title:LocalizedStr(@"text_bbs") actionBlock:^(PW_MoreModel * _Nonnull model) {
        
    }],[PW_MoreModel MoreIconName:@"icon_about_twitter" title:@"Twitter" actionBlock:^(PW_MoreModel * _Nonnull model) {
        
    }],[PW_MoreModel MoreIconName:@"icon_about_contact" title:LocalizedStr(@"text_contactUs") actionBlock:^(PW_MoreModel * _Nonnull model) {
        
    }]];
    UIView *otherView = [[UIView alloc] init];
    [otherView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [self.view addSubview:otherView];
    [otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(updateView.mas_bottom).offset(16);
        make.left.offset(20);
        make.right.offset(-20);
    }];
    UIView *lastView = nil;
    for (NSInteger i=0; i<dataArr.count; i++) {
        PW_MoreModel *model = dataArr[i];
        UIView *rowView = [self createRowIconName:model.iconName title:model.title];
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
            make.height.offset(45);
            if(i==dataArr.count-1){
                make.bottom.offset(-10);
            }
        }];
        lastView = rowView;
    }
}
- (UIView *)createRowIconName:(NSString *)iconName title:(NSString *)title {
    UIView *rowView = [[UIView alloc] init];
    UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [rowView addSubview:iconIv];
    UILabel *titleLb = [PW_ViewTool labelMediumText:title fontSize:14 textColor:[UIColor g_textColor]];
    [rowView addSubview:titleLb];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [rowView addSubview:arrowIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.offset(0);
    }];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIv.mas_right).offset(12);
        make.centerY.offset(0);
    }];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    return rowView;
}

@end
