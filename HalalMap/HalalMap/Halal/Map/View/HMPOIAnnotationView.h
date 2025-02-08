//
//  HMPOIAnnotationView.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/18.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "HMPOICalloutView.h"

#import "HMMAAnnotation.h"

@class HMPOIAnnotationView;
@protocol HMPOIAnnotationViewDelegate <NSObject>

-(void)calloutViewClick:(HMPOICalloutView *)calloutView annotationView:(HMPOIAnnotationView *)annotationView;

@end

@interface HMPOIAnnotationView : MAAnnotationView

@property (nonatomic, readonly) HMPOICalloutView *calloutView;

@property (nonatomic, strong) id <HMMAAnnotation> hmAnnotation;

@property (nonatomic, assign) id<HMPOIAnnotationViewDelegate>clickDelegate;


- (id)initWithAnnotation:(id <HMMAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
