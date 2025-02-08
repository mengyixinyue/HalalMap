//
//  HMFoundViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMFoundViewController.h"
#import "HMPublishFeedViewController.h"
#import "HMPOIDetailViewController.h"
#import "HMUserInfoViewController.h"
#import "HMChangeNameViewController.h"

#import "YSKeyboardTableView.h"
#import "HMFoundCell.h"
#import "HMFeedCommentView.h"

#import "HMFeedModel.h"

#define PageSize (20)


@interface HMFoundViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HMFoundCellDelegate,
UIActionSheetDelegate,
HMChangeNameViewControllerDelegate,
HMFeedCommentViewDelegate
>
@end

static NSString * HMFoundCellIdentifier = @"HMFoundCell";

@implementation HMFoundViewController
{
    IBOutlet YSKeyboardTableView    * _tableView;
    NSMutableArray                  * _dataArray;
    NSInteger                       _pageId;
    HMNetPageInfo                   * _pageInfo;
    HMFeedModel                     * _currentModel;
    NSIndexPath                     * _commentIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发现";
    _pageId = 1;
    
    _tableView.fd_debugLogEnabled = YES;
    [_tableView registerClass:[HMFoundCell class] forCellReuseIdentifier:HMFoundCellIdentifier];
    _dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self setupPullRefreshWithView:_tableView];

    [self addBarButtonItemWithImageName:@"feed_publish.png"
                                  title:nil
                                 action:@selector(addFeed:)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:nil
                  highlightedTitleColor:nil
                              titleFont:nil];
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
    [HMNetwork getRequestWithPath:HMRequestFeedList params:params modelClass:[HMFeedModel class] success:^(id object, HMNetPageInfo *pageInfo) {
        
        [SVProgressHUD dismiss];
        _pageInfo = pageInfo;
        
        if (_pageId == 1) {
            [_dataArray removeAllObjects];
            [self endRefresh];
        }
        if (_pageInfo.hadMore) {
            _pageId += 1;
            [self setupLoadMoreWithView:_tableView];
            [self endLoadMore];
            
        }else{
            [self endRefreshingWithNoMoreData];
        }
        
        
        [_dataArray addObjectsFromArray:object];
        [_tableView reloadData];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        [self setupPullRefreshWithView:_tableView];
        [self endRefresh];
    }];
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


#pragma mark - HMFeedCommentViewDelegate
-(void)commentSuccess:(NSString *)commentText userModel:(HMUserModel *)userModel
{
    HMCommentModel * commentModel = [[HMCommentModel alloc] init];
    commentModel.comment = commentText;
    
    HMUserModel * commentUser = [[HMUserModel alloc] init];
    commentUser.nickname = [HMRunData sharedHMRunData].userModel.nickname;
    commentUser.user_unique_key = [HMRunData sharedHMRunData].userModel.user_unique_key;
    commentModel.comment_user = commentUser;
    
    commentModel.parent_comment_user = userModel;
    
    HMFeedModel * model = [_dataArray objectAtIndex:_commentIndexPath.row];
    if (!model.feed_comments) {
        model.feed_comments = [[NSMutableArray alloc] init];
    }
    [model.feed_comments addObject:commentModel];
    
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:@[_commentIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

#pragma mark - 分享
-(void)shareBtnClickWithFoundCell:(HMFoundCell *)foundCell//分享
{
    HMFeedModel * model = [self feedModelWithCell:foundCell];
}

#pragma mark - 举报
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

-(void)showActionSheet
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"非清真", @"自定义内容", nil];
    [sheet showInView:self.view];
}

#pragma mark - 回复
-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell//回复
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

-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell userModel:(HMUserModel *)userModel commentModel:(HMCommentModel *)commentModel
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

#pragma mark - 点赞
-(void)voteBtnClickWithFoundCell:(HMFoundCell *)foundCell//点赞
{
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

#pragma mark - 添加feed
-(void)addFeed:(UIBarButtonItem *)bbi
{
    HMPublishFeedViewController * publishfeedVC = [[HMPublishFeedViewController alloc] init];
    [self.navigationController pushViewController:publishfeedVC animated:YES];
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

@end
