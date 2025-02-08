//
//  HMPOITableViewCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/30.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOITableViewCell.h"
#import "HMStarView.h"
#import "HMPOIModel.h"

@implementation HMPOITableViewCell
{
    __weak IBOutlet UIImageView * _poiImageView;
    __weak IBOutlet UILabel     * _nameLabel;
    __weak IBOutlet UIView      * _starBackgroundView;

    __weak IBOutlet UIImageView * _drinkImageView;
    __weak IBOutlet UILabel     * _addressLabel;

    __weak IBOutlet UILabel     * _distanceLabel;
    HMStarView                  * _starView;
    __weak IBOutlet NSLayoutConstraint *_starBgViewWidthConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_starBgViewHeighConstraint;
    __weak IBOutlet NSLayoutConstraint *_distanceWidthConstraint;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _poiImageView.layer.borderColor = HMBorderColor.CGColor;
    _poiImageView.layer.borderWidth = 0.5f;
    
    _nameLabel.font = [HMFontHelper fontOfSize:16.0f];
    _addressLabel.font =
    _distanceLabel.font =
    [HMFontHelper fontOfSize:12.0f];
    
    _starView = [HMHelper xibWithClass:[HMStarView class]];
    _starView.frame = CGRectMake(0, 0, _starView.width, _starView.height);
    [_starBackgroundView addSubview:_starView];
    _starBgViewWidthConstraint.constant = [_starView width];
    _starBgViewHeighConstraint.constant = [_starView height];
    _starBackgroundView.bounds = CGRectMake(0, 0, _starView.width, _starView.height);
    
}

-(void)configureWithModel:(id)model isShowDistance:(BOOL)isShowDistance
{
    if ([model isKindOfClass:[HMPOIModel class]]) {
        HMPOIModel * poiModel = (HMPOIModel *)model;
        [_poiImageView sd_setImageWithURL:[NSURL URLWithString:poiModel.poi_photo.thumb_url]];
        _nameLabel.text = poiModel.poi_name;
        _addressLabel.text = poiModel.poi_address;
        if (isShowDistance) {
            CGFloat distance = [poiModel.poi_distance floatValue];
            NSString * distanceStr;
            if (distance / 1000.0f > 1) {
                distance = distance / 100.0f;
                distanceStr = [NSString stringWithFormat:@"%.2fkm", distance];
            }
            else{
                distanceStr = [NSString stringWithFormat:@"%.fm", distance];
            }
            _distanceLabel.text = distanceStr;
            _distanceLabel.hidden = NO;
        }
        else{
            _distanceLabel.hidden = YES;
            _distanceLabel.text = @"";
        }
        [_starView configureWithScore:[poiModel.poi_stars floatValue]];
        CGSize size = [_distanceLabel.text sizeAutoFitIOS7WithFont:_distanceLabel.font];
        _distanceWidthConstraint.constant = size.width;
        [self.contentView layoutIfNeeded];
    }
}

@end
