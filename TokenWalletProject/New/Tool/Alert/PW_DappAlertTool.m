//
//  PW_DappAlertTool.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/27.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_DappAlertTool.h"
#import "PW_AlertTool.h"

@implementation PW_DappAlertTool

//dapp
+ (void)showDappAuthorizationConfirm:(PW_DappPayModel *)model sureBlock:(void(^)(PW_DappPayModel *model))block {
    if (model==nil) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_authorizationConfirm") fontSize:15 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(26);
    }];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
    }];
    UILabel *tipLb = [PW_ViewTool labelSemiboldText:LocalizedStr(@"text_authorizationCount") fontSize:14 textColor:[UIColor g_grayTextColor]];
    [contentView addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.centerX.offset(0);
    }];
    UILabel *countLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@ %@",model.authorizationCount,model.symbol) fontSize:16 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:countLb];
    [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.mas_bottom).offset(10);
        make.centerX.offset(-5);
        make.left.mas_greaterThanOrEqualTo(20);
    }];
    UIButton *editBtn = [PW_ViewTool buttonImageName:@"icon_edit" target:nil action:nil];
    [editBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [self showDappMaxAuthorizationCountSureBlock:^(NSString * _Nonnull count) {
            model.authorizationCount = count;
            countLb.text = PW_StrFormat(@"%@ %@",count,model.symbol);
        }];
    }];
    [contentView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countLb.mas_right).offset(3);
        make.centerY.equalTo(countLb);
    }];
    NSArray *dataArr = @[
        @{@"title":LocalizedStr(@"text_authorizedTokenContractAddress"),@"desc":[NSString emptyStr:model.authorizedTokenContractAddress]},
        @{@"title":LocalizedStr(@"text_paymentAddress"),@"desc":[NSString emptyStr:model.paymentAddress]},
        @{@"title":LocalizedStr(@"text_acceptAddress"),@"desc":[NSString emptyStr:model.acceptAddress]},
    ];
    UIView *lastView = nil;
    for (NSDictionary *dict in dataArr) {
        UILabel *leftLb = [PW_ViewTool labelText:dict[@"title"] fontSize:13 textColor:[UIColor g_grayTextColor]];
        [leftLb setRequiredHorizontal];
        [contentView addSubview:leftLb];
        UILabel *rightLb = [PW_ViewTool labelMediumText:dict[@"desc"] fontSize:13 textColor:[UIColor g_boldTextColor]];
        rightLb.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:rightLb];
        [leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(30);
            make.top.equalTo(rightLb);
        }];
        [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView==nil) {
                make.top.equalTo(countLb.mas_bottom).offset(44);
            }else{
                make.top.equalTo(lastView.mas_bottom).offset(12);
            }
            make.right.offset(-24);
            make.left.greaterThanOrEqualTo(leftLb.mas_right).offset(5);
            make.width.lessThanOrEqualTo(contentView.mas_width).multipliedBy(0.5);
        }];
        lastView = rightLb;
    }
    UIView *minersFeeView = [[UIView alloc] init];
    [minersFeeView addTapBlock:^(UIView * _Nonnull view) {
        
    }];
    [contentView addSubview:minersFeeView];
    [minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(12);
        make.left.offset(30);
        make.right.offset(-24);
        make.height.offset(18);
    }];
    UILabel *minersFeeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [minersFeeView addSubview:minersFeeTipLb];
    [minersFeeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [minersFeeView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.offset(0);
    }];
    UILabel *minersFeeLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@%@($%@)",model.gasModel.gas_amount,model.symbol,model.gasModel.gas_ut_amout) fontSize:13 textColor:[UIColor g_boldTextColor]];
    [minersFeeView addSubview:minersFeeLb];
    [minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.equalTo(arrowIv.mas_left).offset(-5);
    }];
    UIView *tagView = [[UIView alloc] init];
    [tagView setBorderColor:[UIColor g_primaryColor] width:1 radius:8];
    [minersFeeView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minersFeeLb.mas_left).offset(-5);
        make.centerY.offset(0);
        make.height.offset(16);
    }];
    UILabel *tagLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_recommend") fontSize:11 textColor:[UIColor g_primaryColor]];
    [tagView addSubview:tagLb];
    [tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(5);
        make.right.offset(-5);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (block) {
            block(model);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView.mas_bottom).offset(52);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-30-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showDappConfirmPayInfo:(PW_DappPayModel *)model sureBlock:(void(^)(PW_DappPayModel *model))block {
    if (model==nil) {
        return;
    }
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_confirmInformation") fontSize:15 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(26);
    }];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
    }];
    UILabel *countLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@ %@",model.value,model.symbol) fontSize:16 textColor:[UIColor g_boldTextColor]];
    [contentView addSubview:countLb];
    [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.centerX.offset(0);
        make.left.mas_greaterThanOrEqualTo(20);
    }];
    NSArray *dataArr = @[
        @{@"title":LocalizedStr(@"text_paymentAddress"),@"desc":[NSString emptyStr:model.paymentAddress]},
        @{@"title":LocalizedStr(@"text_acceptAddress"),@"desc":[NSString emptyStr:model.acceptAddress]},
    ];
    UIView *lastView = nil;
    for (NSDictionary *dict in dataArr) {
        UILabel *leftLb = [PW_ViewTool labelText:dict[@"title"] fontSize:13 textColor:[UIColor g_grayTextColor]];
        [leftLb setRequiredHorizontal];
        [contentView addSubview:leftLb];
        UILabel *rightLb = [PW_ViewTool labelMediumText:dict[@"desc"] fontSize:13 textColor:[UIColor g_boldTextColor]];
        rightLb.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:rightLb];
        [leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(30);
            make.top.equalTo(rightLb);
        }];
        [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView==nil) {
                make.top.equalTo(countLb.mas_bottom).offset(44);
            }else{
                make.top.equalTo(lastView.mas_bottom).offset(12);
            }
            make.right.offset(-24);
            make.left.greaterThanOrEqualTo(leftLb.mas_right).offset(5);
            make.width.lessThanOrEqualTo(contentView.mas_width).multipliedBy(0.5);
        }];
        lastView = rightLb;
    }
    UIView *minersFeeView = [[UIView alloc] init];
    [minersFeeView addTapBlock:^(UIView * _Nonnull view) {
        
    }];
    [contentView addSubview:minersFeeView];
    [minersFeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(12);
        make.left.offset(30);
        make.right.offset(-24);
        make.height.offset(18);
    }];
    UILabel *minersFeeTipLb = [PW_ViewTool labelText:LocalizedStr(@"text_minersFee") fontSize:13 textColor:[UIColor g_grayTextColor]];
    [minersFeeView addSubview:minersFeeTipLb];
    [minersFeeTipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.offset(0);
    }];
    UIImageView *arrowIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [minersFeeView addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.offset(0);
    }];
    UILabel *minersFeeLb = [PW_ViewTool labelMediumText:PW_StrFormat(@"%@%@($%@)",model.gasModel.gas_amount,model.symbol,model.gasModel.gas_ut_amout) fontSize:13 textColor:[UIColor g_boldTextColor]];
    [minersFeeView addSubview:minersFeeLb];
    [minersFeeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.equalTo(arrowIv.mas_left).offset(-5);
    }];
    UIView *tagView = [[UIView alloc] init];
    [tagView setBorderColor:[UIColor g_primaryColor] width:1 radius:8];
    [minersFeeView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minersFeeLb.mas_left).offset(-5);
        make.centerY.offset(0);
        make.height.offset(16);
    }];
    UILabel *tagLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_recommend") fontSize:11 textColor:[UIColor g_primaryColor]];
    [tagView addSubview:tagLb];
    [tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(5);
        make.right.offset(-5);
    }];
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
        if (block) {
            block(model);
        }
    }];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagView.mas_bottom).offset(52);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-30-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
