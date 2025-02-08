//
//  HMAddressModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/14.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMCitiesModel.h"

@interface HMAddressModel : NSObject

@property (nonatomic, strong) HMCitiesModel * city;
@property (nonatomic, copy) NSString * address;

@property (nonatomic, copy) NSString * lon;
@property (nonatomic, copy) NSString * lat;

@end
