//
//  HMFontHelper.m
//  HM
//
//  Created by yj on 15/8/13.
//  Copyright (c) 2015年 BT. All rights reserved.
//

#import "HMFontHelper.h"

@implementation HMFontHelper

+ (UIFont *)fontOfSize:(CGFloat)size
{
//    UIFont *font = [UIFont fontWithName:@"HYQiHei-EZS" size:size];
    UIFont *font = [UIFont systemFontOfSize:size];
    return font;
}

@end
