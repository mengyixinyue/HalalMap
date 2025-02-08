//
//  HMFeedInputView.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/6/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMFeedInputViewDelegate <NSObject>

-(void)inputMessageViewChangeHeight:(CGFloat)height;
- (void)sendMessageWithText:(NSString *)text;

@end

@interface HMFeedInputView : UIView

@property (nonatomic, assign)id<HMFeedInputViewDelegate>delegate;

+(instancetype)showFeedInputViewWithDelegate:(id<HMFeedInputViewDelegate>)delegate;

@end
