

#import <Foundation/Foundation.h>

@interface ToastHelper : NSObject

+ (ToastHelper *)sharedToastHelper;

- (void)toast:(NSString *)textString;

- (void)toast:(NSString *)textString afterDelay:(CGFloat)delay;


- (void)showToast:(NSString *)textString;

- (void)dismissToast;

- (void)remakeViewFrame;

@end
