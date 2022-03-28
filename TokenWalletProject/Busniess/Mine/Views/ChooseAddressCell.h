//
//  ChooseAddressCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/10.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAddressCell : UITableViewCell
@property (nonatomic, strong) UIButton *checkIconBtn;
- (void)setViewWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
