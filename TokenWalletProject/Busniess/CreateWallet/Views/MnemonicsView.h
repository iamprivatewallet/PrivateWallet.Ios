//
//  MnemonicsView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/26.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicsView : UIView
- (instancetype)initWithFrame:(CGRect)frame words:(NSArray *)words;
@end

NS_ASSUME_NONNULL_END
