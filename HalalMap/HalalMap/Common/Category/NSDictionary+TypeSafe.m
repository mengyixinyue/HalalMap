//
//  NSDictionary+TypeSafe.m
//  doctor
//
//  Created by zhaojunwei on 9/4/14.
//  Copyright (c) 2014 luodan.com. All rights reserved.
//

#import "NSDictionary+TypeSafe.h"

@implementation NSDictionary (TypeSafe)

- (id)objectForKey:(id)aKey ofClass:(Class)aClass {
    id value = [self objectForKey:aKey]; 
    
    if (![value isKindOfClass:aClass]) {
        value = nil;
    }
    
    return value;
}

- (NSString *)stringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if([value isKindOfClass:[NSNumber class]]){
        return  [((NSNumber *)value) stringValue];
    }else{
        return [self objectForKey:aKey ofClass:[NSString class]];
    }
    
}

- (NSArray *)arrayForKey:(id)aKey
{
    return [self objectForKey:aKey ofClass:[NSArray class]];
}

- (NSDictionary *)dictionaryForKey:(id)aKey
{
    return [self objectForKey:aKey ofClass:[NSDictionary class]];
}

- (NSInteger)integerForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    else {
        return 0;
    }
}

- (CGFloat)floatForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    }
    else {
        return 0;
    }
}

- (BOOL)boolForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    }
    else if ([object respondsToSelector:@selector(integerValue)]) {
        return ([object integerValue] != 0);
    }
    else {
        return 0;
    }
}

@end
