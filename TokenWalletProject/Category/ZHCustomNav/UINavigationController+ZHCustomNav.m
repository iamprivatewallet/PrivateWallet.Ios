#import "UINavigationController+ZHCustomNav.h"
#import <objc/runtime.h>

@implementation UIViewController (ZHCustomNav)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(zh_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        
        SEL originalSelector2 = @selector(viewDidLoad);
        SEL swizzledSelector2 = @selector(zh_viewDidLoad);
        
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        
        BOOL success2 = class_addMethod(class, originalSelector2, method_getImplementation(swizzledMethod2), method_getTypeEncoding(swizzledMethod2));
        if (success2) {
            class_replaceMethod(class, swizzledSelector2, method_getImplementation(originalMethod2), method_getTypeEncoding(originalMethod2));
        } else {
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
        }
    });
    
}

-(void)zh_viewDidLoad
{
    [self zh_viewDidLoad];
    [self reloadCustomNav];
}

- (void)zh_viewWillAppear:(BOOL)animated
{
    
    [self zh_viewWillAppear:animated];
    
    [self reloadCustomNav];
}

-(void)goBack
{
    if (self.navigationController == nil || self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)reloadCustomNav
{
    if (self.zh_customNav == nil) {
        UIImageView *navView = [[UIImageView alloc] initWithFrame:
                                CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NavAndStatusHeight)];
        navView.backgroundColor = NAV_COLOR;
//        navView.image = [UIImage imageNamed:@"nav_bg"];
//        navView.contentMode = UIViewContentModeScaleAspectFill;
        navView.userInteractionEnabled = YES;
        navView.layer.masksToBounds = YES;
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, StatusHeight, NavHeight, NavHeight)];
        backBtn.backgroundColor = [UIColor clearColor];
        backBtn.contentMode = UIViewContentModeCenter;
        backBtn.tag = 1000;
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:backBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, StatusHeight , [UIScreen mainScreen].bounds.size.width-100, NavHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font =Set_Font(@"Light", 16);  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
        titleLabel.tag = 2000;
        titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [navView addSubview:titleLabel];
        
        self.zh_customNav = navView;
        
    }

    if (self.zh_showCustomNav) {
        
        self.navigationController.navigationBarHidden = YES;
        self.fd_prefersNavigationBarHidden = YES;
        self.zh_customNav.hidden = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        UILabel *titleLabel = [self.zh_customNav viewWithTag:2000];
        if (titleLabel) {
            titleLabel.text = self.zh_title;
        }
        
        [self.zh_customNav removeFromSuperview];
        [self.view addSubview:self.zh_customNav];
        [self.view bringSubviewToFront:self.zh_customNav];
        
        UIButton *backBtn = [self.zh_customNav viewWithTag:2000];
        if (backBtn) {
            if (self.presentingViewController || self.navigationController.viewControllers.count > 1) {
                [self.zh_customNav viewWithTag:1000].hidden = NO;
            } else {
                [self.zh_customNav viewWithTag:1000].hidden = YES;
            }
        }
        
    } else {
        
        self.navigationController.navigationBarHidden = NO;
        self.fd_prefersNavigationBarHidden = NO;
        self.zh_customNav.hidden = YES;
    }
    
    if (self.navigationController == [UIApplication sharedApplication].keyWindow.rootViewController) {
        self.navigationController.navigationBarHidden = YES;
        self.fd_prefersNavigationBarHidden = YES;
    }
}

-(UIView *)zh_customNav
{
    return objc_getAssociatedObject(self, @"zh_navigationView");
}

-(void)setZh_customNav:(UIView *)navigationView
{
    objc_setAssociatedObject(self, @"zh_navigationView", navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadCustomNav];
}

-(NSString *)zh_title
{
    return objc_getAssociatedObject(self, @"zh_title");
}

-(void)setZh_title:(NSString *)title
{
    objc_setAssociatedObject(self, @"zh_title", title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadCustomNav];
}


-(BOOL)zh_showCustomNav
{
    return [objc_getAssociatedObject(self, @"zh_showCustomNav") boolValue];
}

-(void)setZh_showCustomNav:(BOOL)showCustomNav
{
    objc_setAssociatedObject(self, @"zh_showCustomNav", [NSNumber numberWithBool:showCustomNav], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self reloadCustomNav];
}


- (BOOL)zh_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZh_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(zh_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
