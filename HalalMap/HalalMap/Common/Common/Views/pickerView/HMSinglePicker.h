//
//  HDFPatientPickerView.h
//  newPatient
//
//  Created by  on 16/1/19.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSinglePicker;

@protocol HMSinglePickerDelegate <NSObject>

-(void)hmPickerView:(HMSinglePicker *)picker didSelectRow:(NSInteger)row;

@end

@interface HMSinglePicker : UIPickerView

@property (nonatomic, copy) NSString * selectedType;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) id<HMSinglePickerDelegate>hmPickerDelegate;

@end
