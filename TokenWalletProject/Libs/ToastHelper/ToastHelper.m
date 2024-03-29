

#import "ToastHelper.h"

@interface ToastHelper ()
{
    UIView *bgView;
    
    UILabel *label;
    
    BOOL isShowing;

}
@end

@implementation ToastHelper

+ (ToastHelper *)sharedToastHelper
{
    
    static ToastHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ToastHelper alloc] init];
    });
    return instance;
}

-(void)dealloc
{
    ReleaseClass;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(instancetype)init
{
    if (self = [super init]) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, StatusHeight, SCREEN_WIDTH-30, NavAndStatusHeight-StatusHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.font = GCSFontRegular(14);
        label.numberOfLines = 0;
        isShowing = NO;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavAndStatusHeight)];
        bgView.backgroundColor = [UIColor im_btnSelectColor];
        [bgView addSubview:label];
        
    }
    return self;
}

- (void)toast:(NSString *)textString afterDelay:(CGFloat)delay
{
    [self performSelector:@selector(toast:) withObject:textString afterDelay:delay inModes:@[NSRunLoopCommonModes]];
}

- (void)toast:(NSString *)textString
{
    if (isShowing) {
        return;
    }
    isShowing = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->label.text = textString;
        [TheAppDelegate.window addSubview:self->bgView];
        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:1.5f inModes:@[NSRunLoopCommonModes]];
        
        self->bgView.frame = CGRectMake(0, -NavAndStatusHeight, [UIScreen mainScreen].bounds.size.width, NavAndStatusHeight);
        [UIView animateWithDuration:.1 animations:^{
            self->bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NavAndStatusHeight);
        } completion:^(BOOL finished) {
            
        }];
        
    });
}

- (void)showToast:(NSString *)textString {
    if (isShowing) {
        return;
    }
    isShowing = YES;
    CGFloat text_h = [textString heightWithFont:GCSFontRegular(14) constrainedToWidth:SCREEN_WIDTH-30];
    CGFloat view_h = StatusHeight+text_h+20;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->label.text = textString;
        [TheAppDelegate.window addSubview:self->bgView];
        self->bgView.frame = CGRectMake(0, -view_h, [UIScreen mainScreen].bounds.size.width, view_h);
        [UIView animateWithDuration:.1 animations:^{
            self->bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view_h);
            self->label.frame = CGRectMake(15, StatusHeight+5, SCREEN_WIDTH-30, text_h);

        } completion:^(BOOL finished) {
            
        }];
        
    });
}

-(void)dismissToast
{
    bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NavAndStatusHeight);
    [UIView animateWithDuration:.1 animations:^{
        self->bgView.frame = CGRectMake(0,-NavAndStatusHeight, [UIScreen mainScreen].bounds.size.width, NavAndStatusHeight);
    } completion:^(BOOL finished) {
        [self->bgView removeFromSuperview];
        self->isShowing = NO;
    }];
}


@end
