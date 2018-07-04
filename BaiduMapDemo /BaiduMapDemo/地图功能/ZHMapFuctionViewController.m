//
//  ZHMapFuctionViewController.m
//  BaiduMapDemo
//
//  Created by xyj on 2018/5/18.
//  Copyright © 2018年 xyj. All rights reserved.
//

/*********
 地图展示+地图导航功能
 
 **********/


#import "ZHMapFuctionViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "BNCoreServices.h"  //导航使用
#import "BDFuctionTool.h"
//弱引用
#define WEAKSELF  __weak __typeof(self)weakSelf = self;
@interface ZHMapFuctionViewController ()<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic,strong) BDFuctionTool *tool;
@end

@implementation ZHMapFuctionViewController
-(BDFuctionTool *)tool{
    if (_tool == nil) {
        _tool = [[BDFuctionTool alloc] init];
    }
    return _tool ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
 自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate，代码如下：
 */
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self.tool addDelegates];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    [self.tool deleteDelegates];
}

#pragma mark - BMKMapViewDelegate
/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"-------点击大头针------");
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
     NSLog(@"------点击气泡-------");
    //做导航
    //1. 先要根据两个点计算出路径
    //2. 在代理方法routePlanDidFinished中开始导航
    
    [self.tool startNavActionWithStartDot:CLLocationCoordinate2DMake(22.547058, 113.936392) andEndDot:view.annotation.coordinate];
}
/**
 *地图区域即将改变时会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    NSLog(@"即将改变");
}
/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%f==已经改变==%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
}

/**
 *长按地图时会回调此接口
 *@param mapView 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    //1.设置地图的展示区域
    [self.mapView setRegion:BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.038832, 0.028404)) animated:YES];
    
    //2.POI城市内检索
    //发起检索
    WEAKSELF;
    [self.tool getPioInfoWithLocation:CLLocationCoordinate2DMake(39.915, 116.404) andKeyWord:@"小吃" Success:^(NSArray *dataArray) {
        
        //3. 在此处理正常结果
        for (BMKPoiInfo *pioinfo in dataArray) {
            NSLog(@"%@",pioinfo.name);
            //添加大头针
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = pioinfo.pt;
            annotation.title = pioinfo.name;
            annotation.subtitle = pioinfo.address;
            [weakSelf.mapView addAnnotation:annotation];
        }
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ////切换为标准地图
    [_mapView setMapType:BMKMapTypeStandard];
    //切换为卫星地图
//    [_mapView setMapType:BMKMapTypeSatellite];
//    //设置地图为空白类型
//    _mapView.mapType = BMKMapTypeNone;
    
//    //打开实时路况图层
//    [_mapView setTrafficEnabled:!_mapView.trafficEnabled];
    //关闭实时路况图层
    //    [_mapView setTrafficEnabled:NO];
    
    //打开百度城市热力图图层（百度自有数据）
//    [_mapView setBaiduHeatMapEnabled:!_mapView.baiduHeatMapEnabled];
    //    //打开百度城市热力图图层（百度自有数据）
    //    [_mapView setBaiduHeatMapEnabled:YES];
    //
    //    //关闭百度城市热力图图层（百度自有数据）
    //    [_mapView setBaiduHeatMapEnabled:NO];
}
@end
