//
//  HMMapViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMMapViewController.h"
#import <MAMapKit/MAMapKit.h>

#import "HMPOIAnnotationView.h"
#import "HMMAPointAnnotation.h"
#import "HMPOITableViewCell.h"
#import "HMSelectAreaView.h"

#import "HMPOIModel.h"
#import "HMCitiesModel.h"

#import "HMPOIDetailViewController.h"
#import "HMHomePageViewController.h"

static NSString *pointReuseIndentifier = @"pointReuseIndentifier";

@interface HMMapViewController ()
<
MAMapViewDelegate,
HMPOIAnnotationViewDelegate
>

@end

@implementation HMMapViewController
{
    __weak IBOutlet UIView      *_mapBackgroundView;
    
    __weak IBOutlet MAMapView   *_mapView;
    
    __weak IBOutlet UIButton    *_reflashLocationBtn;
    NSMutableArray              *_currentDataArray;
    NSInteger                   _allCount;
    
    __weak IBOutlet UILabel     *_currentPageLabel;

    __weak IBOutlet UIView      *_addressView;
    __weak IBOutlet UILabel     *_locationLabel;
    
    __weak IBOutlet UIButton    *_goBackBtn;
    __weak IBOutlet UIButton    *_goForwardBtn;
    
//    BOOL                        _canLoadMore;
    NSInteger                   _currentPage;
    
    BOOL                        _needUpdateCurrentData;
    CLLocationCoordinate2D      _userLocationCoordinate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:42];
    _currentDataArray = [[NSMutableArray alloc] initWithCapacity:42];

    _currentPage = 1;
    _needUpdateCurrentData = YES;
    _currentPageLabel.layer.cornerRadius = 2.0f;
    _goForwardBtn.enabled = NO;
    _goBackBtn.enabled = NO;
    _canGoForward = NO;
    
    _userLocationCoordinate.latitude = 0;
    _userLocationCoordinate.longitude = 0;
    [self setMapView];
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

//获取当前位置的回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        if (_userLocationCoordinate.longitude != 0 && _userLocationCoordinate.latitude != 0) {
//            return;
//        }
        WS(weakSelf);
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//        _userLocationCoordinate = userLocation.coordinate;
//        _mapView.centerCoordinate = _userLocationCoordinate;
//        [self getData];
        _mapView.showsUserLocation = NO; //YES 为打开定位，NO为关闭定位
        [HMHelper getCityWithLon:[NSString stringWithFormat:@"%f", userLocation.coordinate.longitude] lat:[NSString stringWithFormat:@"%f", userLocation.coordinate.latitude] success:^(HMAddressModel *model) {
//            [weakSelf setCurrentModel:model];
        } faile:^(NSString *errorMsg) {
            
        }];
    }
}

-(void)setCurrentModel:(HMAddressModel *)addressModel
{
//    _addressModel = addressModel;
//    _currentCity = addressModel.city;
//    _locationLabel.text = _addressModel.address;
//    [self getDistricsdata];
//    UIButton * btn = _leftBarButtonItem.customView;
//    NSString * title = _currentCity.city_short_name ? _currentCity.city_short_name : _currentCity.city_name;
//    [btn setTitle:title forState:UIControlStateNormal];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
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
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple; //大头针的颜色
        annotationView.image = [UIImage imageNamed:@"poi_normal.png"];
    
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);

        return annotationView;
    }
    return nil;
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

-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[HMPOIAnnotationView class]]) {
         ((HMPOIAnnotationView *) view).image = [UIImage imageNamed:@"poi_normal.png"];
    }
}


//缩放地图
- (void)zoomToMapPoints:(MAMapView*)mapView annotations:(NSArray*)annotations
{
    double minLat = 360.0f, maxLat = -360.0f;
    double minLon = 360.0f, maxLon = -360.0f;
    for (MKPointAnnotation *annotation in annotations) {
        if ( annotation.coordinate.latitude  < minLat ) minLat = annotation.coordinate.latitude;
        if ( annotation.coordinate.latitude  > maxLat ) maxLat = annotation.coordinate.latitude;
        if ( annotation.coordinate.longitude < minLon ) minLon = annotation.coordinate.longitude;
        if ( annotation.coordinate.longitude > maxLon ) maxLon = annotation.coordinate.longitude;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLon + maxLon) / 2.0);
    MACoordinateSpan span = MACoordinateSpanMake( (maxLat - minLat ) * 1.5, (maxLon - minLon) * 1.5);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
}


