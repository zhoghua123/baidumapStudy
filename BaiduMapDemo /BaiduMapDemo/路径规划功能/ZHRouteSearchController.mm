//
//  ZHRouteSearchController.m
//  BaiduMapDemo
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHRouteSearchController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

@interface ZHRouteSearchController ()<BMKMapViewDelegate,BMKRouteSearchDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic,strong) BMKRouteSearch *routesearch;//用于路径搜索服务
@end

@implementation ZHRouteSearchController

- (BMKRouteSearch *)routesearch{
    if (!_routesearch) {
        _routesearch = [[BMKRouteSearch alloc] init];;
    }
    return _routesearch ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置地图的展示区域
    [self.mapView setRegion:BMKCoordinateRegionMake(CLLocationCoordinate2DMake(34.776828765869141, 113.73679351806641), BMKCoordinateSpanMake(0.198832, 0.178404)) animated:YES];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    self.routesearch.delegate = nil; // 不用时，置nil
}

#pragma mark - Actions
//公交（跨城）
- (IBAction)takeLongBusAction:(id)sender {
    NSLog(@"点击了跨城公交");
    NSArray *array = [self obtainStartAndEnd];
    //根据起点终点初始化路线对象
    BMKMassTransitRoutePlanOption *option = [[BMKMassTransitRoutePlanOption alloc] init];
    option.from = array.firstObject;
    option.to = array.lastObject;
    
    BOOL success =  [self.routesearch massTransitSearch:option];
    if(success)
    {
        NSLog(@"跨城公交检索发送成功");
    }
    else
    {
        NSLog(@"跨城公交检索发送失败");
    }
}
//公交
- (IBAction)takeBusAction:(id)sender {
    NSLog(@"点击了公交");
    NSArray *array = [self obtainStartAndEnd];
    //根据起点终点初始化路线对象
    BMKTransitRoutePlanOption *option = [[BMKTransitRoutePlanOption alloc] init];
    option.city = @"郑州市"; //在那个城市内进行检索
    option.from = array.firstObject;
    option.to = array.lastObject;
    
   BOOL success =  [self.routesearch transitSearch:option];
    if(success)
    {
        NSLog(@"公交检索发送成功");
    }
    else
    {
        NSLog(@"公交检索发送失败");
    }
}
//驾车
- (IBAction)takeCarAction:(id)sender {
    NSLog(@"点击了驾车");
    NSArray *array = [self obtainStartAndEnd];
    //根据起点终点初始化路线对象
    BMKDrivingRoutePlanOption *option = [[BMKDrivingRoutePlanOption alloc] init];
    option.from = array.firstObject;
    option.to = array.lastObject;
    option.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    BOOL success =  [self.routesearch drivingSearch:option];
    if(success)
    {
        NSLog(@"驾车检索发送成功");
    }
    else
    {
        NSLog(@"驾车检索发送失败");
    }
}
//步行
- (IBAction)warlkAction:(id)sender {
    NSArray *array = [self obtainStartAndEnd];
    //根据起点终点初始化路线对象
    BMKWalkingRoutePlanOption *option = [[BMKWalkingRoutePlanOption alloc] init];
    option.from = array.firstObject;
    option.to = array.lastObject;
    BOOL success =  [self.routesearch walkingSearch:option];
    if(success)
    {
        NSLog(@"步行检索发送成功");
    }
    else
    {
        NSLog(@"步行检索发送失败");
    }
}
//骑行
- (IBAction)takeBikeAction:(id)sender {
    NSLog(@"点击了骑行");
    NSArray *array = [self obtainStartAndEnd];
    //根据起点终点初始化路线对象
    BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc] init];
    option.from = array.firstObject;
    option.to = array.lastObject;
    BOOL success =  [self.routesearch ridingSearch:option];
    if(success)
    {
        NSLog(@"步行检索发送成功");
    }
    else
    {
        NSLog(@"步行检索发送失败");
    }
}

#pragma mark - defineAction

-(NSArray *)obtainStartAndEnd{
    //初始化检索的起点：
    BMKPlanNode *from = [[BMKPlanNode alloc] init];
    from.cityName = @"郑州市";
    from.name = @"郑州国际会展中心展览中心A区";
    from.pt = CLLocationCoordinate2DMake(34.776828765869141, 113.73679351806641);
    //初始化检索的终点：
    BMKPlanNode *to = [[BMKPlanNode alloc] init];
    to.cityName = @"郑州市";
    to.name = @"郑州高新区八一中学-东门";
    to.pt = CLLocationCoordinate2DMake(34.825347900390618, 113.59104156494141);
    
    return @[from,to];
}

#pragma mark - BMKMapViewDelegate
/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - BMKRouteSearchDelegate
/*********
 路线搜索delegate，用于获取路线搜索结果
 **********/
/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"共有%zd调路线",result.routes.count);
    }else{
        NSLog(@"搜索有问题，问题号码%d",(int)error);
    }
}

/**
 *返回公共交通路线检索结果（new）
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKMassTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetMassTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKMassTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"共有%zd调路线",result.routes.count);
    }else{
       NSLog(@"搜索有问题，问题号码%d",(int)error);
        
    }
}

/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    //1.清楚已经添加的大头针
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    //2.清楚已经添加的路线图
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"共有%zd调路线",result.routes.count);
        //3. 拿到第一条路线
        BMKDrivingRouteLine *plan=  result.routes.firstObject;
        NSLog(@"该路线有%d米",plan.distance);
       //4. 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            NSLog(@"%@   %@    %@", transitStep.entraceInstruction, transitStep.exitInstruction, transitStep.instruction);
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
//        // 添加途经点
//        if (plan.wayPoints) {
//            for (BMKPlanNode* tempNode in plan.wayPoints) {
//                RouteAnnotation* item = [[RouteAnnotation alloc]init];
//                item = [[RouteAnnotation alloc]init];
//                item.coordinate = tempNode.pt;
//                item.type = 5;
//                item.title = tempNode.name;
//                [_mapView addAnnotation:item];
//            }
//        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }else{
        NSLog(@"搜索有问题，问题号码%d",(int)error);
    }
}

/**
 *返回步行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKWalkingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"共有%zd调路线",result.routes.count);
    }else{
        NSLog(@"搜索有问题，问题号码%d",(int)error);
        
    }
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch*)searcher result:(BMKRidingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"共有%zd调路线",result.routes.count);
    }else{
        NSLog(@"搜索有问题，问题号码%d",(int)error);
        
    }
}


@end
