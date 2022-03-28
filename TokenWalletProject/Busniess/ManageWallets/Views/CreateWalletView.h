//
//  CreateWalletView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/3.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CreateWalletViewDelegate <NSObject>

- (void)clickCreateWalletItemIndex:(NSInteger)index;

@end

@interface CreateWalletView : UIView
@property (nonatomic, weak) id<CreateWalletViewDelegate> delegate;

+(CreateWalletView *)getCreateWalletViewWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
