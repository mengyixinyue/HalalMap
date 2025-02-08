//
//  HMHomePageViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMHomePageViewController.h"
#import "HMMapViewController.h"
#import "HMPOIListViewController.h"
#import "HMSelectCityViewController.h"
#import "HMReportPOIViewController.h"

#import "HMLocationManager.h"

#import "HMSelectAreaView.h"

#import "HMDistrictModel.h"
#import "HMCitiesModel.h"
#import "HMPOIModel.h"

#define PageSize    (10)
#define HMFilterHeight  (50)

@interface HMHomePageViewController ()
<
UISearchBarDelegate,
HMSelectCityDelegate
>

@end

@implementation HMHomePageViewController
{
    UISearchBar                 * _searchBar;
    
    HMMapViewController         * _mapVC;
    HMPOIListViewController     * _poiListVC;
    
    NSMutableArray              * _dataArray;
    NSMutableArray              * _currentDataArray;

    UIViewController            * _currentViewController;
    UIButton                    * _filterBtn;//筛选
    UIBarButtonItem             * _leftBarButtonItem;//选择地区
    
    NSMutableArray              *_districtsArray;//选择的城市的区县
    HMSelectAreaView            *_selectAreaView;//筛选地区条件的view
    HMCitiesModel               * _currentCity;//当前选择的城市
    
    NSString                    * _currentUserLoctionCityId;
    
    NSInteger                   _pageId;//第几页
    NSInteger                   _currentPage;//当前页
    
    CLLocationCoordinate2D      _userLocationCoordinate;//用户经纬度
    NSInteger                   _currentDistrictIndex;//当前区域下标
    NSInteger                   _currentBusAreaIndex;//当前商圈下标
    
    BOOL                        _canLoadMore;
    
    UIButton                    * _switchMapWithListBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    _currentCity = [[HMCitiesModel alloc] init];
    
    _dataArray = [[NSMutableArray alloc] init];
    _districtsArray = [[NSMutableArray alloc] initWithCapacity:42];
    _currentDataArray = [[NSMutableArray alloc] initWithCapacity:42];

    _pageId = 1;
    _currentPage = 1;
    _currentDistrictIndex = 0;
    _currentBusAreaIndex = 0;
    
    _canLoadMore = YES;

//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    _searchBar.delegate = self;
//    _searchBar.placeholder = NSLocalizedString(@"餐厅名字/地址", nil);
//    [self.view addSubview:_searchBar];
    
    _mapVC = [HMHelper xibWithViewControllerClass:[HMMapViewController class]];
//    _mapVC.view.frame = CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, self.view.height - _searchBar.bottom);
    _mapVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height);

    _poiListVC = [HMHelper xibWithViewControllerClass:[HMPOIListViewController class]];
//    _poiListVC.view.frame = CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, self.view.height - _searchBar.bottom);
    _poiListVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height);

    
    [self addChildViewController:_mapVC];
    [self addChildViewController:_poiListVC];
    
    
    _switchMapWithListBtn = [UIButton buttonWithFrame:CGRectMake(self.view.width - 41, SCREEN_HEIGHT_NOBAR - 100, 41, 41) image:[UIImage imageNamed:@"switch_to_list"] target:self action:@selector(switchMapWithListBtnClick:)];
    [self.view addSubview:_switchMapWithListBtn];
    [_switchMapWithListBtn setImage:[UIImage imageNamed:@"switch_to_map"] forState:UIControlStateSelected];
    
    
    NSInteger homePageShowTypeKey = [[USERDEFAULT objectForKey:HMHomePageShowTypeKey] integerValue];
    switch (homePageShowTypeKey) {
        case HMHomePageShowTypeMap:
        {
            [self.view addSubview:_mapVC.view];
            [_mapVC didMoveToParentViewController:self];
            _currentViewController = _mapVC;
        }
            break;
        case HMHomePageShowTypeList:
        {
            [self.view addSubview:_poiListVC.view];
            [_poiListVC didMoveToParentViewController:self];
            _currentViewController = _poiListVC;
            _switchMapWithListBtn.selected = YES;
        }
            break;
        default:
        {
            [self.view addSubview:_mapVC.view];
            [_mapVC didMoveToParentViewController:self];
            _currentViewController = _mapVC;
        }
            break;
    }
    
    [self setNavigationItem];
    
    _selectAreaView = [HMHelper xibWithClass:[HMSelectAreaView class]];
    [self.view bringSubviewToFront:_switchMapWithListBtn];
    [self getLocation];
}



