//
//  PW_FollowSeriesNFTItemCell.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_FollowSeriesNFTItemCell : UICollectionViewCell

@property (nonatomic, copy) void(^followBlock)(BOOL follow);

@end

NS_ASSUME_NONNULL_END