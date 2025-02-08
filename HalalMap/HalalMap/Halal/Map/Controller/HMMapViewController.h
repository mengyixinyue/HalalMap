//
//  HMMapViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@interface HMMapViewController : HMBaseViewController

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) BOOL canGoForward;

-(void)setDataArray:(NSMutableArray *)dataArray needRemoveOldData:(BOOL)isNeedRemoveOldData;
-(void)updateLocationAddress:(HMAddressModel *)addressModel;

@end
