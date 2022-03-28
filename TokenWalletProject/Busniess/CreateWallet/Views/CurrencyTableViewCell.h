//
//  CurrencyTableViewCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/22.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrencyTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCheck:(BOOL)isCheck;

- (void)setViewWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
