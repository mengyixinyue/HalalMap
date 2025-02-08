//
//  NSArray+NoBoundsException.m
//
//
//  Created by  on 14-8-31.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "NSArray+NoBoundsException.h"

@implementation NSArray (NoBoundsException)

-(id)objectAtIndex2:(NSInteger)index {
    if (index >= 0 && index < (NSInteger)self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}
@end
