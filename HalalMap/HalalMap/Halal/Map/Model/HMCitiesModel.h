//
//  HMCitiesModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/17.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCitiesModel : NSObject

@property (nonatomic, copy) NSString * city_guid;//城市的唯一标识
@property (nonatomic, copy) NSString * city_name;//城市的名字
@property (nonatomic, copy) NSString * city_name_pinyin;//城市名字的拼音
@property (nonatomic, copy) NSString * city_short_name;//城市名字的缩写

@end
