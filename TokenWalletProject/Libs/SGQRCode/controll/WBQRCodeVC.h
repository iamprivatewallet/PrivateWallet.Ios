//
//  WBQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBQRCodeDelegate <NSObject>

@optional 
- (void)scanResult:(NSString*)result;

- (void)scanNoPopWithResult:(NSString*)result;


@end

@interface WBQRCodeVC : UIViewController

@property (nonatomic, weak) id<WBQRCodeDelegate> delegate;

@end
