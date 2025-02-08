//
//  HMFeedCommentView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/6/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMFeedModel.h"

@protocol HMFeedCommentViewDelegate <NSObject>

-(void)commentSuccess:(NSString *)commentText userModel:(HMUserModel *)userModel;

@end

@interface HMFeedCommentView : UIView

@property (nonatomic, assign)id<HMFeedCommentViewDelegate>delegate;

+(instancetype)showFeedCommentViewWithDelegate:(id<HMFeedCommentViewDelegate>)delegate feedModel:(HMFeedModel *)feedModel parent_guid:(NSString *)parent_guid userModel:(HMUserModel *)userModel;

@end
