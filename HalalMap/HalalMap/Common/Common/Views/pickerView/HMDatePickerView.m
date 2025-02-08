//
//  HDFDatePickerView.m
//  newPatient
//
//  Created by  on 16/1/22.
//  Copyright © 2016年 . All rights reserved.
//

#import "HMDatePickerView.h"

#define HMDatePickerHeight 215
#define HMToolbarHeight 44


@implementation HMDatePickerView
{
    UIToolbar * _toolbar;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        [self initialUIWithFrame:frame];
        self.isShowToolbar = YES;
        [self addTarget:self action:@selector(backgroundPressed:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void)initialUIWithFrame:(CGRect)frame
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, frame.size.height - HMDatePickerHeight, frame.size.width, HMDatePickerHeight)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        datePicker.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
        datePicker.backgroundColor = [UIColor whiteColor];
    }
    [self addSubview:datePicker];
    self.datePicker = datePicker;

    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonItemPressed:)];
    cancelButtonItem.width = 55;
    [cancelButtonItem setTintColor:HMGrayColor];
    
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmButtonItemPressed:)];
    [confirmButtonItem setTintColor:HMGrayColor];
    
    confirmButtonItem.width = 55;
    
    UIBarButtonItem * spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,frame.size.height - HMDatePickerHeight - HMToolbarHeight, SCREEN_WIDTH, HMToolbarHeight)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = YES;
    toolbar.items = [NSArray arrayWithObjects:cancelButtonItem, spaceButtonItem, confirmButtonItem, nil];
    [self addSubview:toolbar];
    _toolbar = toolbar;
}

#pragma mark - 取消和确定按钮触发方法
- (void) cancelButtonItemPressed:(id)sender
{
    [self hide:YES];
}

- (void) confirmButtonItemPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithDatePickerView:)]) {
        [self.delegate confirmWithDatePickerView:_datePicker];
    }
    [self hide:YES];
}

-(void)backgroundPressed:(id)sender
{
    [self hide:YES];
}

- (void)show:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"showDatePickerView" context:(__bridge void * _Nullable)(self)];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    self.datePicker.originY = self.height - self.datePicker.height;
    if (self.isShowToolbar) {
        _toolbar.originY = self.height - self.datePicker.height - _toolbar.height;
    }
    if (animated) {
        [UIView commitAnimations];
    }
}



- (void)hide:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"hideDatePickerView" context:(__bridge void * _Nullable)(self)];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    [_datePicker setOrigin:CGPointMake(0, self.frame.size.height + _toolbar.height)];
    if (self.isShowToolbar) {
        [_toolbar setOrigin:CGPointMake(0, self.frame.size.height)];
    }
    self.backgroundColor = [UIColor clearColor];
    if (animated) {
        [UIView commitAnimations];
    }
}

+(HMDatePickerView *)showWithDelegate:(id<HMDatePickerViewDelegate>)delegate animated:(BOOL)animated
{
    HMDatePickerView * datePicker = [[HMDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    datePicker.delegate = delegate;
    datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    [HM_AppWindow addSubview:datePicker];
    [datePicker show:animated];
    return datePicker;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"showDatePickerView"]) {
    } else if ([animationID isEqualToString:@"hideDatePickerView"]) {
        UIView *aView = (__bridge UIView *)context;
        [aView removeFromSuperview];
    }
}

-(void)dismiss
{
    [self hide:NO];
}

@end
