//
//  UIView+AnimatedDrawDashLine.h
//  BSValueUniversal
//
//  Created by 张超毅 on 14-9-15.
//
//

#import <UIKit/UIKit.h>

typedef void (^AnimationCompletionBlock)(CAAnimation* anim, BOOL error);


@interface UIView (AnimatedDrawDashLine)

- (void)animatedDefaultDrawDashLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint completion:(AnimationCompletionBlock)completion;

- (void)animatedDrawDashLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint duration:(CGFloat)duration withLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth completion:(AnimationCompletionBlock)completion;

@end
