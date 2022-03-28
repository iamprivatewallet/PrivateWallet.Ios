//
//  FeeCustomCell.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/16.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FeeCustomCellDelegate <NSObject>

- (void)getCustomInfo:(UITextField *)textField;

@end
@interface FeeCustomCell : UITableViewCell

@property (nonatomic, weak) id<FeeCustomCellDelegate> delegate;
@property (nonatomic, strong) UITextField *priceTF;

- (void)fillDataWithPriceHighest:(NSString *)price gasHighest:(NSString *)gas;

@end

NS_ASSUME_NONNULL_END
