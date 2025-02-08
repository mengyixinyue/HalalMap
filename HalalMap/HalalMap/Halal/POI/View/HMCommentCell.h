//
//  HMCommentCell.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/25.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMCommentCell;
@protocol HMCommentCellDelegate <NSObject>

-(void)clickHeaderImageViewWithCommentCell:(HMCommentCell *)cell;

@end

//IB_DESIGNABLE
@interface HMCommentCell : UITableViewCell

@property (nonatomic, weak) id<HMCommentCellDelegate>delegate;

-(void)configureWithModel:(id)model;
//-(CGFloat)height;

@end
