//
//  HMUserFeedViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"
#import "ARSegmentPageController.h"

@interface HMUserFeedViewController : HMBaseViewController
<
ARSegmentControllerDelegate
>
@property (nonatomic, copy) NSString * user_unique_key;

@end
