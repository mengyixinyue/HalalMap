//
//  HMSelectAddressViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/16.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"
#import "HMAddressModel.h"

@protocol HMSelectAddressViewControllerDelegate <NSObject>

-(void)selectAddressWithAddressModel:(HMAddressModel *)addressModel;

@end

@interface HMSelectAddressViewController : HMBaseViewController

@property (nonatomic, assign) id<HMSelectAddressViewControllerDelegate>delegate;

@end
