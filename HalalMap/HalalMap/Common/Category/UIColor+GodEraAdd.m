//
//  UIColor+GodEraAdd.m
//  kissme
//
//  Created by sunyanliang on 13-9-4.
//  Copyright (c) 2013年 赵岩. All rights reserved.
//

#import "UIColor+GodEraAdd.h"

@implementation UIColor (GodEraAdd)

+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [self colorWithHex:hexValue alpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(hexValue & 0xFF))/255.0
						   alpha:alpha];
}

@end