+ (void)showDappMaxAuthorizationCountSureBlock:(void(^)(NSString *count))block {
    [[UIApplication sharedApplication].delegate.window endEditing:YES];
    UIView *contentView = [[UIView alloc] init];
    UIView *view = [PW_AlertTool showSheetView:contentView];
    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_setMaxAuthorizationCount") fontSize:15 textColor:[UIColor g_boldTextColor]];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(26);
    }];
    __weak typeof(view) weakView = view;
    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
        [weakView removeFromSuperview];
    }];
    [contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
    }];
    UIView *countView = [[UIView alloc] init];
    countView.backgroundColor = [UIColor g_grayBgColor];
    [countView setBorderColor:[UIColor g_borderColor] width:1 radius:8];
    [contentView addSubview:countView];
    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
    }];
    UITextField *countTF = [[UITextField alloc] init];
    countTF.font = [UIFont pw_semiBoldFontOfSize:14];
    [countTF pw_setPlaceholder:LocalizedStr(@"text_pleaseEnterQuantity")];
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
    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
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
        make.left.offset(25);
        make.right.offset(-25);
        make.height.offset(55);
        make.bottom.offset(-30-SafeBottomInset);
    }];
    [PW_AlertTool showAnimationSheetContentView:contentView];
}
//+ (void)showDappConfirmGas:(PW_GasModel *)model sureBlock:(void(^)(PW_GasModel *model))block {
//    if (model==nil) {
//        return;
//    }
//    [[UIApplication sharedApplication].delegate.window endEditing:YES];
//    UIView *contentView = [[UIView alloc] init];
//    UIView *view = [PW_AlertTool showSheetView:contentView];
//    UILabel *titleLb = [PW_ViewTool labelMediumText:LocalizedStr(@"text_confirmInformation") fontSize:15 textColor:[UIColor g_boldTextColor]];
//    titleLb.textAlignment = NSTextAlignmentCenter;
//    [contentView addSubview:titleLb];
//    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(16);
//        make.left.offset(26);
//    }];
//    __weak typeof(view) weakView = view;
//    UIButton *closeBtn = [PW_ViewTool buttonImageName:@"icon_close" target:nil action:nil];
//    [closeBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
//        [weakView removeFromSuperview];
//    }];
//    [contentView addSubview:closeBtn];
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(10);
//        make.right.offset(-20);
//    }];
//
//    UIButton *sureBtn = [PW_ViewTool buttonSemiboldTitle:LocalizedStr(@"text_confirm") fontSize:16 titleColor:[UIColor g_primaryTextColor] cornerRadius:16 backgroundColor:[UIColor g_primaryColor] target:nil action:nil];
//    [sureBtn setShadowColor:[[UIColor g_primaryColor] alpha:0.3] offset:CGSizeMake(0, 4) radius:8];
//    [sureBtn addEvent:UIControlEventTouchUpInside block:^(UIControl * _Nonnull sender) {
//        [weakView removeFromSuperview];
//        if (block) {
//            block(model);
//        }
//    }];
//    [contentView addSubview:sureBtn];
//    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(tagView.mas_bottom).offset(52);
//        make.left.offset(25);
//        make.right.offset(-25);
//        make.height.offset(55);
//        make.bottom.offset(-30-SafeBottomInset);
//    }];
//    [PW_AlertTool showAnimationSheetContentView:contentView];
//}

@end
