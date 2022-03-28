
#import <UIKit/UIKit.h>

@interface UIViewController (ZHCustomNav)

@property (strong, nonatomic) UIView *zh_customNav;

@property (assign, nonatomic) BOOL zh_showCustomNav;

@property (strong, nonatomic) NSString *zh_title;

-(void)reloadCustomNav;


@end
