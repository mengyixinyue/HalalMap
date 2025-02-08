//
//  HMMyCollectPOIViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/9.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMMyCollectPOIViewController.h"
#import "HMPOIDetailViewController.h"

#import "HMPOITableViewCell.h"

#import "HMPOIFavoriteModel.h"

#define PageSize (20)

@interface HMMyCollectPOIViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@end

@implementation HMMyCollectPOIViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray              * _dataArray;
    NSInteger                   _pageId;
    HMNetPageInfo               * _pageInfo;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (HMRunDataShare.needReflashMyPOI) {
        HMRunDataShare.needReflashMyPOI = NO;
        [_dataArray removeAllObjects];
        [self getData];
        _pageId = 1;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageId = 1;

    _dataArray = [[NSMutableArray alloc] init];
    HM_BIND_MSG(NotificationLoginSuccess, @selector(loginSuccess));
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMPOITableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMPOITableViewCell class])];
    [self getData];
}

-(void)loginSuccess
{
    _pageId = 1;
    [self getData];
}

-(void)refreshData
{
    _pageId = 1;
    [self getData];
}


-(void)loadMore
{
    if (!_pageInfo.hadMore) {
        [SVProgressHUD showErrorWithStatus:@"没有更多了"];
        [self endRefresh];
        [self endLoadMore];
        return;
    }
    [self getData];
}


-(void)getData
{
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"page" : [NSString stringWithFormat:@"%ld", (long)_pageId],
                              @"limit" : [NSString stringWithFormat:@"%d",PageSize]
                              };
    [HMNetwork getRequestWithPath:HMRequestMyFavoriteList params:params modelClass:[HMPOIFavoriteModel  class] success:^(id object, HMNetPageInfo *pageInfo) {
        [SVProgressHUD dismiss];
        _pageInfo = pageInfo;
        [self setupLoadMoreWithView:_tableView];

        if (_pageId == 1) {
            [_dataArray removeAllObjects];
        }
        if (_pageInfo.hadMore) {
            _pageId += 1;
            [self endLoadMore];
        }
        else{
            [self endRefreshingWithNoMoreData];
        }
        [_dataArray addObjectsFromArray:object];
        [_tableView reloadData];

    }];
}

-(NSString *)segmentTitle
{
    return @"收藏的餐厅";
}

-(UIScrollView *)streachScrollView
{
    return _tableView;
}


#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        HMPOITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMPOITableViewCell class])];
        HMPOIFavoriteModel * model = _dataArray[indexPath.row];
        [cell configureWithModel:model.favorite_entity isShowDistance:NO];
        return cell;
    }
    else{
        return [UITableViewCell new];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return _dataArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return 98;
    }
    return 98;
}

#pragma mark - UITableDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView) {
        HMPOIFavoriteModel * model = _dataArray[indexPath.row];
        HMPOIModel * poiModel = model.favorite_entity;
        HMPOIDetailViewController * poiDetailVC = [[HMPOIDetailViewController alloc] initWithNibName:NSStringFromClass([HMPOIDetailViewController class]) bundle:[NSBundle mainBundle]];
        poiDetailVC.poi_guid = poiModel.poi_guid;
        [self.navigationController pushViewController:poiDetailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
