//
//  PW_DappAlertTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappAlertTool.h"
#import "PW_AlertTool.h"
#import "PW_DappMinersFeeView.h"

@implementation PW_DappAlertTool

//dapp
+ (void)showDappAuthorizationConfirm:(PW_DappPayModel *)model sureBlock:(void(^)(PW_DappPayModel *model))block closeBlock:(nonnull void (^)(void))closeBlock {
    if (model==nil) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_approveConfirm") fontSize:20 textColor:[UIColor g_textColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(36);
    }];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (closeBlock) {
            closeBlock();
        }
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLb);
        make.right.offset(-36);
        make.width.height.mas_equalTo(24);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_primaryColor];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(1);
    }];
    UIView *amountView = [[UIView alloc] init];
    amountView.backgroundColor = [UIColor colorWithPatternImage:[UIImage pw_imageGradientSize:CGSizeMake(SCREEN_WIDTH-72, 65) gradientColors:@[[UIColor g_darkGradientStartColor],[UIColor g_darkGradientEndColor]] gradientType:PW_GradientLeftToRight cornerRadius:8]];
    [contentView addSubview:amountView];
    [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(25);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(65);
    }];
    UILabel *tipLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_approvedAmount") fontSize:14 textColor:[UIColor g_primaryColor]];
    [amountView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.centerX.offset(0);
    }];
    NSString *countStr = model.value;
    if ([countStr.lowercaseString isEqualToString:MaxAuthorizationCount]) {
        countStr = LocalizedStr(@"text_unlimited");
    }else{
        countStr = [countStr strTo10];
    }
    UILabel *countLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@ %@",countStr,model.symbol) fontSize:16 textColor:[UIColor g_whiteTextColor]];
    [amountView addSubview:countLb];
    [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(6);
        make.centerX.offset(0);
        make.left.mas_greaterThanOrEqualTo(20);
    }];
    UIButton *editBtn = [PW_ViewTool buttonImageName:@"icon_edit" target:nil action:nil];
    [editBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [self showDappMaxAuthorizationCountSureBlock:^(NSString * _Nonnull count) {
            model.value = count;
            countLb.text = PW_StrFormat(@"%@ %@",count,model.symbol);
        }];
    }];
    [amountView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(countLb);
    }];
    NSArray *dataArr = @[
        @{@"title":LocalizedStr(@"text_paymentAddress"),@"desc":[NSString emptyStr:model.paymentAddress]},
        @{@"title":LocalizedStr(@"text_authorizedContractAddress"),@"desc":[NSString emptyStr:model.acceptAddress]},
    ];
    UIView *lastView = nil;
    for (NSDictionary *dict in dataArr) {
        UILabel *titleLb = [PW_ViewTool labelText:dict[@"title"] fontSize:14 textColor:[UIColor g_grayTextColor]];
        [contentView addSubview:titleLb];
        UILabel *valueLb = [PW_ViewTool labelMediumText:dict[@"desc"] fontSize:14 textColor:[UIColor g_textColor]];
        [contentView addSubview:valueLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(36);
            if (lastView==nil) {
                make.top.equalTo(amountView.mas_bottom).offset(28);
            }else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            make.right.mas_lessThanOrEqualTo(-36);
        }];
        [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(6);
            make.left.offset(36);
            make.right.mas_lessThanOrEqualTo(-36);
        }];
        lastView = valueLb;
    }
    UIView *minersFeeView = [[UIView alloc] init];
    [contentView addSubview:minersFeeView];
    [minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(22);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    UILabel *minersFeeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [minersFeeView addSubview:minersFeeTipLb];
    [minersFeeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [minersFeeView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.offset(0);
    }];
    UILabel *minersFeeLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@%@($%@)",model.gasModel.gas_amount,model.symbol,model.gasModel.gas_ut_amout) fontSize:13 textColor:[UIColor g_boldTextColor]];
    [minersFeeView addSubview:minersFeeLb];
    [minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeTipLb.mas_bottom).offset(6);
        make.left.offset(0);
        make.right.mas_lessThanOrEqualTo(-20);
    }];
    UIView *tagView = [[UIView alloc] init];
    [tagView setCornerRadius:8];
    tagView.backgroundColor = [UIColor g_darkBgColor];
    [minersFeeView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeLb.mas_bottom).offset(6);
        make.height.offset(18);
        make.bottom.offset(0);
    }];
    UILabel *tagLb = [PW_ViewTool labelText:LocalizedStr(@"text_avg") fontSize:13 textColor:[UIColor g_whiteTextColor]];
    [tagView addSubview:tagLb];
    [tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    [minersFeeView addTapBlock:^(UIView * _Nonnull view) {
        [self showDappConfirmGas:model.gasToolModel sureBlock:^(PW_GasModel * _Nonnull gasModel, NSString * _Nonnull title) {
            model.gasModel = gasModel;
            minersFeeLb.text = PW_StrFormat(@"%@%@($%@)",gasModel.gas_amount,model.symbol,gasModel.gas_ut_amout);
            tagLb.text = title;
        }];
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (block) {
            block(model);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeView.mas_bottom).offset(26);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-30-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showDappConfirmPayInfo:(PW_DappPayModel *)model sureBlock:(void(^)(PW_DappPayModel *model))block closeBlock:(nonnull void (^)(void))closeBlock {
    if (model==nil) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_confirmInformation") fontSize:20 textColor:[UIColor g_textColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(28);
        make.left.offset(36);
    }];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (closeBlock) {
            closeBlock();
        }
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLb);
        make.right.offset(-36);
        make.width.height.mas_equalTo(24);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor g_primaryColor];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_equalTo(1);
    }];
    UILabel *countLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@ %@",model.value,model.symbol) fontSize:22 textColor:[UIColor g_textColor]];
    [contentView addSubview:countLb];
    [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(25);
        make.centerX.offset(0);
        make.left.mas_greaterThanOrEqualTo(20);
    }];
    NSArray *dataArr = @[
        @{@"title":LocalizedStr(@"text_paymentAddress"),@"desc":[NSString emptyStr:model.paymentAddress]},
        @{@"title":LocalizedStr(@"text_acceptAddress"),@"desc":[NSString emptyStr:model.acceptAddress]},
    ];
    UIView *lastView = nil;
    for (NSDictionary *dict in dataArr) {
        UILabel *titleLb = [PW_ViewTool labelText:dict[@"title"] fontSize:14 textColor:[UIColor g_grayTextColor]];
        [contentView addSubview:titleLb];
        UILabel *valueLb = [PW_ViewTool labelMediumText:dict[@"desc"] fontSize:14 textColor:[UIColor g_textColor]];
        [contentView addSubview:valueLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(36);
            if (lastView==nil) {
                make.top.equalTo(countLb.mas_bottom).offset(28);
            }else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            make.right.mas_lessThanOrEqualTo(-36);
        }];
        [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom).offset(6);
            make.left.offset(36);
            make.right.mas_lessThanOrEqualTo(-36);
        }];
        lastView = valueLb;
    }
    UIView *minersFeeView = [[UIView alloc] init];
    [contentView addSubview:minersFeeView];
    [minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(22);
        make.left.offset(36);
        make.right.offset(-36);
    }];
    UILabel *minersFeeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [minersFeeView addSubview:minersFeeTipLb];
    [minersFeeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [minersFeeView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.offset(0);
    }];
    UILabel *minersFeeLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@%@($%@)",model.gasModel.gas_amount,model.symbol,model.gasModel.gas_ut_amout) fontSize:13 textColor:[UIColor g_boldTextColor]];
    [minersFeeView addSubview:minersFeeLb];
    [minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeTipLb.mas_bottom).offset(6);
        make.left.offset(0);
        make.right.mas_lessThanOrEqualTo(-20);
    }];
    UIView *tagView = [[UIView alloc] init];
    [tagView setCornerRadius:8];
    tagView.backgroundColor = [UIColor g_darkBgColor];
    [minersFeeView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeLb.mas_bottom).offset(6);
        make.height.offset(18);
        make.bottom.offset(0);
    }];
    UILabel *tagLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_avg") fontSize:13 textColor:[UIColor g_whiteTextColor]];
    [tagView addSubview:tagLb];
    [tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    [minersFeeView addTapBlock:^(UIView * _Nonnull view) {
        [self showDappConfirmGas:model.gasToolModel sureBlock:^(PW_GasModel * _Nonnull gasModel, NSString * _Nonnull title) {
            model.gasModel = gasModel;
            minersFeeLb.text = PW_StrFormat(@"%@%@($%@)",gasModel.gas_amount,model.symbol,gasModel.gas_ut_amout);
            tagLb.text = title;
        }];
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (block) {
            block(model);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeView.mas_bottom).offset(26);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
        make.bottom.offset(-20-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showDappMaxAuthorizationCountSureBlock:(void(^)(NSString *count))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_setMaxAuthorizationCount") fontSize:18 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(36);
    }];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLb);
        make.right.offset(-36);
        make.width.height.mas_equalTo(24);
    }];
    UIView *countView = [[UIView alloc] init];
    [countView setBorderColor:[UIColor g_borderDarkColor] width:1 radius:8];
    [contentView addSubview:countView];
    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
    }];
    UITextField *countTF = [[UITextField alloc] init];
    countTF.font = [UIFont pw_regularFontOfSize:14];
    [countTF pw_setPlaceholder:LocalizedStr(@"text_approvedAmount")];
    countTF.textColor = [UIColor g_textColor];
    countTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    countTF.keyboardType = UIKeyboardTypeNumberPad;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        CGFloat duration = [x.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect frame = [x.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [UIView animateWithDuration:duration animations:^{
            contentView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        CGFloat duration = [x.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:duration animations:^{
            contentView.transform = CGAffineTransformIdentity;
        }];
    }];
    [countView addSubview:countTF];
    [countTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(20);
        make.right.offset(-15);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
    RAC(sureBtn, enabled) = [RACSignal combineLatest:@[countTF.rac_textSignal] reduce:^id(NSString *count){
        return @(count.length>0&&[count isInt]);
    }];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (block) {
            block(countTF.text);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countView.mas_bottom).offset(20);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
        make.bottom.offset(-20-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showDappConfirmGas:(PW_GasToolModel *)model sureBlock:(void(^)(PW_GasModel *model, NSString *title))block {
    if (model==nil) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_minerFeeSetting") fontSize:15 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_back" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeBtn);
        make.left.equalTo(closeBtn.mas_right).offset(20);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(20);
    }];
    PW_DappMinersFeeView *minersFeeView = [[PW_DappMinersFeeView alloc] init];
    minersFeeView.toolModel = model;
    [contentView addSubview:minersFeeView];
    [minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.mas_greaterThanOrEqualTo(50);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:8 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (block) {
            block([minersFeeView getCurrentGasModel], minersFeeView.title);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeView.mas_bottom).offset(18);
        make.left.offset(36);
        make.right.offset(-36);
        make.height.offset(55);
        make.bottom.offset(-20-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}

@end