-(void)setNavigationItem
{
    _leftBarButtonItem = [self addBarButtonItemWithImageName:nil
                                                       title:@""
                                                      action:@selector(selectCity:)
                                           barButtonItemType:HMBarButtonTypeLeft
                                                  titleColor:[UIColor whiteColor]
                                       highlightedTitleColor:nil
                                                   titleFont:[HMFontHelper fontOfSize:18.0f]];
    [self addBarButtonItemWithImageName:@"poi_add.png"
                                  title:nil
                                 action:@selector(addPOIDetail:)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:nil
                  highlightedTitleColor:nil
                              titleFont:nil];
    
    UIButton * btn = _leftBarButtonItem.customView;
    btn.width = 100;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _filterBtn = [UIButton buttonWithFrame:view.bounds
                                     title:@"全部地区"
                                     image:[UIImage imageNamed:@"area_down.png"]
                                titleColor:[UIColor whiteColor]
                                    target:self
                                    action:@selector(filterBtnClick:)];
    _filterBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    [_filterBtn setImage:[UIImage imageNamed:@"area_up.png"] forState:UIControlStateSelected];
    _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_filterBtn.imageView.size.width, 0, _filterBtn.imageView.size.width);
    _filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _filterBtn.titleLabel.bounds.size.width + 4, 0,-_filterBtn.titleLabel.bounds.size.width - 4);
    [view addSubview:_filterBtn];
    self.navigationItem.titleView = view;
}


#pragma mark -- UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar endEditing:YES];
    _pageId = 1;
    [self getData];
}


#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES];
    if (isIOS7) {
        UIView *view = _searchBar.subviews[0];
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                UIButton *cancelBtn = (UIButton *)subView;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cancelBtn setTitleColor:HMMainColor forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[HMMainColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            }
            if ([subView isKindOfClass: NSClassFromString(@"UISearchBarBackground")])
            {
            }
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)subView;
                tf.returnKeyType = UIReturnKeySearch;
                tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
                tf.layer.borderWidth = 0.5;
            }
        }
    }
    
}


#pragma mark - 选择城市
-(void)selectCity:(UIBarButtonItem *)bbi
{
    HMSelectCityViewController * selectCityVC = [HMHelper xibWithViewControllerClass:[HMSelectCityViewController class]];
    selectCityVC.delegate = self;
    selectCityVC.isNeedBackItemWhenPresentViewController = YES;
    HMBaseNavigationController * baseNav = [[HMBaseNavigationController alloc] initWithRootViewController:selectCityVC];
    [self presentViewController:baseNav animated:YES completion:^{
        
    }];
}

#pragma mark - HMSelectCityDelegate
-(void)selectCityWithModel:(HMCitiesModel *)model
{
    [self updateCurrentCityModel:model];
    [HMHelper saveSelectedCity:model];
    
    [self getDistricsdataFinish:^{
        
    }];
    _currentCity = model;
    UIButton * btn = _leftBarButtonItem.customView;
    NSString * title = model.city_short_name ? model.city_short_name : model.city_name;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
}


#pragma mark - 添加
-(void)addPOIDetail:(UIBarButtonItem *)bbi
{
    HMReportPOIViewController * reportPODVC = [HMHelper xibWithViewControllerClass:[HMReportPOIViewController class]];
    [self.navigationController pushViewController:reportPODVC animated:YES];
}


