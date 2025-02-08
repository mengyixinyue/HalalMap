//
//  HMProvincePickerView.h
//  newPatient
//
//  Created by  on 16/1/22.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMProvincePickerView;
@protocol HMProvincePickerViewDelegate <NSObject>

-(void)hmProvincePickerView:(HMProvincePickerView *)picker didSelectRow:(NSInteger)row;

@end


@interface HMProvincePickerView : UIPickerView

@property (nonatomic, strong) NSMutableArray    * provinces;
@property (nonatomic, strong) NSMutableArray    * cities;
@property (nonatomic, copy) NSString            * province;
@property (nonatomic, copy) NSString            * city;
@property (nonatomic, strong) NSArray           * selectedCities;
@property (nonatomic, assign) BOOL              hideCity;
@property (nonatomic, assign) id<HMProvincePickerViewDelegate> procinceDelegate;

- (void)setProvince:(NSString *)province andCity:(NSString *)city;

@end
