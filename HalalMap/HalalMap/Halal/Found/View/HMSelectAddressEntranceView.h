//
//  HMSelectAddressEntranceView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/13.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMSelectAddressEntranceView;
@protocol HMSelectAddressEntranceViewDelegate <NSObject>

-(void)selectAddressEntranceView:(HMSelectAddressEntranceView *)entranceView;

@end

@interface HMSelectAddressEntranceView : UIView

@property (nonatomic, assign) id<HMSelectAddressEntranceViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *selectedRestaurantLabel;

@end