#pragma mark - 筛选
-(void)filterBtnClick:(UIButton *)btn
{
    _filterBtn.selected = !btn.selected;
    if (!_filterBtn.selected) {
        [_selectAreaView hide];
    }else{
        [_selectAreaView showSelectAreaInView:self.view
                                     WithData:_districtsArray
                        selectedDistrictIndex:_currentDistrictIndex
                          selectedBuAreaIndex:_currentBusAreaIndex
                                  finishBolck:^(NSInteger selectedDistrictIndex, NSInteger selectedBuAreaIndex) {
                                      _currentBusAreaIndex = selectedBuAreaIndex;
                                      _currentDistrictIndex = selectedDistrictIndex;
                                      HMDistrictModel * model = _districtsArray[selectedDistrictIndex];
                                      HMBusinessAreaModel * businessModel = model.businessAreas[selectedBuAreaIndex];
                                      
                                      [self updateFilterBtnTitileWithBusinessAreaModel:businessModel];
                                      
                                      _pageId = 1;
                                      _canLoadMore = YES;
                                      [self getData];
                                      _filterBtn.selected = !_filterBtn.selected;
                                  }
                                    failBlock:^{
                                        _filterBtn.selected = !_filterBtn.selected;
                                        
                                    }];
    }
}

-(void)updateFilterBtnTitileWithBusinessAreaModel:(HMBusinessAreaModel *)businessModel
{
    if (!businessModel) {
        HMDistrictModel * model = _districtsArray[_currentDistrictIndex];
        businessModel = model.businessAreas[_currentBusAreaIndex];
    }
    if (_userLocationCoordinate.latitude != 0 && _userLocationCoordinate.longitude != 0 && _currentDistrictIndex == 0) {
        if (_currentDistrictIndex == 0) {
            NSString * title = [NSString stringWithFormat:@"附近%@", businessModel.businessArea_name];
            [_filterBtn setTitle:title forState:UIControlStateNormal];
            [_filterBtn setTitle:title forState:UIControlStateSelected];
        }
    }
    else{
        [_filterBtn setTitle:businessModel.businessArea_name forState:UIControlStateNormal];
        [_filterBtn setTitle:businessModel.businessArea_name forState:UIControlStateSelected];
    }
    
    CGSize size = [_filterBtn.titleLabel.text sizeAutoFitIOS7WithFont:_filterBtn.titleLabel.font];
    _filterBtn.width = size.width + 20;
    _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_filterBtn.imageView.size.width, 0, _filterBtn.imageView.size.width);
    _filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _filterBtn.titleLabel.bounds.size.width + 4, 0,-_filterBtn.titleLabel.bounds.size.width - 4);
}


-(void)switchMapWithListBtnClick:(UIButton *)btn
{
    _switchMapWithListBtn.selected = !btn.selected;
    if (_switchMapWithListBtn.selected) {
        _currentViewController = _poiListVC;
        [self swithMapAndListVCWithOldVC:_mapVC newVC:_poiListVC];
    }
    else{
        _currentViewController = _mapVC;
        [self swithMapAndListVCWithOldVC:_poiListVC newVC:_mapVC];
    }
}

-(void)swithMapAndListVCWithOldVC:(UIViewController *)oldVC newVC:(UIViewController *)newVC
{
    [self transitionFromViewController:oldVC toViewController:newVC duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view bringSubviewToFront:_switchMapWithListBtn];
    } completion:^(BOOL finished) {
    }];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    _mapVC.view.frame = CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, self.view.height - _searchBar.bottom);
//    _poiListVC.view.frame = CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, self.view.height - _searchBar.bottom);
    _mapVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height);
    _poiListVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height);
}

#pragma mark - 数据请求
-(void)UpdateCurrentCityModelAndData:(HMCitiesModel *)cityModel
{
    WS(weakSelf);
    [self getDistricsdataFinish:^{
        [weakSelf updateFilterBtnTitileWithBusinessAreaModel:nil];
        [weakSelf getData];
    }];
    UIButton * btn = _leftBarButtonItem.customView;
    NSString * title = cityModel.city_short_name ? cityModel.city_short_name : cityModel.city_name;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
}

-(void)getData
{
    if (!_canLoadMore) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"没有更多了", nil)];
        return;
    }
    if (_userLocationCoordinate.latitude != 0 && _userLocationCoordinate.longitude != 0 && _currentDistrictIndex == 0) {
        [self getAroundData];
    }
    else{
        [self getDistrictPOIData];
    }
}



-(void)getLocation
{
    WS(weakSelf);
    [SVProgressHUD show];
    [[HMLocationManager sharedLocationManager] getCurrentLocationwithSuccess:^(HMAddressModel *addressModel) {
        _canLoadMore = YES;
        _userLocationCoordinate.longitude = [addressModel.lon floatValue];
        _userLocationCoordinate.latitude = [addressModel.lat floatValue];
        [weakSelf setCurrentWithCityModel:addressModel.city];
        _currentUserLoctionCityId = [NSString stringWithString:addressModel.city.city_guid];
        [_mapVC updateLocationAddress:addressModel];
    } fail:^(NSError *error, CLLocation *location) {
        [weakSelf setCurrentWithCityModel:nil];
    }];
}

