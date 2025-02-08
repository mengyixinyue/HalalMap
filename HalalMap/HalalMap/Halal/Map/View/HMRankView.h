//
//  HDFRankView.h
//  newDoctor
//
//  Created by  on 15/9/18.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HMRankViewTypeSmall,
    HMRankViewTypeMiddle,
    HMRankViewTypeBig,
} HMRankViewType;

@interface HMRankView : UIView

-(id)initWithType:(HMRankViewType)type;

-(void)configureWithScore:(CGFloat)score;
+(CGFloat)widthWithType:(HMRankViewType)type;
+(CGFloat)heightWithType:(HMRankViewType)type;

@end
