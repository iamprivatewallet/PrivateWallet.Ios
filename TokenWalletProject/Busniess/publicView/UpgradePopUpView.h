//
//  UpgradePopUpView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/3/18.
//  Copyright © 2022 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpgradePopUpView : UIView

+ (nullable UpgradePopUpView *)showUpgradePopUpViewWithModel:(VersionModel *)model;
+ (nullable UpgradePopUpView *)showUpgradePopUpViewWithModel:(VersionModel *)model userTake:(BOOL)userTake;

@end

NS_ASSUME_NONNULL_END
