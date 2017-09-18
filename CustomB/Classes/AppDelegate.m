//
//  AppDelegate.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppDelegate.h"
#import "TLTabBarController.h"
#import "TLUser.h"
#import "TLUserLoginVC.h"
#import "TLTabBarController.h"
#import "TLNavigationController.h"
#import "AppConfig.h"
#import "NBNetwork.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "TLChatRoomVC.h"
#import "RespHandler.h"
#import "TLNetworkingConfig.h"

@interface AppDelegate ()

@property (nonatomic, strong) RespHandler *respHandler;
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    http://oss.dzt.hichengdai.com/main.html
//    http://www.cnblogs.com/wjblogs/p/5367052.html 删除
//    http://118.178.124.16:3308/main.html
    
    //1.配置应用运行环境
    [AppConfig config].runEnv = RunEnvTest;
     
    //2.新版本请求
    [NBNetworkConfig config].baseUrl = [NSString stringWithFormat:@"%@%@",[AppConfig config].addr,@"/forward-service/api"];
    
    //3.兼容以前 老版本
    [TLNetworkingConfig config].baseUrl = [NSString stringWithFormat:@"%@%@",[AppConfig config].addr,@"/forward-service/api"];
    //
    [TLNetworkingConfig config].systemCode = [AppConfig config].systemCode;
    [TLNetworkingConfig config].companyCode = [AppConfig config].systemCode;
    [TLNetworkingConfig config].kind = [AppConfig config].kind;
    
    //配置网络请求 响应处理对象
    self.respHandler = [[RespHandler alloc] init];
    [NBNetworkConfig config].respDelegate = self.respHandler;
    
  
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    //
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
    [manager.disabledDistanceHandlingClasses addObject:[TLChatRoomVC class]];
    [manager.disabledToolbarClasses addObject:[TLChatRoomVC class]];
    
    if ([TLUser user].isLogin) {
        
          self.window.rootViewController = [[TLTabBarController alloc] init];
   

    } else {
    
        TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
        self.window.rootViewController = nav;
        
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    
    return YES;
    
}

- (void)userLoginOut {

    [[TLUser user] loginOut];
    
    TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
    self.window.rootViewController = nav;

}

- (void)userLogin {

    self.window.rootViewController = [[TLTabBarController alloc] init];


}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
