//
//  PW_BaseViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/29.
//  Copyright © 2022 . All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_BaseViewController : BaseViewController

@property (nonatomic, strong) NoDataShowView *noDataView;

- (void)makeViews;
- (void)requestData;
- (void)pw_requestApi:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock;
- (void)pw_requestWallet:(NSString *)path params:(nullable NSDictionary *)params completeBlock:(void(^_Nonnull)(id data))completeBlock errBlock:(void(^_Nullable)(NSString * _Nonnull msg))errBlock;
- (void)showSuccess:(NSString *)text;
- (void)showError:(NSString *)text;
- (void)showToast:(NSString *)text;
- (void)showMessage:(NSString *)text;
- (void)dismissMessage;

@end

NS_ASSUME_NONNULL_END
