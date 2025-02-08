//
//  HMPickerView.h
//  newPatient
//
//  Created by  on 16/1/19.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSinglePicker.h"
#import "HMProvincePickerView.h"

typedef enum : NSUInteger {
    HMPickerViewTypePatientRelation,//患者关系
    HMPickerViewTypeSexuality,//性别
    HMPickerViewTypeCity//省市
} HMPickerViewType;

@protocol HMFullScreenPickerViewDelegate <NSObject>

-(void)confirmWithPickerView:(UIPickerView *)pickerView;

@end

@interface HMFullScreenPickerView : UIControl

@property(nonatomic, strong) UIPickerView * pickerView;
@property(nonatomic, assign) BOOL isShowToolbar;
@property(nonatomic, assign) id<HMFullScreenPickerViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame type:(HMPickerViewType)pickerViewType;
-(void)show:(BOOL)animated;
-(void)hide:(BOOL)animated;

+(HMFullScreenPickerView *)showWithType:(HMPickerViewType)pickerViewType delegate:(id<HMFullScreenPickerViewDelegate>)delegate animated:(BOOL)animated;

-(void)dismiss;

@end
