//
//  HMCommentModel.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/26.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMUserModel.h"

@interface HMCommentModel : NSObject

@property (nonatomic, copy) NSString * comment_guid;//comment唯一标识
@property (nonatomic, copy) NSString * created_at;//创建时间，eg：“1457589727”
@property (nonatomic, copy) NSString * comment;//comment的内容，长度为1到1500个字符
@property (nonatomic, copy) NSString * stars;//评分，0到5的整数
@property (nonatomic, strong) HMUserModel * comment_user;//User 评论者

@property (nonatomic, copy) NSString * parent_guid;//父评论的id（即回复的那条评论的id）
@property (nonatomic, strong) HMUserModel * parent_comment_user;//被回复的人

//@property (nonatomic, assign) BOOL  canFold;     //能否展开
//@property (nonatomic, assign) BOOL  isFold;      //是否展开
//@property (nonatomic, assign) CGPoint contentOffset;

+(CGFloat)heightWithFiveLinew;

+(CGFloat)heightWithComment:(NSString *)comment;


@end
