//
//  HMDatePickerView.h
//  newPatient
//
//  Created by  on 16/1/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMDatePickerViewDelegate <NSObject>

-(void)confirmWithDatePickerView:(UIDatePicker *)datePickerView;

@end


@interface HMDatePickerView : UIControl

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) BOOL isShowToolbar;
@property(nonatomic, assign) id<HMDatePickerViewDelegate>delegate;

+(HMDatePickerView *)showWithDelegate:(id<HMDatePickerViewDelegate>)delegate animated:(BOOL)animated;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

-(void)dismiss;
@end
