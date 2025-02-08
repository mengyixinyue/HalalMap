//
//  HMSelectRestaurantHeaderView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/20.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSelectRestaurantHeaderView;
@protocol HMSelectRestaurantHeaderViewDelegate <NSObject>

-(void)addBtnClickWithHeaderView:(HMSelectRestaurantHeaderView *)headerView;

@end

@interface HMSelectRestaurantHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<HMSelectRestaurantHeaderViewDelegate>delegate;

-(void)configureWithTitle:(NSString *)title isShowAddBtn:(BOOL)isShowBtn;

@end
