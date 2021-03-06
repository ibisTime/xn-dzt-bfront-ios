//
//  ZHTabBarController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLTabBarController.h"
#import "TLNavigationController.h"
#import "UIColor+theme.h"

@interface TLTabBarController ()<UITabBarControllerDelegate>

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

//    NSArray *titles = @[@"优店",@"尖货",@"购物中心",@"我的"];
    NSArray *VCNames = @[@"TLHomeVC",@"TLOrderVC",@"TLCustomerVC",@"TLMineVC"];
    
    NSArray *imageNames = @[@"首页00",@"订单00",@"客户00",@"我的00"];
    NSArray *selectedImageNames = @[@"首页01",@"订单01",@"客户01",@"我的01"];
    
    
    for (int i = 0; i < imageNames.count; i++) {
        
        [self addChildVCWithTitle:nil
                       controller:VCNames[i]
                      normalImage:imageNames[i]
                    selectedImage:selectedImageNames[i]];
    }
    
    self.selectedIndex = 0;
    
}

- (void)usrLoginOut {

    self.tabBar.items[3].badgeValue =  nil;
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


- (UIImage *)changImageColorWithImage:(UIImage *)image  color:(UIColor *)targetColor blendModel:(CGBlendMode)mode
{
    //获取画布
    UIGraphicsBeginImageContext(image.size);
    //画笔沾取颜色
    [targetColor setFill];
    
    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(drawRect);
    [image drawInRect:drawRect blendMode:mode alpha:1];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)addChildVCWithTitle:(NSString *)title
                 controller:(NSString *)controllerName
                normalImage:(NSString *)normalImageName
              selectedImage:(NSString *)selectedImageName
{
    Class vcClass = NSClassFromString(controllerName);
    UIViewController *vc = [[vcClass alloc] init];
    
    //获得原始图片
    UIImage *normalImage = [self getOrgImage:[UIImage imageNamed:normalImageName]];
    UIImage *selectedImage = [self getOrgImage:[UIImage imageNamed:selectedImageName]];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:normalImage
                                                     selectedImage:selectedImage];
    tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 100);
    
    //title颜色
//    [tabBarItem setTitleTextAttributes:@{
//                                         NSForegroundColorAttributeName : [UIColor zh_themeColor]
//                                         } forState:UIControlStateSelected];
//    [tabBarItem setTitleTextAttributes:@{
//                                         NSForegroundColorAttributeName : [UIColor zh_textColor]
//                                         } forState:UIControlStateNormal];
    vc.tabBarItem =tabBarItem;
    TLNavigationController *navigationController = [[TLNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navigationController];
    
}

- (UIImage *)getOrgImage:(UIImage *)image
{
//    return image;
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
