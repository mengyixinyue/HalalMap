//
//  HMProvincePickerView.m
//  newPatient
//
//  Created by  on 16/1/22.
//  Copyright © 2016年 . All rights reserved.
//

#import "HMProvincePickerView.h"

@interface HMProvincePickerView ()
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@end

@implementation HMProvincePickerView


-(id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
        _cities = [[NSMutableArray alloc] init];
        _selectedCities = [[NSMutableArray alloc] init];
        NSString *plist = [[NSBundle mainBundle]pathForResource:@"provinces" ofType:@".plist"];
        NSDictionary * dict = [[NSDictionary alloc]initWithContentsOfFile:plist];
        NSArray *array = @[@""];
//        [dict arrayForKey:@"全部省份"];
        _provinces = [[NSMutableArray alloc] initWithArray:array];
        for (NSString * str in _provinces) {
            [_cities addObject:[dict objectForKey:str]];
        }
        _province = [_provinces objectAtIndex:0];
       
        _selectedCities = [_cities objectAtIndex:0];
        _hideCity = NO;
    }
    return self;
}

-(void)setProvince:(NSString *)province andCity:(NSString *)city
{
    NSInteger index = NSNotFound;
    if (![province isEqualToString:_province]) {
        
        for (int i = 0; i < [_provinces count]; i++) {
            if ([[_provinces objectAtIndex:i] isEqualToString:province]) {
                index = i;
                break;
            }
        }
        if (index != NSNotFound) {
            _province = province;
            _selectedCities = [_cities objectAtIndex:index];
            [self selectRow:index inComponent:0 animated:YES];
            if (!_hideCity) {
                [self selectRow:0 inComponent:1 animated:YES];
                [self reloadComponent:1];
            }
        }
    }
    
    if (![city isEqualToString:_city] && !_hideCity) {
        index = NSNotFound;
        for (int i = 0; i < [_selectedCities count]; i++) {
            if ([[_selectedCities objectAtIndex:i] isEqualToString:city]) {
                index = i;
                break;
            }
        }
        if (index != NSNotFound) {
            _city = city;
            [self selectRow:index inComponent:1 animated:YES];
            [self pickerView:self didSelectRow:index inComponent:1];
        }
    }
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _hideCity ? 1 : 2;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _provinces.count;
    }
    else{
        return _selectedCities.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGFloat widht = SCREEN_WIDTH;
        CGRect frame = CGRectMake(0.0, 0.0, widht, 25);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18.0f]];
        pickerLabel.textColor = HMGrayColor;
    }
    if (component == 0) {
        pickerLabel.text = _provinces[row];
    }else{
        pickerLabel.text = _selectedCities[row];
    }
    return pickerLabel;
}

#pragma mark - PickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_provinces objectAtIndex:row];
    } else {
        return [_selectedCities objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    BOOL triggerSelector = NO;
    if (component == 0) {
        _selectedCities = [_cities objectAtIndex:row];
        _province = [_provinces objectAtIndex:row];
        if (!_hideCity) {
            [self reloadComponent:1];
            [self selectRow:0 inComponent:1 animated:YES];
            [self pickerView:self didSelectRow:0 inComponent:1];
        } else {
            triggerSelector = YES;
        }
    } else {
        _city = [_selectedCities objectAtIndex:row];
        triggerSelector = YES;
    }
    
    if (triggerSelector && self.procinceDelegate && [self.procinceDelegate respondsToSelector:@selector(HMProvincePickerView:didSelectRow:)]) {
        [self.procinceDelegate hmProvincePickerView:self didSelectRow:row];
    }
}

- (void)setSelectedCities:(NSArray *)selectedCities
{
    _selectedCities = selectedCities;
}

-(void)setHideCity:(BOOL)hideCity
{
    _hideCity = hideCity;
    [self reloadAllComponents];
}

@end
