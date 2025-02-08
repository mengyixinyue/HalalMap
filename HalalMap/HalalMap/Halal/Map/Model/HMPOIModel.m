//
//  HMPOIModel.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/18.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMPOIModel.h"

@implementation HMPOIModel

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
