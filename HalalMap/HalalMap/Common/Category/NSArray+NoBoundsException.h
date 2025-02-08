//
//  NSArray+NoBoundsException.h
//  
//
//  Created by  on 14-8-31.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NoBoundsException)
/**
 *  数组越界判断 不越界正常返回 越界返回nil
 *
 */
-(id)objectAtIndex2:(NSInteger)index;

@end
