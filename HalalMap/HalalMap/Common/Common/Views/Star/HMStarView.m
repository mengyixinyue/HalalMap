//
//  HMStarView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/23.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMStarView.h"

@implementation HMStarView
{
    __weak IBOutlet UIImageView *_star1;
    __weak IBOutlet UIImageView *_star2;
    __weak IBOutlet UIImageView *_star3;
    __weak IBOutlet UIImageView *_star4;
    __weak IBOutlet UIImageView *_star5;
    __weak IBOutlet NSLayoutConstraint *_starWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_starHeightConstaint;
    __weak IBOutlet NSLayoutConstraint *_star1With2HorizonConstraint;
    __weak IBOutlet NSLayoutConstraint *_star2With3HorizonConstraint;
    __weak IBOutlet NSLayoutConstraint *_star3With4HorizonConstraint;
    __weak IBOutlet NSLayoutConstraint *_star4With5HorizonConstraint;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)configureWithScore:(CGFloat)score
{
    for (UIImageView * imageView in self.subviews) {
        if (imageView.tag <= score) {
            [imageView setImage:[UIImage imageNamed:@"full_star"]];
        }
        else
        {
            if (imageView.tag - score < 1) {
                if (imageView.tag - score <= 0.5) {
                    [imageView setImage:[UIImage imageNamed:@"full_star"]];
                }
                else{
                    [imageView setImage:[UIImage imageNamed:@"half_star"]];
                }
            }
            else{
                [imageView setImage:[UIImage imageNamed:@"empty_star"]];
            }
        }
    }
}

-(CGFloat)height
{
    return _star1.height;
}

-(CGFloat)width
{
    return _star5.right;
}

@end
