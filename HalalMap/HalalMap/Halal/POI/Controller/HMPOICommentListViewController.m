//
//  HMPOICommentListViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/27.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOICommentListViewController.h"

#import "HMCommentCell.h"

#import "HMCommentModel.h"

@interface HMPOICommentListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@end

@implementation HMPOICommentListViewController
{
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray              * _dataArray;
    NSInteger                   _pageIndex;
    HMCommentCell               * _prototypeCell;
    HMNetPageInfo               * _pageInfo;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pageIndex = 1;
        _dataArray = [[NSMutableArray alloc] init];
        self.navigationItem.title = NSLocalizedString(@"所有评论", nil);
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tableView.fd_debugLogEnabled = YES;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPullRefreshWithView:_tableView];
    [self setupLoadMoreWithView:_tableView];
    _pageIndex = 1;

    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMCommentCell  class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMCommentCell class])];
    _prototypeCell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMCommentCell class])];
    
    
}

-(void)setPoi_guid:(NSString *)poi_guid
{
    _poi_guid = poi_guid;
    [self getData];
}

-(void)refreshData
{
    _pageIndex = 1;
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
    NSDictionary * params = @{
                              @"page" : [NSString stringWithFormat:@"%ld", (long)_pageIndex],
                              @"limit" : @"10"
                              };
    [HMNetwork getRequestWithPath:HMRequestPOICommentList(_poi_guid)
                           params:params
                       modelClass:[HMCommentModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              _pageInfo = pageInfo;

                              if (_pageIndex == 1) {
                                  [_dataArray removeAllObjects];
                              }
                              if (_pageInfo.hadMore) {
                                  _pageIndex += 1;
                              }

                              [SVProgressHUD dismiss];
                              [_dataArray addObjectsFromArray:object];
                              [_tableView reloadData];
                              [self endRefresh];
                              [self endLoadMore];

                          }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMCommentCell class])];
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    HMCommentModel * model = _dataArray[indexPath.row];
    [cell configureWithModel:model];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIOS(8.0)) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([HMCommentCell class]) cacheByIndexPath:indexPath configuration:^(HMCommentCell * cell) {
            [cell configureWithModel:_dataArray[indexPath.row]];
     
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([HMCommentCell class]) configuration:^(HMCommentCell * cell) {
            [cell configureWithModel:_dataArray[indexPath.row]];
            
        }];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    HMCommentModel * model = [_dataArray objectAtIndex:indexPath.row];
//    model.isFold  = !model.isFold;
//    
//    if (!model.isFold) {
//        model.contentOffset= tableView.contentOffset;
//    }
//    [_tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    if (model.isFold) {
//        tableView.contentOffset = model.contentOffset;
//    }
}

-(void)clickHeaderImageViewWithCommentCell:(HMCommentCell *)cell
{
    NSLog(@"用户信息");
}

@end
