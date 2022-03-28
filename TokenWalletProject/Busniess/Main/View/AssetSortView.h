//
//  AssetSortView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AssetSortViewDelegate <NSObject>

- (void)clickItemWithIndex:(NSInteger)index;

@end
@interface AssetSortView : UIView
@property (nonatomic, weak) id<AssetSortViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
