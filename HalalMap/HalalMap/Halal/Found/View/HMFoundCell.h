//
//  HMFoundCell.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMFoundCell,HMUserModel, HMCommentModel;
@protocol HMFoundCellDelegate <NSObject>

-(void)poiClickWithFoundCell:(HMFoundCell *)foundCell;//poi点击
-(void)foundCell:(HMFoundCell *)foundCell userModel:(HMUserModel *)userModel;//点击赞 头像和评论里面的用户信息
-(void)shareBtnClickWithFoundCell:(HMFoundCell *)foundCell;//分享
-(void)reportBtnClickWithFoundCell:(HMFoundCell *)foundCell;//举报
-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell;//回复
-(void)voteBtnClickWithFoundCell:(HMFoundCell *)foundCell;//点赞
-(void)returnBtnClickWithFoundCell:(HMFoundCell *)foundCell userModel:(HMUserModel *)userModel commentModel:(HMCommentModel *)commentModel;//回复

@end

@interface HMFoundCell : UITableViewCell

@property (nonatomic, assign) id<HMFoundCellDelegate>delegate;

-(void)configureCellWithModel:(id)model;

@end