-(void)setCurrentWithCityModel:(HMCitiesModel *)model
{
    HMCitiesModel * citiesModel = [HMHelper getSelectedCity];
    if (model) {
        if (citiesModel) {
            if ([citiesModel.city_guid isEqualToString:model.city_guid]) {
                [self updateCurrentCityModel:model];
                [self UpdateCurrentCityModelAndData:citiesModel];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"系统定位城市与您当前选择的城市不同，是否切换为定位城市？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView showWithCompletionHandler:^(NSInteger buttonIndex) {//选择新的
                    if (alertView.cancelButtonIndex != buttonIndex) {
                        [self updateCurrentCityModel:model];
                        [HMHelper saveSelectedCity:_currentCity];
                    }
                    else{//选择原来的
                        [self updateCurrentCityModel:citiesModel];
                    }
                    [self UpdateCurrentCityModelAndData:_currentCity];
                }];
            }
        }
        else{
            [self updateCurrentCityModel:model];
            [HMHelper saveSelectedCity:_currentCity];
            [self UpdateCurrentCityModelAndData:_currentCity];
        }
    }
    else{
        if (citiesModel) {
            [self updateCurrentCityModel:model];
            [self UpdateCurrentCityModelAndData:citiesModel];
        }
        else{
            HMCitiesModel * city = [[HMCitiesModel alloc] init];
            city.city_guid = @"33";
            city.city_name = @"北京";
            [self updateCurrentCityModel:city];
            [HMHelper saveSelectedCity:city];
            [self UpdateCurrentCityModelAndData:city];
        }
    }
}

//更新当前city model
-(void)updateCurrentCityModel:(HMCitiesModel *)model
{
    _currentCity.city_guid = model.city_guid;
    _currentCity.city_name = model.city_name;
}


// 获取周边POI
-(void)getAroundData
{
    if (_userLocationCoordinate.latitude != 0 && _userLocationCoordinate.longitude != 0) {
        NSString *radius;
        if (_currentBusAreaIndex == 0) {
            radius = @"500";
        }
        else if (_currentBusAreaIndex == 1){
            radius = @"1000";
        }
        else{
            radius = @"2000";
        }
        
        NSDictionary * params = @{
                                  @"lon" : [NSString stringWithFormat:@"%f", _userLocationCoordinate.longitude],
                                  @"lat" : [NSString stringWithFormat:@"%f", _userLocationCoordinate.latitude],
                                  @"radius" : radius,
                                  @"keyword" : _searchBar.text.length == 0 ? @"" : _searchBar.text,
                                  @"page" : [NSString stringWithFormat:@"%ld", (long)_pageId],
                                  @"limit" : [NSString stringWithFormat:@"%ld", (long)PageSize]
                                  };
        _currentPage = _pageId;
        [HMNetwork getRequestWithPath:HMRequestSearchAroundPOI
                               params:params
                           modelClass:[HMPOIModel class]
                              success:^(id object, HMNetPageInfo *pageInfo) {
                                  [_poiListVC endLoadMore];
                                  [SVProgressHUD dismiss];
                                  if (_pageId == 1) {
                                      [_dataArray removeAllObjects];
                                      [_mapVC.dataArray removeAllObjects];
                                      [_poiListVC.dataArray removeAllObjects];
                                  }
                              
                                  [_currentDataArray removeAllObjects];
                                  [_currentDataArray addObjectsFromArray:object];
                                  [_dataArray addObjectsFromArray:object];
                                  if (_pageId == 1) {
                                      [_mapVC setDataArray:object needRemoveOldData:YES];
                                  }
                                  else{
                                      [_mapVC setDataArray:object needRemoveOldData:NO];
                                  }
                                  _poiListVC.dataArray = _dataArray;
                                  if (pageInfo.hadMore) {
                                      _pageId += 1;
                                      _canLoadMore = YES;
                                      _mapVC.canGoForward = YES;
                                      _poiListVC.canLoadMore = YES;
                                  }
                                  else{
                                      _mapVC.canGoForward = NO;
                                      _canLoadMore = NO;
                                      _poiListVC.canLoadMore = NO;
                                  }
                              } failure:^(HMNetResponse *response, NSString *errorMsg) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [SVProgressHUD showErrorWithStatus:errorMsg];
                                  });
                                  [_poiListVC endLoadMore];
                              }];
    }
}

