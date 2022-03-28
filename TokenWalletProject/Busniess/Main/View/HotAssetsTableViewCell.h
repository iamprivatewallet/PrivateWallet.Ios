//
//  HotAssetsTableViewCell.h
//  TokenWalletProject
//
//  Created by FChain on 2021/9/27.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotAssetsTableViewCell : UITableViewCell
- (void)setViewWithData:(id)data;
@property (nonatomic, copy) void(^addBlock)(void);
@end

NS_ASSUME_NONNULL_END
