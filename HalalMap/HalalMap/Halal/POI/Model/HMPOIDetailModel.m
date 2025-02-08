//
//  HMPOIDetailModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOIDetailModel.h"
#import "HMCommentModel.h"
#import "HMPhotoModel.h"

@implementation HMPOIDetailModel


+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"poi_photos" : [HMPhotoModel class],
             @"comments" : [HMCommentModel class]
             };
}


-(CLLocationCoordinate2D)getLocationCoordinate2D
{
    CLLocationCoordinate2D location;
    location.latitude = [_poi_lat floatValue];
    location.longitude = [_poi_lon floatValue];
    return location;
    
}


@end
