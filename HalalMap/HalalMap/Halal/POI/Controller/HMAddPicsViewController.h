//
//  HMAddPicsViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/19.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@protocol HMAddPicsViewControllerDelegate <NSObject>

-(void)reflashPicList;

@end

@interface HMAddPicsViewController : HMBaseViewController

@property (nonatomic, copy) NSString * poi_guid;

@property (nonatomic, assign)id<HMAddPicsViewControllerDelegate>delegate;

@end
