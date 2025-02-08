//
//  HMARSegmentView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMARSegmentView;
@protocol HMARSegmentViewDelegate <NSObject>

- (void)hmARSegmentView:(HMARSegmentView *)segmentView didSelectItemAtIndex:(NSInteger)index;

@end

@interface HMARSegmentView : UIView

@property (nonatomic,weak) id<HMARSegmentViewDelegate>delegate;

- (instancetype)initWithTitles:(NSArray *)titles;

@end
