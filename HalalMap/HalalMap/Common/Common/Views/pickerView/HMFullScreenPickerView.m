//
//  HMPickerView.m
//  newPatient
//
//  Created by  on 16/1/19.
//  Copyright © 2016年 . All rights reserved.
//

#import "HMFullScreenPickerView.h"

#define HMDatePickerHeight 215
#define HMToolbarHeight 44

@interface HMFullScreenPickerView ()
<
UIPickerViewDelegate,
UIPickerViewDataSource,
HMSinglePickerDelegate,
HMProvincePickerViewDelegate
>

@end

@implementation HMFullScreenPickerView
{
    HMPickerViewType _pickerViewType;
    UIBarButtonItem * _cancelButtonItem;
    UIBarButtonItem * _confirmButtonItem;
    UIToolbar       * _toolbar;
    UIControl       * _backgroundControl;

}

-(id)initWithFrame:(CGRect)frame type:(HMPickerViewType)pickerViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        _pickerViewType = pickerViewType;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        [self initializonUI];
        self.isShowToolbar = YES;
        [self addTarget:self action:@selector(backgroundPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)initializonUI
{

    _cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonItemPressed:)];
    _cancelButtonItem.width = 55;
    [_cancelButtonItem setTintColor:HMGrayColor];

    _confirmButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmButtonItemPressed:)];
    _confirmButtonItem.width = 55;
    [_confirmButtonItem setTintColor:HMGrayColor];
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,self.frame.size.height,SCREEN_WIDTH,44)];
    _toolbar.barStyle = UIBarStyleDefault;
    _toolbar.items = [NSArray arrayWithObjects:_cancelButtonItem,spaceButtonItem, _confirmButtonItem, nil];
    [self addSubview:_toolbar];
    
    if (_pickerViewType != HMPickerViewTypeCity) {
        HMSinglePicker * singlePickerView = [[HMSinglePicker alloc] init];
        singlePickerView.delegate = self;
        _pickerView = singlePickerView;
        
    }
    
    switch (_pickerViewType) {
        case HMPickerViewTypePatientRelation:
        {
            ((HMSinglePicker *)_pickerView).dataArray = [NSMutableArray arrayWithObjects:@"与患者关系", @"本人", @"家庭成员", @"亲戚", @"朋友", @"其他", nil];
        }
            break;
        case HMPickerViewTypeSexuality:
        {
            ((HMSinglePicker *)_pickerView).dataArray = [NSMutableArray arrayWithObjects:@"性别",@"女", @"男", nil];
        }
            break;
        case HMPickerViewTypeCity:
        {
            HMProvincePickerView * provincePickerView = [[HMProvincePickerView alloc] init];
            provincePickerView.procinceDelegate = self;
            _pickerView = provincePickerView;
        }
            break;
        default:
            break;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    
    CGRect frame = _pickerView.frame;
    frame.origin.x = 0;
    frame.origin.y = self.frame.size.height + _toolbar.height;
    frame.size.width = self.frame.size.width;
    frame.size.height = self.frame.size.height / 3;
    _pickerView.frame = frame;
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self addSubview:_pickerView];
    
}

#pragma mark - 取消和确定按钮触发方法
- (void) cancelButtonItemPressed:(id)sender
{
    [self hide:YES];
}

- (void) confirmButtonItemPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithPickerView:)]) {
        [self.delegate confirmWithPickerView:self.pickerView];
    }
    
    [self hide:YES];
}

#pragma mark - HMSinglePickerDelegate
-(void)hmPickerView:(HMSinglePicker *)picker didSelectRow:(NSInteger)row
{
    if (_isShowToolbar) {
        return;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithPickerView:)]) {
            [self.delegate confirmWithPickerView:self.pickerView];
        }
    }
}

#pragma mark - HMProvincePickerViewDelegate
-(void)hmProvincePickerView:(HMProvincePickerView *)picker didSelectRow:(NSInteger)row
{
    if (_isShowToolbar) {
        return;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithPickerView:)]) {
            [self.delegate confirmWithPickerView:self.pickerView];
        }
    }
}

+(HMFullScreenPickerView *)showWithType:(HMPickerViewType)pickerViewType delegate:(id<HMFullScreenPickerViewDelegate>)delegate animated:(BOOL)animated
{
    HMFullScreenPickerView * picker = [[HMFullScreenPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:pickerViewType];
    [HM_AppWindow addSubview:picker];
    picker.delegate = delegate;
    picker.isShowToolbar = YES;
    [picker show:animated];
    return picker;
}

-(void)show:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"showPickerView" context:(__bridge void * _Nullable)(self)];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    HMSinglePicker * picker = (HMSinglePicker *)_pickerView;
    [picker setOrigin:CGPointMake(0, self.frame.size.height - _pickerView.frame.size.height)];
    if (self.isShowToolbar) {
        [_toolbar setOrigin:CGPointMake(0, _pickerView.origin.y - _toolbar.height)];
    }
 
    
    if (animated) {
        [UIView commitAnimations];
    }
}

-(void)hide:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"hidePickerView" context:(__bridge void * _Nullable)(self)];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    [_pickerView setOrigin:CGPointMake(0, self.frame.size.height + _toolbar.height)];
    if (self.isShowToolbar) {
        [_toolbar setOrigin:CGPointMake(0, self.frame.size.height)];
    }
    self.backgroundColor = [UIColor clearColor];
    if (animated) {
        [UIView commitAnimations];
    }

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showPickerView"]) {
    } else if ([animationID isEqualToString:@"hidePickerView"]) {
        UIView *aView = (__bridge UIView *)context;
        [aView removeFromSuperview];
    }
}

- (void)backgroundPressed:(id)sender
{
    [self hide:YES];
}

-(void)dismiss
{
    [self hide:NO];
}

@end
