//
//  HMMyFeedViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/9.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMMyFeedViewController.h"
#import "HMPOIDetailViewController.h"
#import "HMPublishFeedViewController.h"
#import "HMUserInfoViewController.h"
#import "HMChangeNameViewController.h"

#import "HMFeedCommentView.h"

#import "HMFoundCell.h"

#import "HMFeedModel.h"

static NSString * HMFoundCellIdentifier = @"HMFoundCell";
#define PageSize (20)

@interface HMMyFeedViewController ()
<
HMFoundCellDelegate,
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
HMChangeNameViewControllerDelegate,
HMFeedCommentViewDelegate
>
@end

@implementation HMMyFeedViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray              * _dataArray;
    NSInteger                   _pageId;
    HMNetPageInfo               * _pageInfo;
    HMFeedModel                 * _currentModel;
    NSIndexPath                 * _commentIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageId = 1;

    _tableView.fd_debugLogEnabled = YES;
    [_tableView registerClass:[HMFoundCell class] forCellReuseIdentifier:HMFoundCellIdentifier];
    _dataArray = [[NSMutableArray alloc] init];
    HM_BIND_MSG(NotificationLoginSuccess, @selector(loginSuccess));
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (HMRunDataShare.needReflashMyFeed) {
        HMRunDataShare.needReflashMyFeed = NO;
        [_dataArray removeAllObjects];
        [self getData];
    }
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
    if (_pageId == 1) {
        [SVProgressHUD show];
    }
    NSDictionary * params = @{
                              @"page" : [NSString stringWithFormat:@"%ld", (long)_pageId],
                              @"limit" : [NSString stringWithFormat:@"%d",PageSize]
                              };
    [HMNetwork getRequestWithPath:HMRequestMyAddedFeedList
                           params:params
                       modelClass:[HMFeedModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              [SVProgressHUD dismiss];
                              _pageInfo = pageInfo;
                              [self setupLoadMoreWithView:_tableView];

                              if (_pageId == 1) {
                                  [_dataArray removeAllObjects];
                                  [self endRefresh];
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
    return @"晒过的美食";
}

-(UIScrollView *)streachScrollView
{
    return _tableView;
}

-(void)loginSuccess
{
    _pageId = 1;
    [self getData];
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
    HMUserInfoViewController * userInfoVC = [[HMUserInfoViewController alloc] init];
    userInfoVC.userInfoModel = userModel;
    
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

-(void)shareBtnClickWithFoundCell:(HMFoundCell *)foundCell//分享
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
}

-(void)reportBtnClickWithFoundCell:(HMFoundCell *)foundCell//举报
{
    _currentModel = [self feedModelWithCell:foundCell];
    if ([HMRunData isLogin]) {
        [self showActionSheet];
    }
    else{
        WS(weakSelf);
        [self loginSuccess:^{
            [weakSelf showActionSheet];
        } inViewnControll:self];
    }

}

//回复
-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell
{
    if ([HMRunData isLogin]) {
        [self commentWithCell:foundCell parent_guid:nil userModel:nil];
    }
    else{
        WS(weakSelf);
        [self loginSuccess:^{
            [weakSelf commentWithCell:foundCell parent_guid:nil userModel:nil];
        } inViewnControll:self];
    }
}

-(void)commentWithCell:(HMFoundCell *)foundCell parent_guid:(NSString *)parent_guid userModel:(HMUserModel *)userModel
{
    _commentIndexPath = [_tableView indexPathForCell:foundCell];
    HMFeedModel * model = [self feedModelWithCell:foundCell];
    HMFeedCommentView * commentView = [HMFeedCommentView showFeedCommentViewWithDelegate:self feedModel:model parent_guid:parent_guid userModel:userModel];
    [self.view.window addSubview:commentView];
}

-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell userModel:(HMUserModel *)userModel commentModel:(HMCommentModel *)commentModel//回复
{
    if ([HMRunData isLogin]) {
        [self commentWithCell:foundCell parent_guid:commentModel.parent_guid userModel:(HMUserModel *)userModel];
    }
    else{
        WS(weakSelf);
        [self loginSuccess:^{
            [weakSelf commentWithCell:foundCell parent_guid:commentModel.parent_guid userModel:(HMUserModel *)userModel];
        } inViewnControll:self];
    }
}


-(void)voteBtnClickWithFoundCell:(HMFoundCell *)foundCell//点赞
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
    if ([HMRunData isLogin]) {
        [self voteWithCell:foundCell];
    }
    else{
        WS(weakSelf);
        [self loginSuccess:^{
            [weakSelf voteWithCell:foundCell];
        } inViewnControll:self];
    }
}

-(void)voteWithCell:(HMFoundCell *)foundCell
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
    HMVoteModel * voteModel = [[HMVoteModel alloc] init];
    voteModel.vote_user = [HMRunData sharedHMRunData].userModel;
    NSIndexPath * indexPath = [_tableView indexPathForCell:foundCell];
    [HMNetwork postRequestWithPath:HMRequestFeedVote(model.feed_guid) params:nil success:^(HMNetResponse *response) {
        model.hasVoted = @"1";
        NSDictionary * responseDict = response.response;
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            voteModel.vote_guid = [response.response objectForKey:@"vote_guid"];
        }
        if (!model.feed_votes) {
            model.feed_votes= [[NSMutableArray alloc] init];
        }
        [model.feed_votes addObject:voteModel];
        [_tableView beginUpdates];
        [_tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
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


-(void)showActionSheet
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"非清真", @"自定义内容", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        switch (buttonIndex) {
            case HMReportTypeNoHalal:
            {
                [self changeNameWithNewText:NSLocalizedString(@"非清真", nil)];
            }
                break;
            case HMReportTypeCustom:
            {
                HMChangeNameViewController * changeVC = [HMHelper xibWithViewControllerClass:[HMChangeNameViewController class]];
                changeVC.delegate = self;
                changeVC.navigationItem.title = NSLocalizedString(@"举报", nil);
                changeVC.placeHolder = NSLocalizedString(@"请输入举报的内容", nil);
                changeVC.maxStrNum = 1500;
                [self.navigationController pushViewController:changeVC animated:YES];
            }
            default:
                break;
        }
    }
}

#pragma mark - HMChangeNameViewControllerDelegate
-(void)changeNameWithNewText:(NSString *)newText
{
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"entity_type" : @"1",
                              @"entity_guid" : _currentModel.feed_guid,
                              @"description" : newText ? newText : @""
                              };
    [HMNetwork postRequestWithPath:HMRequestClaim params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"谢谢，举报成功，我们会尽快给您反馈处理结果。", nil)];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
