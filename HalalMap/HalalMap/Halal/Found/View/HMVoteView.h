//
//  HMVoteView.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//
//点赞

#import <UIKit/UIKit.h>
#import "HMVoteModel.h"

@protocol HMVoteViewDelegate <NSObject>

-(void)voteViewWithClickVoterWithUser:(HMUserModel *)user;

@end

@interface HMVoteView : UIView

@property(nonatomic, strong)YYLabel * textLabel;
@property (nonatomic, assign) id<HMVoteViewDelegate>delegate;

-(void)configureWithArray:(NSArray *)votesArray;

@end