- (void)addAnnotations
{
    NSArray * annotations = _mapView.annotations;
    if (annotations.count != 0) {
        [_mapView removeAnnotations:annotations];
    }
    for (HMPOIModel * model in _currentDataArray) {
        HMMAPointAnnotation *pointAnnotation = [[HMMAPointAnnotation alloc] initWithIdentifier:pointReuseIndentifier
                                                                                          name:model.poi_name
                                                                                       address:model.poi_address
                                                                                         score:model.poi_stars
                                                                                     isShowWin:[model.poi_is_avoid_drink integerValue]
                                                                                         model:model];
        pointAnnotation.coordinate = [model getLocationCoordinate2D];
        [_mapView addAnnotation:pointAnnotation];
    }
    [self zoomToMapPoints:_mapView annotations:_mapView.annotations];
}



#pragma mark - HMPOIAnnotationViewDelegate
-(void)calloutViewClick:(HMPOICalloutView *)calloutView annotationView:(HMPOIAnnotationView *)annotationView
{
    HMPOIDetailViewController * poiDetailVC = [[HMPOIDetailViewController alloc] initWithNibName:NSStringFromClass([HMPOIDetailViewController class]) bundle:[NSBundle mainBundle]];
    poiDetailVC.poi_guid = calloutView.model.poi_guid;
    [self.navigationController pushViewController:poiDetailVC animated:YES];
}


//上一页
- (IBAction)goBackClick:(UIButton *)sender
{
    _goForwardBtn.enabled = YES;
    if (_currentPage == 1) {
        return;
    }
    else{
        _currentPage -= 1;
        [_currentDataArray removeAllObjects];
        [_currentDataArray addObjectsFromArray:_dataArray[_currentPage - 1]];
        [self addAnnotations];
        [self reflashCurrentPageLabel];
        if (_currentPage == 1) {
            _goBackBtn.enabled = NO;
        }
        else{
            _goBackBtn.enabled = YES;
        }
    }
}

//前一页
- (IBAction)goForwardClick:(UIButton *)sender
{
    if (_dataArray.count == _currentPage || _dataArray.count == 0) {
        _needUpdateCurrentData = YES;
        [(HMHomePageViewController *)self.parentViewController getData];
    }
    else{
        _currentPage += 1;
        _currentDataArray = _dataArray[_currentPage - 1];
        _goBackBtn.enabled = YES;
        [self addAnnotations];
        [self reflashCurrentPageLabel];
        if (_dataArray.count > _currentPage || self.canGoForward) {
            _goForwardBtn.enabled = YES;
        }
        else{
            _goForwardBtn.enabled = NO;
        }
    }
   
}

#pragma mark - 重新定位
- (IBAction)reflashLocationClick:(UIButton *)sender
{
//    _mapView.showsUserLocation = YES; //YES 为打开定位，NO为关闭定位
    [(HMHomePageViewController *)self.parentViewController getLocation];
}

//将当前位置移到地图中央
- (IBAction)showCurrentLocationCenter:(UIButton *)sender
{
    _mapView.centerCoordinate = _userLocationCoordinate;
}

-(void)updateLocationAddress:(HMAddressModel *)addressModel
{
    _userLocationCoordinate.longitude = [addressModel.lon doubleValue];
    _userLocationCoordinate.latitude = [addressModel.lat doubleValue];
    _locationLabel.text = addressModel.address;
}

-(void)reflashCurrentPageLabel
{
    __block NSInteger minNum = 1;
   [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       NSArray * arr = (NSArray *)obj;
       if (idx == _currentPage - 1) {
          * stop = YES;
       }
       else{
           minNum += arr.count;
       }
   }];
    _currentPageLabel.text = [NSString stringWithFormat:@"第%ld ~ %lu家", (long)minNum, minNum + _currentDataArray.count - 1];
}


-(void)setDataArray:(NSMutableArray *)dataArray needRemoveOldData:(BOOL)isNeedRemoveOldData
{
    if (isNeedRemoveOldData) {
        [_dataArray removeAllObjects];
        [_currentDataArray removeAllObjects];
        _currentPage = 1;
        _goBackBtn.enabled = NO;
    }
    [_dataArray addObject:dataArray];

    if (_needUpdateCurrentData || isNeedRemoveOldData) {
        _currentPage = _dataArray.count;
        _needUpdateCurrentData = NO;
        [_currentDataArray removeAllObjects];
        [_currentDataArray setArray:dataArray];
        [self addAnnotations];
    }
    if (_currentPage > 1) {
        _goBackBtn.enabled = YES;
    }

    [self reflashCurrentPageLabel];
}

-(void)setCanGoForward:(BOOL)canGoForward
{
    _canGoForward = canGoForward;
    if (_canGoForward) {
        _goForwardBtn.enabled  = YES;
    }
    else{
        _goForwardBtn.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
