//
//  HMDistrictModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/11/15.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDistrictModel : NSObject

@property (nonatomic, copy) NSString * district_guid;//区县的唯一标识
@property (nonatomic, copy) NSString * district_name;//区县的名字
@property (nonatomic, strong) NSMutableArray * businessAreas;//商圈

@end

@interface HMBusinessAreaModel : NSObject

@property (nonatomic, copy) NSString * businessArea_guid;//商圈的唯一标识
@property (nonatomic, copy) NSString * businessArea_name;//商圈的名字

@end
