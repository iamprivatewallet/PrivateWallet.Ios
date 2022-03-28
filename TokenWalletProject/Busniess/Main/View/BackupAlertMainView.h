//
//  BackupAlertMainView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/28.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BackupAlertMainViewDelegate <NSObject>

- (void)backupAlertBtnAciton:(NSInteger)index;

@end

@interface BackupAlertMainView : UIView
@property (nonatomic, weak) id<BackupAlertMainViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
