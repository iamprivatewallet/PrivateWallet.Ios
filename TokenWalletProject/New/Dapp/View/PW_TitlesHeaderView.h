//
//  PW_TitlesHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/20.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_TitlesHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void(^clickBlock)(NSInteger idx);

@end

NS_ASSUME_NONNULL_END
