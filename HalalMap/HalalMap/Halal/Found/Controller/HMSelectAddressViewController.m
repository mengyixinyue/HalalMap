//
//  HMSelectAddressViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/16.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectAddressViewController.h"

#import <MAMapKit/MAMapKit.h>

#import "HMMAAnnotation.h"
#import "HMMAPointAnnotation.h"
#import "HMPOIAnnotationView.h"

static NSString *pointReuseIndentifier = @"pointReuseIndentifier";

@interface HMSelectAddressViewController ()
<
MAMapViewDelegate
>
@end

@implementation HMSelectAddressViewController
{
    __weak IBOutlet MAMapView *_mapView;
    CLLocationCoordinate2D _currentLocation;
    HMAddressModel * _model;
    __weak IBOutlet UIImageView *_currentImageView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addBarButtonItemWithImageName:nil
                                  title:@"确定"
                                 action:@selector(sureBtnClick)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:[UIColor whiteColor]
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];
    [self setMapView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)setMapView
{
    self.navigationItem.title = NSLocalizedString(@"选择餐厅位置", nil);
    _mapView.backgroundColor = [UIColor whiteColor];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES; //YES 为打开定位，NO为关闭定位
//    [MAMapServices sharedServices].apiKey = AMapKey;
    
    //地图Logo
    //    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
    
    //    指南针
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    
    //比例尺
    _mapView.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
    _mapView.showsUserLocation = YES; //YES 为打开定位，NO为关闭定位
}

//获取当前位置的回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _currentLocation = _mapView.centerCoordinate;
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _mapView.showsUserLocation = NO; //YES 为打开定位，NO为关闭定位
        _currentLocation = userLocation.coordinate;
        [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        [self getLocation];
        
    }
    else{
        [HMHelper getCityWithLon:[NSString stringWithFormat:@"%f", _currentLocation.longitude] lat:[NSString stringWithFormat:@"%f", _currentLocation.latitude] success:^(HMAddressModel *model) {
            _model = model;
        } faile:^(NSString *errorMsg) {
            
        }];
    }
}


- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    _currentLocation =[_mapView convertPoint:_currentImageView.origin toCoordinateFromView:_mapView];
}

-(void)getLocation
{
    [HMHelper getCityWithLon:[NSString stringWithFormat:@"%f", _currentLocation.longitude] lat:[NSString stringWithFormat:@"%f", _currentLocation.latitude] success:^(HMAddressModel *model) {
        _model = model;
    } faile:^(NSString *errorMsg) {
        
    }];
}


-(void)sureBtnClick
{
    WS(weakSelf);
    [HMHelper getCityWithLon:[NSString stringWithFormat:@"%f", _currentLocation.longitude] lat:[NSString stringWithFormat:@"%f", _currentLocation.latitude] success:^(HMAddressModel *model) {
        _model = model;
        [weakSelf popVC];
    } faile:^(NSString *errorMsg) {
        
    }];
}

-(void)popVC
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAddressWithAddressModel:)]) {
        [self.delegate selectAddressWithAddressModel:_model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
