//
//  AssetBottomView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/24.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetBottomView : UIView

- (void)clickBtnBlock:(void(^)(NSInteger index))block;
@end

NS_ASSUME_NONNULL_END
