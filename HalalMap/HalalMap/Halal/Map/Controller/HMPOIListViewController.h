//
//  HMPOIListViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/10.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@interface HMPOIListViewController : HMBaseViewController

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) BOOL canLoadMore;

@end
