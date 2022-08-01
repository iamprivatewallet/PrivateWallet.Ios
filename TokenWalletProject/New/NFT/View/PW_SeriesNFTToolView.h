//
//  PW_SeriesNFTToolView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/31.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SeriesNFTToolView : UIView

@property (nonatomic, copy) void(^segmentIndexBlock)(NSInteger index);
@property (nonatomic, copy) void(^typesettingBlock)(NSInteger index);
@property (nonatomic, copy) void(^filtrateBlock)(void);

@end

NS_ASSUME_NONNULL_END
