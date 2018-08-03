//
//  ViewController.m
//  BaiduMapDemo
//
//  Created by xyj on 2018/5/10.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "ZHMapFuctionViewController.h"
#import "ZHShowUserViewController.h"
#import "ZHRouteSearchController.h"
#import "MapTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)MapAction:(id)sender {
    [self.navigationController pushViewController:[ZHMapFuctionViewController new] animated:YES];
}
- (IBAction)locationFuction:(id)sender {
     [self.navigationController pushViewController:[ZHShowUserViewController new] animated:YES];
}


- (IBAction)routeSearchAction:(id)sender {
    [self.navigationController pushViewController:[ZHRouteSearchController new] animated:YES];
}

/**
 本方法是用于调用百度地图app进行导航
 官方文档地址：
 http://lbsyun.baidu.com/index.php?title=uri/api/ios
步骤：
 1.   配置一些白名单。
 info.plist添加LSApplicationQueriesSchemes，设置为Array。添加对应的白名单;
 这里以高德，百度为例，高德：iosamap百度：baidumap;
 2. 设置好以后就可以开始代码部分。
 */
- (IBAction)startBaiduMapApp:(id)sender {
    //1. 检查是否安装百度地图
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [self alert];
    }else{
        //自动检测
        [[MapTool sharedMapTool] navigationActionWithCoordinate:CLLocationCoordinate2DMake(34.72, 113.92) WithENDName:@"郑州市中牟县白沙镇刘申庄" tager:self];
        }
    
}
-(void)alert{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"下载百度地图导航" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id452186370"]];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
