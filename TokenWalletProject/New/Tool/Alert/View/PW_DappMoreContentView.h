//
//  PW_DappMoreContentView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_DappMoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_DappMoreContentView : UIView

@property (nonatomic, copy) NSArray<PW_DappMoreModel *> *dataArr;
@property (nonatomic, copy) void(^clickBlock)(PW_DappMoreModel *model);

@end

NS_ASSUME_NONNULL_END
