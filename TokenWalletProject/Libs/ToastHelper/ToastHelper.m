

#import "ToastHelper.h"

@interface ToastHelper ()
{
    UIView *bgView;
    
    UILabel *label;
    
    BOOL isShowing;

}
@end

@implementation ToastHelper

+ (ToastHelper *)sharedToastHelper {
    
    static ToastHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ToastHelper alloc] init];
    });
    return instance;
}

- (void)dealloc {
    ReleaseClass;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype)init {
    if (self = [super init]) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, StatusHeight, SCREEN_WIDTH-30, NavAndStatusHeight-StatusHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor g_primaryTextColor];
        label.font = GCSFontMedium(15);
        label.numberOfLines = 0;
        isShowing = NO;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavAndStatusHeight)];
        bgView.backgroundColor = [UIColor g_primaryColor];
        [bgView addSubview:label];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] init];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [swipeGesture addTarget:self action:@selector(dismissToast)];
        [bgView addGestureRecognizer:swipeGesture];
    }
    return self;
}

- (void)toast:(NSString *)textString afterDelay:(CGFloat)delay {
    [self performSelector:@selector(toast:) withObject:textString afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}

- (void)toast:(NSString *)textString {
    if (isShowing) {
        return;
    }
    isShowing = YES;
    CGFloat text_h = [textString heightWithFont:self->label.font constrainedToWidth:SCREEN_WIDTH-30];
    CGFloat view_h = MAX(NavAndStatusHeight, StatusHeight+text_h+20);
    dispatch_async(dispatch_get_main_queue(), ^{
        self->label.text = textString;
        [TheAppDelegate.window addSubview:self->bgView];
        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:1.5f inModes:@[NSRunLoopCommonModes]];
        self->bgView.frame = CGRectMake(0, -view_h, [UIScreen mainScreen].bounds.size.width, view_h);
        self->label.frame = CGRectMake(15, StatusHeight+5, SCREEN_WIDTH-30, text_h);
        [UIView animateWithDuration:0.25 animations:^{
            self->bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view_h);
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)showToast:(NSString *)textString {
    if (isShowing) {
        return;
    }
    isShowing = YES;
    CGFloat text_h = [textString heightWithFont:self->label.font constrainedToWidth:SCREEN_WIDTH-30];
    CGFloat view_h = MAX(NavAndStatusHeight, StatusHeight+text_h+20);
    dispatch_async(dispatch_get_main_queue(), ^{
        self->label.text = textString;
        [TheAppDelegate.window addSubview:self->bgView];
        self->bgView.frame = CGRectMake(0, -view_h, [UIScreen mainScreen].bounds.size.width, view_h);
        self->label.frame = CGRectMake(15, StatusHeight+5, SCREEN_WIDTH-30, text_h);
        [UIView animateWithDuration:0.25 animations:^{
            self->bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view_h);
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)dismissToast {
    CGFloat text_h = [label.text heightWithFont:self->label.font constrainedToWidth:SCREEN_WIDTH-30];
    CGFloat view_h = MAX(NavAndStatusHeight, StatusHeight+text_h+20);
    bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view_h);
    [UIView animateWithDuration:0.25 animations:^{
        self->bgView.frame = CGRectMake(0, -view_h, [UIScreen mainScreen].bounds.size.width, view_h);
    } completion:^(BOOL finished) {
        [self->bgView removeFromSuperview];
        self->isShowing = NO;
    }];
}


@end
