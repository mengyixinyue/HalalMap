//
//  HMPOICommentViewController.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBaseViewController.h"

@protocol HMPOICommentViewControllerDelegate <NSObject>

-(void)commentSuccess;

@end

@interface HMPOICommentViewController : HMBaseViewController

@property (nonatomic, copy) NSString * poi_guid;
@property (nonatomic, assign) id<HMPOICommentViewControllerDelegate>delegate;

@end
