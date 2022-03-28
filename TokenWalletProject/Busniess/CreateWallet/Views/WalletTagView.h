//
//  WalletTagView.h
//  TokenWalletProject
//
//  Created by jackygood on 2018/12/2.
//  Copyright © 2018 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletTagView : UIView

@property BOOL isFinished;
-(instancetype)initWithFrame:(CGRect)frame isEdit:(BOOL)isEdit words:(NSArray*)words;

@end

NS_ASSUME_NONNULL_END