//根据选择的区县商圈筛选POI
-(void)getDistrictPOIData
{
    HMDistrictModel * disModel = _districtsArray[_currentDistrictIndex];
    HMBusinessAreaModel * busModel = disModel.businessAreas[_currentBusAreaIndex];
    NSDictionary * paraps = @{
                              @"ad_guid" : disModel.district_guid,
                              @"b_area_guid" : busModel.businessArea_guid,
                              @"keyword" : _searchBar.text.length == 0 ? @"" : _searchBar.text,
                              @"page" : [NSString stringWithFormat:@"%ld", (long)_pageId],
                              @"limit" : [NSString stringWithFormat:@"%ld", (long)PageSize]
                              };
    
    [HMNetwork getRequestWithPath:HMRequestSearchDistrictPOI(_currentCity.city_guid)
                           params:paraps
                       modelClass:[HMPOIModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              [_poiListVC endLoadMore];
                              [SVProgressHUD dismiss];
                              if (_pageId == 1) {
                                  [_dataArray removeAllObjects];
                                  [_mapVC.dataArray removeAllObjects];
                                  [_poiListVC.dataArray removeAllObjects];
                              }
                              [_currentDataArray removeAllObjects];
                              [_currentDataArray addObjectsFromArray:object];
                              [_dataArray addObjectsFromArray:object];

                              if (_pageId == 1) {
                                  [_mapVC setDataArray:object needRemoveOldData:YES];
                              }
                              else{
                                  [_mapVC setDataArray:object needRemoveOldData:NO];
                              }
                              _poiListVC.dataArray = _dataArray;
                              if (pageInfo.hadMore) {
                                  _pageId += 1;
                                  _canLoadMore = YES;
                                  _mapVC.canGoForward = YES;
                                  _poiListVC.canLoadMore = YES;
                              }
                              else{
                                  _mapVC.canGoForward = NO;
                                  _canLoadMore = NO;
                                  _poiListVC.canLoadMore = NO;
                              }

                          } failure:^(HMNetResponse *response, NSString *errorMsg) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [SVProgressHUD showErrorWithStatus:errorMsg];
                              });
                              [_poiListVC endLoadMore];
                          }];
}



//获取区县商圈数据
-(void)getDistricsdataFinish:(void(^)(void))finish
{
    [HMNetwork getRequestWithPath:HMRequestDistrictsAndBusinessAreas(@"33")
                           params:nil
                       modelClass:[HMDistrictModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              [_districtsArray removeAllObjects];
                              if ([object isKindOfClass:[NSArray class]] && ((NSArray *) object).count != 0) {
                                  [_districtsArray addObjectsFromArray:object];
                                  
                                  if (_userLocationCoordinate.latitude != 0 && _userLocationCoordinate.longitude != 0 && [_currentUserLoctionCityId isEqualToString:_currentCity.city_guid]) {
                                      HMDistrictModel * disModel = [[HMDistrictModel alloc] init];
                                      disModel.district_name = @"附近";
                                      HMBusinessAreaModel * model1 = [[HMBusinessAreaModel alloc] init];
                                      model1.businessArea_name = @"500米";
                                      
                                      HMBusinessAreaModel * model2 = [[HMBusinessAreaModel alloc] init];
                                      model2.businessArea_name = @"1000米";
                                      HMBusinessAreaModel * model3 = [[HMBusinessAreaModel alloc] init];
                                      model3.businessArea_name = @"2000米";
                                      disModel.businessAreas = [NSMutableArray arrayWithObjects:model1, model2, model3, nil];
                                      [_districtsArray insertObject:disModel atIndex:0];
                                      _currentBusAreaIndex = 2;
                                      _currentDistrictIndex = 0;
                                  }
                                  if (finish) {
                                      finish();
                                  }
                              }
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
