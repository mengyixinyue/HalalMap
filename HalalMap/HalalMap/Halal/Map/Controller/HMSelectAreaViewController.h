//
//  HDFDiseaseFilterTableViewController.h
//  newPatient
//
//  Created by  on 15/8/21.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "HMBaseViewController.h"

typedef enum : NSUInteger {
    CategoryTypeArea = 1,
    CategoryTypeSort = 2,
} CategoryType;

@interface HMSelectAreaViewController : HMBaseViewController

-(id)initWithType:(CategoryType)categoryType;

@end
