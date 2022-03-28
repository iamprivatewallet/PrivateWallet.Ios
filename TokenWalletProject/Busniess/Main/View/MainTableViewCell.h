//
//  MainTableViewCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/29.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewCell : UITableViewCell
- (void)setViewWithData:(id)data;
- (void)changeAmountStatus;
@end

NS_ASSUME_NONNULL_END
