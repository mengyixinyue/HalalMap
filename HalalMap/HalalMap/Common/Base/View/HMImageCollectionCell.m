//
//  HMImageCollectionCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/2/21.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMImageCollectionCell.h"

#import "HMPhotoModel.h"

@implementation HMImageCollectionCell
{
    __weak IBOutlet UIView *_myBackgroundView;
}


- (void)awakeFromNib {
    // Initialization code
    _myBackgroundView.layer.borderColor = HMMainColor.CGColor;
    _myBackgroundView.layer.borderWidth = 2.0f;
    _myBackgroundView.hidden = YES;
}

-(void)configureWithModel:(id)model
{
    if ([model isKindOfClass:[HMPhotoModel class]]) {
        HMPhotoModel * photoModel = (HMPhotoModel *)model;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.thumb_url] placeholderImage:nil];
    }
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (self.selected) {
        _myBackgroundView.hidden = NO;
    }
    else{
        _myBackgroundView.hidden = YES;
    }
}

@end
