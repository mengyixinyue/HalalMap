//
//  HMSelectAreaView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSelectAreaView : UIView

/**
 *  展示筛选县区
 *
 *  @param view                  要展示在的view
 *  @param array                 数据源
 *  @param selectedDistrictIndex 当前选中的县区
 *  @param selectedBuAreaIndex   当前选择的商圈
 *  @param finishBlock           完成筛选的block
 *  @param failBlock             取消筛选的block
 */
-(void)showSelectAreaInView:(UIView *)view
                   WithData:(NSArray *)array
      selectedDistrictIndex:(NSInteger)selectedDistrictIndex
        selectedBuAreaIndex:(NSInteger)selectedBuAreaIndex
                finishBolck:(void(^) (NSInteger selectedDistrictIndex, NSInteger selectedBuAreaIndex))finishBlock
                  failBlock:(void(^)())failBlock;

- (void)hide;

@end
