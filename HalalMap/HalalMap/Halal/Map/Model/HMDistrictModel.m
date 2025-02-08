//
//  HMDistrictModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/11/15.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMDistrictModel.h"

@implementation HMDistrictModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"businessAreas" : [HMBusinessAreaModel class]
             };
}

@end


@implementation HMBusinessAreaModel


@end