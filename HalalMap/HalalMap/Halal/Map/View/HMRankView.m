//
//  HDFRankView.m
//  newDoctor
//
//  Created by  on 15/9/18.
//  Copyright © 2015年 . All rights reserved.
//

#import "HMRankView.h"

#define HMRankViewMiddleWidth      (15)
#define HMRankViewSmallWidth       (11)
#define HMRankViewBigWidth         (28)
#define HMRankViewHorizonPadding   (5)

@implementation HMRankView
{
    HMRankViewType _type;
}

-(id)initWithType:(HMRankViewType)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    switch (_type) {
        case HMRankViewTypeSmall:
        {
            for (int i = 0; i < 5; i ++) {
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (HMRankViewSmallWidth + HMRankViewHorizonPadding), 0, HMRankViewSmallWidth, HMRankViewSmallWidth)];
                imageView.image = [UIImage imageNamed:@"samllStar_empty.png"];
                imageView.tag = i + 100;
                [self addSubview:imageView];
            }
        }
            break;
        case HMRankViewTypeMiddle:
        {
            for (int i = 0; i < 5; i ++) {
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (HMRankViewMiddleWidth + HMRankViewHorizonPadding), 0, HMRankViewMiddleWidth, HMRankViewMiddleWidth)];
                imageView.image = [UIImage imageNamed:@"empty_star.png"];
                imageView.tag = i + 100;
                [self addSubview:imageView];
            }
        }
            break;
        case HMRankViewTypeBig:
        {
            for (int i = 0; i < 5; i ++) {
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (HMRankViewBigWidth + HMRankViewHorizonPadding), 0, HMRankViewBigWidth, HMRankViewBigWidth)];
                imageView.image = [UIImage imageNamed:@"bigStar_empty.png"];
                imageView.tag = i + 100;
                [self addSubview:imageView];
            }
        }
            break;
        default:
            break;
    }
}

-(void)configureWithScore:(CGFloat)score
{
    int intScore = (int)score;
    switch (_type) {
        case HMRankViewTypeBig:
        {   CGFloat width = intScore * (HMRankViewBigWidth + HMRankViewHorizonPadding);
            if (score - intScore != 0) {
                width += HMRankViewBigWidth / 2.0f;
            }
            for (UIView * view in self.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView * imageView = (UIImageView *)view;
                    imageView.image = nil;
                    if (imageView.right < width) {
                        imageView.image = [UIImage imageNamed:@"bigStar_full.png"];
                    }
                    else if (imageView.right > width && imageView.left < width){
                        imageView.image = [UIImage imageNamed:@"bigStar_half.png"];
                    }
                    else{
                        imageView.image = [UIImage imageNamed:@"bigStar_empty.png"];
                    }
                }
            }
            
        }
            break;
        case HMRankViewTypeMiddle:
        {
            CGFloat width = intScore * (HMRankViewMiddleWidth + HMRankViewHorizonPadding);
            if (score - intScore != 0) {
                width += HMRankViewMiddleWidth / 2.0f;
            }
            for (UIView * view in self.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView * imageView = (UIImageView *)view;
                    imageView.image = nil;
                    if (imageView.right < width) {
                        imageView.image = [UIImage imageNamed:@"full_star.png"];
                    }
                    else if (imageView.right > width && imageView.left < width){
                        imageView.image = [UIImage imageNamed:@"half_star.png"];
                    }
                    else{
                        imageView.image = [UIImage imageNamed:@"empty_star.png"];
                    }
                }
            }

        }
            break;
        case HMRankViewTypeSmall:
        {
            CGFloat width = intScore * (HMRankViewSmallWidth + HMRankViewHorizonPadding);
            if (score - intScore != 0) {
                width += HMRankViewSmallWidth / 2.0f;
            }
            for (UIView * view in self.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    UIImageView * imageView = (UIImageView *)view;
                    imageView.image = nil;
                    if (imageView.right < width) {
                        imageView.image = [UIImage imageNamed:@"smallStar_full.png"];
                    }
                    else if (imageView.right > width && imageView.left < width){
                        imageView.image = [UIImage imageNamed:@"smallStar_half.png"];
                    }
                    else{
                        imageView.image = [UIImage imageNamed:@"smallStar_empty.png"];
                    }
                }
            }

        }
            break;
        default:
            break;
    }
}

+(CGFloat)widthWithType:(HMRankViewType)type
{
    switch (type) {
        case HMRankViewTypeBig:
        {
            return 4 * (HMRankViewBigWidth + HMRankViewHorizonPadding) + HMRankViewBigWidth;
        }
            break;
        case HMRankViewTypeMiddle:
        {
            return 4 * (HMRankViewMiddleWidth + HMRankViewHorizonPadding) + HMRankViewMiddleWidth;

        }
            break;
        case HMRankViewTypeSmall:
        {
            return 4 * (HMRankViewSmallWidth + HMRankViewHorizonPadding) + HMRankViewSmallWidth;
        }
            break;
        default:
            break;
    }
}

+(CGFloat)heightWithType:(HMRankViewType)type
{
    switch (type) {
        case HMRankViewTypeBig:
        {
            return HMRankViewBigWidth;
        }
            break;
        case HMRankViewTypeMiddle:
        {
            return HMRankViewMiddleWidth;
        }
            break;
        case HMRankViewTypeSmall:
        {
            return HMRankViewSmallWidth;
        }
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
