//
//  HMUserFeedViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMUserFeedViewController.h"
#import "HMPOIDetailViewController.h"
#import "HMPublishFeedViewController.h"

#import "HMFoundCell.h"

#import "HMFeedModel.h"

static NSString * HMFoundCellIdentifier = @"HMFoundCell";
#define PageSize (20)

@interface HMUserFeedViewController ()
<
HMFoundCellDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@end

@implementation HMUserFeedViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray              * _dataArray;
    NSInteger                   _pageId;
    HMUserModel                 * _userModel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.fd_debugLogEnabled = YES;
    [_tableView registerClass:[HMFoundCell class] forCellReuseIdentifier:HMFoundCellIdentifier];
    _dataArray = [[NSMutableArray alloc] init];
}

-(void)setUser_unique_key:(NSString *)user_unique_key
{
    _user_unique_key = user_unique_key;
    [self getData];
}

-(void)getData
{
    NSDictionary * params = @{
                              @"page" : @"1",
                              @"limit" : [NSString stringWithFormat:@"%d",PageSize],
                              @"user_unique_key" : self.user_unique_key
                              };
    [HMNetwork getRequestWithPath:HMRequestMyAddedFeedList
                           params:params
                       modelClass:[HMFeedModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              if (_pageId == 1) {
                                  [_dataArray removeAllObjects];
                              }
                              _pageId += 1;
                              
                              [_dataArray addObjectsFromArray:object];
                              [_tableView reloadData];
                          }];
}

-(NSString *)segmentTitle
{
    return @"Ta晒过的美食";
}

-(UIScrollView *)streachScrollView
{
    return _tableView;
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMFoundCell * cell = [tableView dequeueReusableCellWithIdentifier:HMFoundCellIdentifier forIndexPath:indexPath];
    [cell configureCellWithModel:_dataArray[indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isIOS(8.0)) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([HMFoundCell class]) cacheByIndexPath:indexPath configuration:^(HMFoundCell * cell) {
            [cell configureCellWithModel:_dataArray[indexPath.row]];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([HMFoundCell class]) configuration:^(HMFoundCell * cell) {
            [cell configureCellWithModel:_dataArray[indexPath.row]];
            
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - HMFoundCellDelegate
-(void)poiClickWithFoundCell:(HMFoundCell *)foundCell
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
    HMPOIDetailViewController * poiDetailVC = [[HMPOIDetailViewController alloc] initWithNibName:NSStringFromClass([HMPOIDetailViewController class]) bundle:[NSBundle mainBundle]];
    poiDetailVC.poi_guid = model.feed_related_poi.poi_guid;
    [self.navigationController pushViewController:poiDetailVC animated:YES];
}

-(void)foundCell:(HMFoundCell *)foundCell userModel:(HMUserModel *)userModel
{
    NSLog(@"点击了赞%@", userModel.nickname);
}

-(void)shareBtnClickWithFoundCell:(HMFoundCell *)foundCell//分享
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
}

-(void)reportBtnClickWithFoundCell:(HMFoundCell *)foundCell//举报
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
}

-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell//回复
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
}

-(void)voteBtnClickWithFoundCell:(HMFoundCell *)foundCell//点赞
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
    
}


-(HMFeedModel *)feedModelWithCell:(HMFoundCell *)foundCell
{
    NSIndexPath * indexPath = [_tableView indexPathForCell:foundCell];
    HMFeedModel * model = _dataArray[indexPath.row];
    return model;
}

-(void)addFeed:(UIBarButtonItem *)bbi
{
    HMPublishFeedViewController * publishfeedVC = [[HMPublishFeedViewController alloc] init];
    [self.navigationController pushViewController:publishfeedVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
