//
//  HMSelectCityViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/15.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@class HMCitiesModel;

@protocol HMSelectCityDelegate <NSObject>

-(void)selectCityWithModel:(HMCitiesModel *)model;

@end

@interface HMSelectCityViewController : HMBaseViewController

@property (nonatomic, assign)id<HMSelectCityDelegate>delegate;


@end
