//
//  NodeChangeView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/9/1.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NodeChangeViewDelegate <NSObject>

- (void)jumpToNodeSettingVC;
- (void)chooseNodeWithModel:(id)model;


@end
@interface NodeChangeView : UIView
@property (nonatomic, weak) id<NodeChangeViewDelegate> delegate;

+(NodeChangeView *)showNodeView;



@end

NS_ASSUME_NONNULL_END
