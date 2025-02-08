//
//  HMPOIListViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOIListViewController.h"
#import "HMPOIDetailViewController.h"
#import "HMHomePageViewController.h"

#import "HMPOITableViewCell.h"

#import "HMPOIModel.h"

#define HMPOITableViewCellIdentifier @"HMPOITableViewCell"

@interface HMPOIListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@end

@implementation HMPOIListViewController
{
    __weak IBOutlet UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"HMPOITableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HMPOITableViewCellIdentifier];
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        HMPOITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HMPOITableViewCellIdentifier];
        [cell configureWithModel:_dataArray[indexPath.row] isShowDistance:YES];
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
        HMPOIModel * model = _dataArray[indexPath.row];
        HMPOIDetailViewController * poiDetailVC = [[HMPOIDetailViewController alloc] initWithNibName:NSStringFromClass([HMPOIDetailViewController class]) bundle:[NSBundle mainBundle]];
        poiDetailVC.poi_guid = model.poi_guid;
        [self.navigationController pushViewController:poiDetailVC animated:YES];
    }
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataArray];
    [_tableView reloadData];
}

- (void)setCanLoadMore:(BOOL)canLoadMore
{
    _canLoadMore = canLoadMore;
    if (_canLoadMore) {
        [self setupLoadMoreWithView:_tableView];
    }
    else{
        [self endLoadMore];
    }
}

-(void)loadMore
{
    [(HMHomePageViewController *)self.parentViewController getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
