//
//  PW_MoreAlertViewController.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_BaseViewController.h"
#import "PW_MoreAlertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_MoreAlertViewController : PW_BaseViewController

@property (nonatomic, copy) NSArray<PW_MoreAlertModel *> *dataArr;
- (void)show;

@end

NS_ASSUME_NONNULL_END
