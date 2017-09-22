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
//    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"返回"];
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    
    
//    [self.navigationItem.backBarButtonItem setTitle:@""];
    //
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    
//    UIImage *backButtonImage = [[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationBar.backIndicatorImage = backButtonImage;
//    self.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    //
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    navBar.tintColor = [UIColor textColor];
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [UIColor textColor]
                                     }];
//  [navBar setBackgroundImage:[[UIColor whiteColor] convertToImage ] forBarMetrics:UIBarMetricsDefault];
//  navBar.shadowImage = [[UIColor colorWithHexString:@"#dedede"] convertToImage];
    
    //
//    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
//
//            UIView *_navigationBarContentView = obj;
//            
//            [_navigationBarContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                if ([obj isKindOfClass:NSClassFromString(@"_UIButtonBarButton")]) {
//                    UIView *_buttonBarButton = obj;
//                    
//                    [_buttonBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        
//                        if ([obj isKindOfClass:NSClassFromString(@"_UIBackButtonContainerView")]) {
//                            UIView *_backButtonContainerView = obj;
//                            [_backButtonContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                
//                                if ([obj isKindOfClass:NSClassFromString(@"_UIModernBarButton")]) {
//                                    UIView *_modernBarButton = obj;
//                                    [_modernBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                        if ([obj isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
//                                            obj.hidden = YES;
//                                            *stop = YES;
//                                        }
//                                    }];
//                                }
//                                
//                            }];
//                            
//                        }
//                        
//                    }];
//                    *stop = YES;
//                }
//            }];
//
//            *stop = YES;
//        }
//    }];
    //
    

 

}

- (void)popToLast {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        
    }
    [super pushViewController:viewController animated:YES];
    
}

@end
