//
//  ZHShowUserViewController.m
//  BaiduMapDemo
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHShowUserViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
@interface ZHShowUserViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locationService;
@end


@implementation ZHShowUserViewController
-(BMKLocationService *)locationService{
    if (_locationService == nil) {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rigBtn = [[UIButton alloc] init];
    [rigBtn setTitle:@"自定义精度圈" forState:UIControlStateNormal];
    rigBtn.frame = CGRectMake(0, 0, 100, 44);
    [rigBtn setBackgroundColor:[UIColor redColor]];
    [rigBtn addTarget:self action:@selector(customLocationAccuracyCircle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithCustomView:rigBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locationService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
}
//自定义精度圈
- (void)customLocationAccuracyCircle {
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.accuracyCircleStrokeColor = [UIColor redColor];
    param.accuracyCircleFillColor = [UIColor blueColor];
    [_mapView updateLocationViewWithParam:param];
}

//开始定位
- (IBAction)startLocationaction:(id)sender {
    [self.locationService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
//停止定位
- (IBAction)stopLocationAction:(id)sender {
    self.mapView.showsUserLocation = NO;
    [self.locationService stopUserLocationService];
}
//显示用户位置
- (IBAction)showUserAction:(id)sender {
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    
}
//使用罗盘
- (IBAction)userluopanAction:(id)sender {
    NSLog(@"进入罗盘态");
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    NSLog(@"heading is %@",userLocation.heading);
    [self.mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 
 
 -(void)updateLocationData:(BMKUserLocation*)userLocation;
 动态更新我的位置数据;
 该方法与_mapView.showsUserLocation = YES;结合使用
 否者不能够显示用户位置的大头针
 
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation]; NSLog(@"%@========%@",userLocation.title,userLocation.subtitle);
}

@end
