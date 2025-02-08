//
//  HMPOIAnnotationView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/18.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMPOIAnnotationView.h"

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

@interface HMPOIAnnotationView ()
<
UIGestureRecognizerDelegate
>

@property (nonatomic, strong, readwrite) HMPOICalloutView *calloutView;

@end

@implementation HMPOIAnnotationView

- (id)initWithAnnotation:(id <HMMAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.hmAnnotation = annotation;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            
            NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"HMPOICalloutView" owner:nil options:nil];
            
            self.calloutView = (HMPOICalloutView *)array[0];
                        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.name = self.hmAnnotation.name;
        self.calloutView.address = self.hmAnnotation.address;
        self.calloutView.isShowWin = self.hmAnnotation.isShowWin;
        self.calloutView.score = self.hmAnnotation.score;
        self.calloutView.model = self.hmAnnotation.model;
        
        
        [self addSubview:self.calloutView];
        self.calloutView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCalloutSelected:)];
        [self.calloutView addGestureRecognizer:tap];

    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}


-(void)tapCalloutSelected:(UITapGestureRecognizer *)tap
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(calloutViewClick:annotationView:)]) {
        [self.clickDelegate calloutViewClick:self.calloutView annotationView:self];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *v in self.subviews) {
        if (!v.hidden && CGRectContainsPoint(v.frame, point)) {
            return YES;
        }
    }
    if (CGRectContainsPoint(self.bounds, point)) {
        return YES;
    }
    return NO;
}

@end
