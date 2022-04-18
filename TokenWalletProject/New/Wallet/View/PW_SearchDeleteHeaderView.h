//
//  PW_SearchDeleteHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/4/14.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchDeleteHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hideDelete;
@property (nonatomic, copy) void(^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END