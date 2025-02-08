//
//  HMBaseViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"
#import "HMLoginViewController.h"
#import "HMRegisterViewController.h"

@interface HMBaseViewController ()

@property(nonatomic, weak)id refreshView;
@property(nonatomic, weak)id loadMoreView;

@end

@implementation HMBaseViewController

-(BOOL)netIsConnected
{
    Reachability    *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    int             status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
        return NO;
    }
    else if ((status == ReachableViaWiFi) || (status == ReachableViaWWAN)) {
        return YES;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setStatusBar];
    [self setDefaultBackButtonItem];
    
    if (self.isNeedBackItemWhenPresentViewController) {
        [self setDefaultLeftBackItemWhenPresentViewControll];
    }
}

-(void)setStatusBar
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //视图控制器，四条边不指定
    self.extendedLayoutIncludesOpaqueBars = NO;
    //不透明的操作栏<br>
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)setupPullRefreshWithView:(id)view
{
    self.refreshView = view;
    __weak __typeof(self) weakSelf = self;
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView * refreshTableView = (UITableView *)weakSelf.refreshView;
        refreshTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
    }
    else if ([view isKindOfClass:[UIWebView class]]){
        UIWebView * refreshWebView = (UIWebView *)weakSelf.refreshView;
        refreshWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
    }
    else if ([view isKindOfClass:[UIScrollView class]])
    {
        UIScrollView * refreshScrollView = (UIScrollView *)weakSelf.refreshView;
        refreshScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
    }
    else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView * refreshCollectionView = (UICollectionView *)weakSelf.refreshView;
        refreshCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
    }
}

-(void)refreshData
{
    NSLog(@"刷新数据");
}

-(void)endRefresh
{
    NSLog(@"结束刷新");
    if ([self.refreshView isKindOfClass:[UITableView class]]) {
        UITableView * refreshTableView = (UITableView *)self.refreshView;
        [refreshTableView.mj_header endRefreshing];
    }
    else if ([self.refreshView isKindOfClass:[UICollectionView class]]){
        UICollectionView * refreshCollectionView = (UICollectionView *)self.refreshView;
        [refreshCollectionView.mj_header endRefreshing];
    }
    else if ([self.refreshView isKindOfClass:[UIWebView class]]){
        UIWebView * refreshWebView = (UIWebView *)self.refreshView;
        [refreshWebView.scrollView.mj_header endRefreshing];
    }
    else if ([self.refreshView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView * refreshScrollView = (UIScrollView *)self.refreshView;
        [refreshScrollView.mj_header endRefreshing];
    }
}

-(void)setupLoadMoreWithView:(id)view
{
    if (view) {
        self.loadMoreView = view;
        __weak HMBaseViewController * weakSelf = self;
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView * loadMoreTableView = (UITableView *)weakSelf.loadMoreView;
            loadMoreTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf loadMore];
            }];
        }
        else if ([view isKindOfClass:[UIWebView class]]){
            UIWebView * loadMoreWebView = (UIWebView *)weakSelf.loadMoreView;
            loadMoreWebView.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf loadMore];
            }];
            
        }
        else if ([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView * loadMoreScrollView = (UIScrollView *)weakSelf.loadMoreView;
            loadMoreScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf loadMore];
            }];
        }
        else if ([view isKindOfClass:[UICollectionView class]]){
            UICollectionView * loadMoreCollectionView = (UICollectionView *)weakSelf.loadMoreView;
            loadMoreCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf loadMore];
            }];
        }
    }
}



-(void)loadMore
{
    NSLog(@"加载更多");
}

-(void)endLoadMore
{
    NSLog(@"结束加载更多");
    if (self.loadMoreView) {
        if ([self.loadMoreView isKindOfClass:[UITableView class]]) {
            UITableView * refreshTableView = (UITableView *)self.loadMoreView;
            [refreshTableView.mj_footer endRefreshing];
        }
        else if ([self.loadMoreView isKindOfClass:[UICollectionView class]]){
            UICollectionView * refreshCollectionView = (UICollectionView *)self.loadMoreView;
            [refreshCollectionView.mj_footer endRefreshing];
        }
        else if ([self.loadMoreView isKindOfClass:[UIWebView class]]){
            UIWebView * refreshWebView = (UIWebView *)self.loadMoreView;
            [refreshWebView.scrollView.mj_footer endRefreshing];
        }
        else if ([self.loadMoreView isKindOfClass:[UIScrollView class]])
        {
            UIScrollView * refreshScrollView = (UIScrollView *)self.loadMoreView;
            [refreshScrollView.mj_footer endRefreshing];
        }
    }
}

-(void)endRefreshingWithNoMoreData
{
    if ([self.loadMoreView isKindOfClass:[UITableView class]]) {
        UITableView * refreshTableView = (UITableView *)self.loadMoreView;
        [refreshTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else if ([self.loadMoreView isKindOfClass:[UICollectionView class]]){
        UICollectionView * refreshCollectionView = (UICollectionView *)self.loadMoreView;
        [refreshCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
    else if ([self.loadMoreView isKindOfClass:[UIWebView class]]){
        UIWebView * refreshWebView = (UIWebView *)self.loadMoreView;
        [refreshWebView.scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    else if ([self.loadMoreView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView * refreshScrollView = (UIScrollView *)self.loadMoreView;
        [refreshScrollView.mj_footer endRefreshingWithNoMoreData];
    }

}

-(UIBarButtonItem *)addBarButtonItemWithImageName:(NSString *)imageName
                               title:(NSString *)title
                              action:(SEL)action
                   barButtonItemType:(HMBarButtonType)type
                          titleColor:(UIColor *)color
               highlightedTitleColor:(UIColor *)highlightedColor
                           titleFont:(UIFont *)titleFont
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    }
    btn.frame = CGRectMake(0,0,40,45);
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
    }
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (titleFont) {
        btn.titleLabel.font = titleFont;
    }
    
    
    if (type == HMBarButtonTypeLeft) {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    }
    else
    {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    }
    
    if (color) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    else{
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (highlightedColor) {
        [btn setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    }
//    [btn setTitleColor:HMMainColor forState:UIControlStateNormal];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (type == HMBarButtonTypeLeft) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    else if(type == HMBarButtonTypeRight)
    {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
    return barButtonItem;
}

-(void)setDefaultBackButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    UIImage* image = [UIImage imageNamed:@"backArrow"];
    [item setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(-800, 0) forBarMetrics:UIBarMetricsDefault];
    [item setTitle:@"  "];
    self.navigationItem.backBarButtonItem = item;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDefaultLeftBackItemWhenPresentViewControll
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 0, 44, 44)];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0,20);
    
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)loginSuccess:(loginSuccessBlock)success inViewnControll:(UIViewController*)viewController {
    
    [HMLoginViewController loginWithSuccess:success inViewController:viewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
