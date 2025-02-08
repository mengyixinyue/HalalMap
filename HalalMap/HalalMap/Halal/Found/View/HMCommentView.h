//
//  HMCommentView.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//
//评论

#import <UIKit/UIKit.h>
#import "HMCommentModel.h"

@class HMCommentView;
@protocol HMCommentViewDelegte <NSObject>

-(void)clickUserWithCommentView:(HMCommentView *)commentView user:(HMUserModel *)userModel;
-(void)clickCommentWithCommentView:(HMCommentView *)commentView user:(HMUserModel *)userModel commentModel:(HMCommentModel *)commentModel;

@end

@interface HMCommentView : UIView

@property (nonatomic, assign)id<HMCommentViewDelegte>delegate;

-(void)configureWithCommentArray:(NSArray *)commentArray;

@end
