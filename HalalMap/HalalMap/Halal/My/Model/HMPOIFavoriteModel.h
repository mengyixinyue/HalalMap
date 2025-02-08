//
//  HMPOIFavoriteModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMPOIModel.h"

@interface HMPOIFavoriteModel : NSObject

@property (nonatomic, copy)NSString * favorite_guid;
@property (nonatomic, strong) HMPOIModel * favorite_entity;

@end
