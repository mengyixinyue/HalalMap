//
//  HMMAAnnotation.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/20.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMPOIModel;
@protocol HMMAAnnotation <NSObject>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

/**
 *  名字
 */
@property (nonatomic, readonly, copy) NSString * name;

/**
 *  地址
 */
@property (nonatomic, readonly, copy) NSString * address;

/**
 *  评分
 */
@property (nonatomic, readonly, copy) NSString * score;

/**
 *  是否展示酒
 */
@property (nonatomic, readonly, assign) BOOL isShowWin;

@property (nonatomic, readonly, strong) HMPOIModel * model;

@end
