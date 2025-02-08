//
//  HMLocationManager.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/11.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMLocationManager : NSObject

+(HMLocationManager *)sharedLocationManager;

-(void)getCurrentLocationwithSuccess:(void (^)(HMAddressModel *addressModel))success fail:(void (^)(NSError *error, CLLocation *location))faile;

@end
