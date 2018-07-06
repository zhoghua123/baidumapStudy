//
//  AppDelegate.m
//  BaiduMapDemo
//
//  Created by xyj on 2018/5/10.
//  Copyright © 2018年 xyj. All rights reserved.


#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "AppDelegate.h"
#import "BNCoreServices.h"
@interface AppDelegate ()<BMKGeneralDelegate>
@property (nonatomic,strong) BMKMapManager *mapManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*******地图SDK相关*********/
    //初始化SDK
    self.mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:@"4MsBzVblOS9Q0vpDmkvoTe0ucE9TrEtc"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    /*******导航SDK相关*********/
    // 必须设置APPID，否则会静音
    /*
     注意：
     1. 在http://yuyin.baidu.com/app创建自己的应用，注册语音合成功能,拿到App ID
     2. 新增导航appid设置接口，需要在初始化导航前，需要调用APPID的设置接口，否则会没有声音。(注意: 这里的appid是在第一步创建应用后得到的!!!!!!!!!)
     // 必须设置APPID，否则会静音
     [BNCoreServices_Instance setTTSAppId:@"9617266"];
     */
    //初始化导航SDK
    [BNCoreServices_Instance initServices:@"4MsBzVblOS9Q0vpDmkvoTe0ucE9TrEtc"];
    //TTS在线授权
    [BNCoreServices_Instance setTTSAppId:@"11269718"];
    
    //设置是否自动退出导航
    [BNCoreServices_Instance setAutoExitNavi:NO];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    
    return YES;
}

#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
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
