//
//  PW_filtrateNFTView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PW_filtrateNFTModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PW_filtrateNFTView : UIView

@property (nonatomic, copy) NSArray<PW_filtrateNFTModel *> *dataArr;
@property (nonatomic, copy) void(^menuBlock)(void);

@end

NS_ASSUME_NONNULL_END
