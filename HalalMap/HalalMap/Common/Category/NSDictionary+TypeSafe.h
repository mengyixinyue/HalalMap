//
//  NSDictionary+TypeSafe.h
//  doctor
//
//  Created by zhaojunwei on 9/4/14.
//  Copyright (c) 2014 luodan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (TypeSafe)


/**
 *  通过key值取对应value值
 *
 *  @param aKey key值
 *
 *  @return 若对应value值为NSString或NSNumber 返回NSString  否则返回nil
 */
- (NSString *)stringForKey:(id)aKey;

/**
 *  通过key值取对应value值
 *
 *  @param aKey key值
 *
 *  @return 若对应value值为数组 返回数组  否则返回nil
 */
- (NSArray *)arrayForKey:(id)aKey;

/**
 *  通过key值取对应value值
 *
 *  @param aKey key值
 *
 *  @return 若对应value值为字典 返回字典  否则返回nil
 */
- (NSDictionary *)dictionaryForKey:(id)aKey;

/**
 *  通过key值取对应value值
 *
 *  @param aKey key值
 *
 *  @return 若对应value值为NSInteger类型 返回值  否则返回0
 */
- (NSInteger)integerForKey:(id)aKey;

/**
 *  通过key值取对应value值
 *
 *  @param aKey key值
 *
 *  @return 若对应value值为CGFloat类型 返回值  否则返回0
 */
- (CGFloat)floatForKey:(id)aKey;

/**
 *  通过key值取对应value值
 *
 *  @param aKey key值
 *
 *  @return 若对应value值为BOOL类型 返回值 若为NSInteger只要不为0 返回1 否则返回0
 */
- (BOOL)boolForKey:(id)aKey;

@end
