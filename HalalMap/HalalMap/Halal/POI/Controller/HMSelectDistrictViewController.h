//
//  HMSelectDistrictViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/21.
//  Copyright © 2016年 halalMap. All rights reserved.
//  选择区域或商圈
//

#import "HMBaseViewController.h"
#import "HMDistrictModel.h"

@protocol HMSelectDistrictViewControllerDelegate <NSObject>

-(void)selectDistrictWithDistrictModel:(HMDistrictModel *)districtModel businessModel:(HMBusinessAreaModel *)businessModel;

@end

@interface HMSelectDistrictViewController : HMBaseViewController

@property (nonatomic, assign)id<HMSelectDistrictViewControllerDelegate>delegate;

@end
