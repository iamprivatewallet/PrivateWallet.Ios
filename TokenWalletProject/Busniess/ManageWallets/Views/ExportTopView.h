//
//  ExportTopView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/8/5.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExportTopViewDelegate <NSObject>

- (void)clickItemWithIndex:(NSInteger)index;

@end
@interface ExportTopView : UIView

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, weak) id<ExportTopViewDelegate> delegate;
- (void)setTopItemTitleWithType:(BOOL)isKeystore;
- (void)chooseItemWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
