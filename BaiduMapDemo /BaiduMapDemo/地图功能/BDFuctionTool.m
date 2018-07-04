//
//  BDFuctionTool.m
//  BaiduMapDemo
//
//  Created by xyj on 2018/5/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "BDFuctionTool.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "BNCoreServices.h"  //导航使用

@interface BDFuctionTool()<BMKPoiSearchDelegate,BNNaviRoutePlanDelegate,BNNaviUIManagerDelegate>
@property (nonatomic,strong) BMKPoiSearch *poisearch;
@property (nonatomic,copy) void(^xpiosearch)(NSArray *);
@end


@implementation BDFuctionTool

-(BMKPoiSearch *)poisearch{
    if (_poisearch == nil) {
        _poisearch = [[BMKPoiSearch alloc] init];
    }
    return _poisearch ;
}

-(void)addDelegates{
    self.poisearch.delegate = self;
}

-(void)deleteDelegates{
    self.poisearch.delegate = nil;
}
//POI搜索
-(void)getPioInfoWithLocation: (CLLocationCoordinate2D)locationcoordinate andKeyWord:(NSString *)keyword Success:(void (^)(NSArray *))piosearch{
    
    self.xpiosearch  = piosearch;
    //POI城市内检索
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = locationcoordinate;
    option.keyword = keyword;
    BOOL flag = [self.poisearch poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.xpiosearch(poiResult.poiInfoList);
        //调用完毕设置为nil
        self.xpiosearch = nil;
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

-(void)startNavActionWithStartDot:(CLLocationCoordinate2D)startcoordinate andEndDot:(CLLocationCoordinate2D)endcoordinate{
    //0. 判断引擎是否初始化完成
    if (![self checkServicesInited]) return;
    
    //1. 设定起始结束点
    //目的地view.annotation;
    //节点数组
    NSMutableArray *nodesArray = [[NSMutableArray alloc]    initWithCapacity:2];
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = startcoordinate.longitude;
    startNode.pos.y = startcoordinate.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = endcoordinate.longitude;
    endNode.pos.y = endcoordinate.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    //2. 计算路径
    //关闭openURL,不想跳转百度地图可以设为YES
    [BNCoreServices_RoutePlan setDisableOpenUrl:YES];
    //发起路径规划
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

//判断引擎是否初始化完成
- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - BNNaviRoutePlanDelegate
//3. 开始导航
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi)
    {
        NSLog(@"退出导航");
    }
    else if (pageType == BNaviUI_Declaration)
    {
        NSLog(@"退出导航声明页面");
    }
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
