//
//  HMSelectAddressView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSelectAddressView;
@protocol HMSelectAddressViewDelegate <NSObject>

-(void)selectAddressView:(HMSelectAddressView *)selectAddressView isSelectedRestaurant:(BOOL)isSelectedRestaurant;

@end

@interface HMSelectAddressView : UIView

@property (nonatomic, assign) id<HMSelectAddressViewDelegate> delegate;

@end
