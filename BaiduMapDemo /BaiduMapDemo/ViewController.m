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

@end
