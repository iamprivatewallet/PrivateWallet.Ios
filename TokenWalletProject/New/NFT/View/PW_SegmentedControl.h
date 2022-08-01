//
//  PW_SegmentedControl.h
//  TokenWalletProject
//
//  Created by mnz on 2022/8/1.
//  Copyright © 2022 . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PW_SegmentedControl : UIView

@property (nonatomic, copy) NSArray<NSString *> *dataArr;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, copy) void(^didClick)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
