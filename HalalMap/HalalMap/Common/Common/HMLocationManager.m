//
//  HMLocationManager.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/11.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface HMLocationManager ()
@property (nonatomic, strong) AMapLocationManager * locationManager;
@end

@implementation HMLocationManager

+ (id)sharedLocationManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

-(AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}

-(void)getCurrentLocationwithSuccess:(void (^)(HMAddressModel *addressModel))success fail:(void (^)(NSError *error, CLLocation *location))faile
{
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (faile) {
                faile(error, location);
            }
        }
        else{
            [HMHelper getCityWithLon:[NSString stringWithFormat:@"%f", location.coordinate.longitude] lat:[NSString stringWithFormat:@"%f", location.coordinate.latitude] success:^(HMAddressModel *model) {
                if (success) {
                    success(model);
                }
            } faile:^(NSString *errorMsg) {
                if (faile) {
                    faile(error, location);
                }
            }];
        }
    }];
}

@end
