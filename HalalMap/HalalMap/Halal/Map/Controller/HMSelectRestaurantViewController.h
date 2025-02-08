//
//  HMSelectRestaurantViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/19.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@class HMSelectRestaurantModel;
@protocol HMSelectRestaurantViewControllerDelegate <NSObject>

-(void)selectRestaurantWithModel:(HMSelectRestaurantModel *)restaurantModel;

@end

@interface HMSelectRestaurantViewController : HMBaseViewController

@property (nonatomic, assign) id<HMSelectRestaurantViewControllerDelegate>delegate;


@end
