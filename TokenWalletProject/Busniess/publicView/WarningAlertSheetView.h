//
//  NotScreenshotView.h
//  TokenWalletProject
//
//  Created by fchain on 2021/7/23.
//  Copyright © 2021 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WarningAlertSheetViewDelegate <NSObject>

- (void)warningAlertSheetViewAction;

@end

@interface WarningAlertSheetView : UIView

@property (nonatomic, weak) id<WarningAlertSheetViewDelegate> delegate;


+(WarningAlertSheetView *)showAlertViewWithIcon:(NSString *)icon
                                          title:(NSString *)title
                                        content:(NSString *)content
                                        btnText:(NSString *)btnText
                                     btnBgColor:(UIColor *)bgColor
                                         action:(void(^)(void))action;

+(WarningAlertSheetView *)showExportAlertViewIsKeystore:(BOOL)isKeystore;

+(WarningAlertSheetView *)showClickViewWithItems:(NSArray *)items action:(void(^)(NSInteger index))action;

+(WarningAlertSheetView *)showSortViewWithAction:(void(^)(NSInteger index))action;

+(WarningAlertSheetView *)showNotBackupAlertViewWithAction:(void(^)(NSInteger index))action;

@end

NS_ASSUME_NONNULL_END
