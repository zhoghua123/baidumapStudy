//
//  BDFuctionTool.h
//  BaiduMapDemo
//
//  Created by xyj on 2018/5/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface BDFuctionTool : NSObject
/*******PIO搜索*********/
//Pio搜索
-(void)getPioInfoWithLocation: (CLLocationCoordinate2D)locationcoordinate andKeyWord:(NSString *)keyword Success: (void (^)(NSArray *dataArray))piosearch;
//统一添加代理
-(void)addDelegates;
//统一移除代理
-(void)deleteDelegates;

/*******导航功能*********/
//开始导航
-(void)startNavActionWithStartDot:(CLLocationCoordinate2D)startcoordinate andEndDot:(CLLocationCoordinate2D)endcoordinate;

/*******牛逼的分割线*********/



@end
