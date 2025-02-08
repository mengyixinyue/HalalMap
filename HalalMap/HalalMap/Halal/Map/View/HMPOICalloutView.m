//
//  HMPOICalloutView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/18.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMPOICalloutView.h"
#import "HMStarView.h"

#define kArrorHeight        (10)

#define kPortraitMargin     (5)
#define kPortraitWidth      (70)
#define kPortraitHeight     (50)

#define kTitleWidth         (120)
#define kTitleHeight        (20)

@interface HMPOICalloutView ()

@end

@implementation HMPOICalloutView
{
    __weak IBOutlet UIImageView         *_wineImageView;//酒杯
    __weak IBOutlet UIView              *_starBackgroundView;//等级
    __weak IBOutlet UILabel             *_addressLabel;//地址
    __weak IBOutlet UILabel             *_nameLabel;//名字
    __weak IBOutlet NSLayoutConstraint  *_starBgViewHeighConstraint;
    __weak IBOutlet NSLayoutConstraint  *_starBgViewWidthConstraint;
    HMStarView                          * _starView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
}

- (void)initSubViews
{
    _starView = [HMHelper xibWithClass:[HMStarView class]];
    _starView.frame = CGRectMake(0, 0, _starView.width, _starView.height);
    [_starBackgroundView addSubview:_starView];
    _starBgViewWidthConstraint.constant = [_starView width];
    _starBgViewHeighConstraint.constant = [_starView height];
    _starBackgroundView.bounds = CGRectMake(0, 0, _starView.width, _starView.height);
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

- (void)setAddress:(NSString *)address
{
    _addressLabel.text = address;
}

- (void)setIsShowWin:(BOOL)isShowWin
{
    _wineImageView.hidden = !isShowWin;
}

-(void)setScore:(NSString *)score
{
    [_starView configureWithScore:[score floatValue]];
}

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.borderColor = HMBorderColor.CGColor;
    self.layer.borderWidth = 0.5f;
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0f alpha:0.8f].CGColor);
    
//    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
