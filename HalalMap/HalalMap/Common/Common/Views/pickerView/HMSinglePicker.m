//
//  HMPatientPickerView.m
//  newPatient
//
//  Created by  on 16/1/19.
//  Copyright © 2016年 . All rights reserved.
//

#import "HMSinglePicker.h"

@interface HMSinglePicker ()
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@end

@implementation HMSinglePicker

-(id)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
        _dataArray = [[NSMutableArray alloc] init];
        if (_dataArray.count != 0) {
            _selectedType = [_dataArray objectAtIndex:0];
        }
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedType = [_dataArray objectAtIndex:row];
    _selectedRow = row;
    if (self.hmPickerDelegate && [self.hmPickerDelegate respondsToSelector:@selector(hmPickerView:didSelectRow:)]) {
        [self.hmPickerDelegate hmPickerView:self didSelectRow:row];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25;
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
        pickerLabel.text = _dataArray[row];
    }
    return pickerLabel;
}

-(void)setSelectedPatientType:(NSString *)selectedPatientType
{
    NSInteger index = NSNotFound;
    if (![selectedPatientType isEqualToString:_selectedType]) {
        
        for (int i = 0; i < [_dataArray count]; i++) {
            if ([[_dataArray objectAtIndex:i] isEqualToString:selectedPatientType]) {
                index = i;
                break;
            }
        }
        if (index != NSNotFound) {
            _selectedType = selectedPatientType;
            [self selectRow:index inComponent:0 animated:YES];
            [self pickerView:self didSelectRow:index inComponent:0];
        }
    }
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (_dataArray) {
        if ([dataArray isEqualToArray:_dataArray]) {
            return;
        }
        else{
            _dataArray = [NSMutableArray arrayWithArray:dataArray];
            [self reloadAllComponents];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
