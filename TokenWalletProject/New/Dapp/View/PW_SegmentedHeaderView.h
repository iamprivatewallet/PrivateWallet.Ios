//
//  PW_SegmentedHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/6/13.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SegmentedHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void(^clickBlock)(NSInteger idx);
- (void)configurationItems:(NSArray<NSString *> *)items;

@end

NS_ASSUME_NONNULL_END
