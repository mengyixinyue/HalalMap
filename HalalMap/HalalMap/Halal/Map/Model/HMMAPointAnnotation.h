//
//  HMMAPointAnnotation.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/20.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HMPOIModel.h"

@interface HMMAPointAnnotation : MAPointAnnotation

- (id)initWithIdentifier:(NSString *)identifier name:(NSString *)name address:(NSString *)address score:(NSString *)score isShowWin:(BOOL)isShowWin model:(HMPOIModel *)model;

/**
 *  标识
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  地址
 */
@property (nonatomic, copy) NSString * address;

/**
 *  等级
 */
@property (nonatomic, copy) NSString * score;

/**
 *  是否展示酒
 */
@property (nonatomic, assign) BOOL isShowWin;

@property (nonatomic, strong) HMPOIModel * model;

@end
