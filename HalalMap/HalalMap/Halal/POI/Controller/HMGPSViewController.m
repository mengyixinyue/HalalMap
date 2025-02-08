//
//  HMGPSViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/11.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMGPSViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "HMPOIAnnotationView.h"
#import "HMMAPointAnnotation.h"

static NSString *pointReuseIndentifier = @"pointReuseIndentifier";


@interface HMGPSViewController ()
<
MAMapViewDelegate,
HMPOIAnnotationViewDelegate,
UIActionSheetDelegate
>
@end

@implementation HMGPSViewController
{
    __weak IBOutlet MAMapView *_mapView;
    HMPOIDetailModel * _model;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"位置";
    [self setMapView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addAnnotation];
}

-(void)setMapView
{
    _mapView.backgroundColor = [UIColor whiteColor];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES; //YES 为打开定位，NO为关闭定位
    //    [_mapView setUserTrackingMode: MAUserTrackingModeNone animated:YES]; //地图跟着位置移动
    //    _mapView.mapType = MAMapTypeSatellite;//显示卫星地图
    
    //    _mapView.zoomLevel
//    [MAMapServices sharedServices].apiKey = AMapKey;
    
    //地图Logo
    //    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
    
    //    指南针
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    
    //比例尺
    _mapView.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
}

//根据annationView设置view
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <HMMAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[HMMAPointAnnotation class]])
    {
        HMPOIAnnotationView*annotationView = (HMPOIAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[HMPOIAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            annotationView.clickDelegate = self;
        }
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.image = [UIImage imageNamed:@"poi_normal.png"];
        
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        annotationView.selected = YES;
        
        return annotationView;
    }
    return nil;
}

-(void)setModel:(HMPOIDetailModel *)model
{
    _model = model;
}

- (void)addAnnotation
{
    NSArray * annotations = _mapView.annotations;
    if (annotations.count != 0) {
        [_mapView removeAnnotations:annotations];
    }
    HMMAPointAnnotation *pointAnnotation = [[HMMAPointAnnotation alloc] initWithIdentifier:pointReuseIndentifier
                                                                                      name:_model.poi_name
                                                                                   address:_model.poi_address
                                                                                     score:_model.poi_stars
                                                                                 isShowWin:[_model.poi_is_avoid_drink integerValue]
                                                                                     model:_model];
    pointAnnotation.coordinate = [_model getLocationCoordinate2D];
    [_mapView addAnnotation:pointAnnotation];
    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];

//    [self zoomToMapPoints:_mapView annotations:_mapView.annotations];
    
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if (view.selected) {
        if ([view isKindOfClass:[HMPOIAnnotationView class]]) {
            ((HMPOIAnnotationView *) view).image = [UIImage imageNamed:@"poi_selected.png"];
            [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        }
    }
}

#pragma mark - HMPOIAnnotationViewDelegate
-(void)calloutViewClick:(HMPOICalloutView *)calloutView annotationView:(HMPOIAnnotationView *)annotationView
{
    WS(weakSelf);
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择导航地图" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图", @"高德地图", @"百度地图", nil];
    [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex != sheet.cancelButtonIndex) {
            switch (buttonIndex) {
                case 0:
                {
                    [weakSelf gotoAppleMap];
                }
                    break;
                case 1:
                {
                    [weakSelf gotoAMap];
                }
                    break;
                case 2:
                {
                    [weakSelf gotoBaiduMap];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

-(void)gotoAppleMap
{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[_model getLocationCoordinate2D] addressDictionary:nil]];
    toLocation.name =_model.poi_name;

    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

-(void)gotoAMap
{
    CLLocationCoordinate2D coordinate = [_model getLocationCoordinate2D];

    AMapNaviConfig * config = [[AMapNaviConfig alloc] init];
    config.destination = coordinate;//终点坐标，Annotation的坐标
    config.appScheme = HMURLScheme;//返回的Scheme，需手动设置
    config.appName = HMAppName;//应用名称，需手动设置
    config.strategy = AMapDrivingStrategyShortest;
    //若未调起高德地图App,引导用户获取最新版本的
    if(![AMapURLSearch openAMapNavigation:config])
    {
        [AMapURLSearch getLatestAMapApp];
    }
    
    /*
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",HMAppName, HMURLScheme,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
     */
}

-(void)gotoBaiduMap
{
    CLLocationCoordinate2D coordinate = [_model getLocationCoordinate2D];
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",coordinate.latitude, coordinate.longitude, _model.poi_name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
