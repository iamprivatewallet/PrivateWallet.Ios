//
//  RootViewController.m
//  MPay
//
//  Created by MM on 2020/5/19.
//  Copyright © 2020 MM. All rights reserved.
//

#import "RootTabBarController.h"
#import "MainViewController.h"
#import "BrowseViewController.h"
#import "MineViewController.h"

@interface RootTabBarController ()<UITabBarDelegate>

@end

@implementation RootTabBarController

-(instancetype)init {
    if (self = [super init]) {
        
        MainViewController *vc1 = [[MainViewController alloc] init];
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
        [nav1.navigationBar setBarStyle:UIBarStyleBlack];
        [nav1.navigationBar setTranslucent:YES];
        
        BrowseViewController *vc2 = [[BrowseViewController alloc] init];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
        [nav2.navigationBar setBarStyle:UIBarStyleBlack];
        [nav2.navigationBar setTranslucent:YES];
        
        MineViewController *vc3 = [[MineViewController alloc] init];
        UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc3];
        [nav3.navigationBar setBarStyle:UIBarStyleBlack];
        [nav3.navigationBar setTranslucent:YES];
    
        
        [self setViewControllers:@[vc1, vc2, vc3]];
        
        [self.tabBar setHeight:kTabBarHeight];
        self.tabBar.backgroundView.backgroundColor = [UIColor navAndTabBackColor];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor mp_lineGrayColor];
        [self.tabBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.tabBar);
            make.height.mas_equalTo(1);
        }];
        for(UIView *view in self.view.subviews){
            if(![view isKindOfClass:[UITabBar class]]){
                view.frame = CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT-kTabBarHeight);
                break;
            }
        }

        int index = 0;
        NSArray *tabBarItemTitle = @[@"钱包", @"浏览", @"我"];
        for (RDVTabBarItem *item in [[self tabBar] items]) {
            if(iPhoneX) {
                item.imagePositionAdjustment = UIOffsetMake(0, -10);
                item.titlePositionAdjustment = UIOffsetMake(0, -7);
                item.badgePositionAdjustment = UIOffsetMake(0, -10);
            } else {
                [item setTitlePositionAdjustment:UIOffsetMake(0, 3)];
            }
            [item setBackgroundColor:COLOR(250, 251, 252)];
            [item setTitle:[tabBarItemTitle objectAtIndex:index]];
            //jinkh,更改间距字体大小
            item.badgeTextFont = [UIFont systemFontOfSize:9];
            //设置字体颜色
            [item setUnselectedTitleAttributes:@{
                                                 NSFontAttributeName:Set_Font(@"Light", 11),
                                                 NSForegroundColorAttributeName:[UIColor im_textColor_three],
                                                 }];
            [item setSelectedTitleAttributes:@{
                                               NSFontAttributeName:Set_Font(@"Light", 11),
                                               NSForegroundColorAttributeName:[UIColor im_blueColor],
                                               }];
            UIImage *selectImg = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%d", index]];
            
            
            [item setFinishedSelectedImage:[selectImg imageWithColor:[UIColor im_blueColor]] withFinishedUnselectedImage:[selectImg imageWithColor:[UIColor im_textColor_six]]];
            
            index++;
        }
    }
    return self;
    // Do any additional setup after loading the view.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
-(void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    [super tabBar:tabBar didSelectItemAtIndex:index];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
