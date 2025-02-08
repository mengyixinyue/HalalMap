//
//  HMCycleScrollowView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/1/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMCycleScrollowView;
@protocol HMCycleScrollowViewDelegate <NSObject>

-(void)cycleScrollowView:(HMCycleScrollowView *)cycleScrollowView selectedIndex:(NSInteger)index;

@end

@interface HMCycleScrollowView : UIView

@property (nonatomic, assign) id<HMCycleScrollowViewDelegate>delegate;

-(void)configureWithArray:(NSArray *)array;

@end
