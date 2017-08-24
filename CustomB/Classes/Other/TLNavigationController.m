//
//  TLNavigationController.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLNavigationController.h"
#import "TLUIHeader.h"

@interface TLNavigationController ()

@end

@implementation TLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"返回"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    navBar.tintColor = [UIColor textColor];
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor textColor]
                                     }];
//    [navBar setBackgroundImage:[[UIColor whiteColor] convertToImage ] forBarMetrics:UIBarMetricsDefault];
//    navBar.shadowImage = [[UIColor colorWithHexString:@"#dedede"] convertToImage];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        
    }
    [super pushViewController:viewController animated:YES];
    
}

@end
