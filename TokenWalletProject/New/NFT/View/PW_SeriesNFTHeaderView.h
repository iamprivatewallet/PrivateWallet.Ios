//
//  PW_SeriesNFTHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/31.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SeriesNFTHeaderView : UIView

@property (nonatomic, copy) void(^heightBlock)(void);

@end

NS_ASSUME_NONNULL_END