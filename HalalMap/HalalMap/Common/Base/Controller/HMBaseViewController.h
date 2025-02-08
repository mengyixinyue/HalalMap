//
//  HMBaseViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

typedef enum : NSUInteger {
    HMBarButtonTypeLeft,
    HMBarButtonTypeRight
} HMBarButtonType;


@interface HMBaseViewController : UIViewController

@property(nonatomic, assign)BOOL isNeedBackItemWhenPresentViewController;


-(BOOL)netIsConnected;

/**
 *  加BarButtonItem
 *
 *  @param imageName        图片名字
 *  @param title            <#title description#>
 *  @param action           事件
 *  @param type             类型 左侧按钮还是右侧按钮
 *  @param color            titleColor
 *  @param highlightedColor <#highlightedColor description#>
 *  @param titleFont        <#titleFont description#>
 */
-(UIBarButtonItem *)addBarButtonItemWithImageName:(NSString *)imageName
                               title:(NSString *)title
                              action:(SEL)action
                   barButtonItemType:(HMBarButtonType)type
                          titleColor:(UIColor *)color
               highlightedTitleColor:(UIColor *)highlightedColor
                           titleFont:(UIFont *)titleFont;

/**
 *  下拉刷新
 *
 *  @param view 对应的tableView collectionView webView
 */
-(void)setupPullRefreshWithView:(id)view;
-(void)refreshData;
-(void)endRefresh;

/**
 *  上拉加载更多
 *
 *  @param view <#view description#>
 */
-(void)setupLoadMoreWithView:(id)view;
-(void)loadMore;
-(void)endLoadMore;
-(void)endRefreshingWithNoMoreData;

-(void)setDefaultLeftBackItemWhenPresentViewControll;

-(void)loginSuccess:(loginSuccessBlock)success inViewnControll:(UIViewController*)viewController;



@end
