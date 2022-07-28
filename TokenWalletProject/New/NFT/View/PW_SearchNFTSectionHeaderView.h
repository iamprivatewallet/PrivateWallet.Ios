//
//  PW_SearchNFTSectionHeaderView.h
//  TokenWalletProject
//
//  Created by mnz on 2022/7/28.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SearchNFTSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showDelete;
@property (nonatomic, copy) void(^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
