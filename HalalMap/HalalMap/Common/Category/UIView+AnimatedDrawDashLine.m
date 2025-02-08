//
//  UIView+AnimatedDrawDashLine.m
//  BSValueUniversal
//
//  Created by 张超毅 on 14-9-15.
//
//

#import "UIView+AnimatedDrawDashLine.h"
#import <objc/runtime.h>

#define kLineDuration       1
#define kLineColor          [UIColor blueColor]
#define kLineWidth          1


const char animationCompletionHandlerKey;

@interface ShapeView : UIView

@property (nonatomic, readonly) CAShapeLayer *shapeLayer;
@end

@implementation ShapeView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

@end

@implementation UIView (AnimatedDrawDashLine)

- (void)animatedDefaultDrawDashLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint completion:(AnimationCompletionBlock)completion
{
    [self animatedDrawDashLineFromPoint:fromPoint toPoint:toPoint duration:kLineDuration withLineColor:kLineColor lineWidth:kLineWidth completion:completion];
}

- (void)animatedDrawDashLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint duration:(CGFloat)duration withLineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth completion:(AnimationCompletionBlock)completion
{
    //添加path的UIView
    ShapeView  *pathShapeView = [[ShapeView alloc] init];
    pathShapeView.backgroundColor = [UIColor clearColor];
    pathShapeView.opaque = NO;
    pathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
    pathShapeView.shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20], [NSNumber numberWithInt:10], [NSNumber numberWithInt:10], [NSNumber numberWithInt:2], nil ,nil];
    //shapeLayer.lineDashPhase = 15;
    pathShapeView.shapeLayer.lineDashPattern = @[[NSNumber numberWithFloat:3],[NSNumber numberWithFloat:3]];
    pathShapeView.shapeLayer.lineJoin = kCALineJoinBevel;
    [self addSubview:pathShapeView];
    
    pathShapeView.shapeLayer.fillColor = nil;
    pathShapeView.shapeLayer.strokeColor = lineColor.CGColor;
    
    //创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    animation.duration = duration;
    [pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    objc_setAssociatedObject(self, &animationCompletionHandlerKey,completion , OBJC_ASSOCIATION_COPY);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:fromPoint];
    [path addLineToPoint:toPoint];
    
    
    path.usesEvenOddFillRule = YES;
    pathShapeView.shapeLayer.path = path.CGPath;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    AnimationCompletionBlock theCompletion = objc_getAssociatedObject(self, &animationCompletionHandlerKey);
    if (theCompletion && flag == YES) {
        theCompletion(anim,flag);
    }
    
}

@end


