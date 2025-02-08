//
//  HMSelectRestaurantViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/19.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectRestaurantViewController.h"
#import "HMSelectCityViewController.h"
#import "HMReportPOIViewController.h"

#import "HMSelectRestaurantCell.h"
#import "HMSelectRestaurantHeaderView.h"
#import "HMLocationManager.h"

#import "HMSelectRestaurantModel.h"

@interface HMSelectRestaurantViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
HMSelectCityDelegate,
HMSelectRestaurantHeaderViewDelegate
>

@end

@implementation HMSelectRestaurantViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray              * _dataArray;
    NSMutableArray              * _historyArray;
    __weak IBOutlet UIView      *_tabkeViewHeaderView;
    __weak IBOutlet UIButton    *_locationBtn;
    __weak IBOutlet UISearchBar *_searchBar;
    NSInteger                   _pageIndex;
    HMCitiesModel               * _cityModel;
    HMAddressModel              * _addressModel;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"选择餐厅", nil);
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _historyArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMSelectRestaurantCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMSelectRestaurantCell class])];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMSelectRestaurantHeaderView class]) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HMSelectRestaurantHeaderView class])];
    
    _tableView.estimatedRowHeight = 51;
    _tableView.estimatedSectionHeaderHeight = 31;
    _locationBtn.layer.cornerRadius = 5.0f;
    _locationBtn.layer.borderColor = HMBorderColor.CGColor;
    _locationBtn.layer.borderWidth = 0.5f;
    
    [_locationBtn setTitleColor:HMBlackColor forState:UIControlStateNormal];
    _locationBtn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    __weak typeof(self) _self = self;
    [_tabkeViewHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@70);
        make.width.equalTo(_self.view);
    }];
    _tableView.tableHeaderView = _tabkeViewHeaderView;
    _searchBar.delegate = self;
    [self.view layoutIfNeeded];
    [self getLocationInfo];
}

-(void)getLocationInfo
{
    WS(weakSelf);
    [[HMLocationManager sharedLocationManager] getCurrentLocationwithSuccess:^(HMAddressModel *addressModel) {
        [weakSelf reflashLocation:addressModel];
    } fail:^(NSError *error, CLLocation *location) {
        [weakSelf reflashLocation:nil];
    }];
}

-(void)getData
{
    [self.view endEditing:YES];
    
    [SVProgressHUD show];
    
    NSDictionary * params = @{
                              @"keyword" : _searchBar.text
                              };
    
    NSString * cityId;
    if (_cityModel) {
        cityId = _cityModel.city_guid;
    }
    else if (_addressModel){
        cityId = _addressModel.city.city_guid;
    }
    else{
        cityId = @"33";
    }
    [HMNetwork getRequestWithPath:HMRequestSearchKeywordPOI(cityId) params:params modelClass:[HMSelectRestaurantModel class] success:^(id object, HMNetPageInfo *pageInfo) {
        [SVProgressHUD dismiss];
        if (((NSArray *)object).count == 0) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"没有相应的数据", nil)];
        }
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:object];
        [_tableView reloadData];

    }];
}

-(void)reflashLocation:(HMAddressModel *)addressModel
{
    if (addressModel) {
        _addressModel = addressModel;
        [_locationBtn setTitle:_addressModel.city.city_name forState:UIControlStateNormal];
    }else{
        _addressModel = nil;
        [_locationBtn setTitle:NSLocalizedString(@"定位失败", nil) forState:UIControlStateNormal];
    }
}


#pragma mark - UITableViewCellDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMSelectRestaurantCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMSelectRestaurantCell class])];
    [cell configureWithModel:_dataArray[indexPath.row] isLast:(indexPath.row == _dataArray.count - 1)];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HMSelectRestaurantHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HMSelectRestaurantHeaderView class])];
    headerView.delegate = self;
    if (_dataArray.count != 0) {
        [headerView configureWithTitle:@"历史" isShowAddBtn:NO];
    }
    else{
        [headerView configureWithTitle:@"没有你要找的餐厅？" isShowAddBtn:YES];
    }
    return headerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMSelectRestaurantModel * model = _dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectRestaurantWithModel:)]) {
        [self.delegate selectRestaurantWithModel:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getData];
}

- (IBAction)selectCity:(UIButton *)sender
{
    HMSelectCityViewController * selectCityVC = [[HMSelectCityViewController alloc] initWithNibName:NSStringFromClass([HMSelectCityViewController class]) bundle:[NSBundle mainBundle]];
    selectCityVC.delegate = self;
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

#pragma mark - HMSelectRestaurantHeaderViewDelegate
-(void)addBtnClickWithHeaderView:(HMSelectRestaurantHeaderView *)headerView
{
    NSLog(@"添加");
    HMReportPOIViewController * reportPOIVC = [[HMReportPOIViewController alloc] initWithNibName:NSStringFromClass([HMReportPOIViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:reportPOIVC animated:YES];
}

#pragma mark - HMSelectCityDelegate
-(void)selectCityWithModel:(HMCitiesModel *)model
{
    _cityModel = model;
    [_locationBtn setTitle:(model.city_short_name == nil ? model.city_name : model.city_short_name) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
