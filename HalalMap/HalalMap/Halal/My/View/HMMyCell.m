//
//  HMMyCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/20.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMMyCell.h"

@implementation HMMyCell
{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet NSLayoutConstraint *_imageHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_imageWidthConstraint;
    __weak IBOutlet UIView *_bottomLine;
    __weak IBOutlet UILabel *_countLabel;
    __weak IBOutlet NSLayoutConstraint *_countLabelWidthConstraint;
}

- (void)awakeFromNib {
    _titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    _countLabel.layer.cornerRadius = _countLabel.height / 2.0f;
    _countLabel.clipsToBounds = YES;
    _countLabel.font = [HMFontHelper fontOfSize:16.0f];
}


-(void)configureWithTitle:(NSString *)title imageName:(NSString *)imageName isLastCell:(BOOL)isLastCell messageCount:(NSString *)messageCount
{
    _titleLabel.text = title;
    UIImage * image = [UIImage imageNamed:imageName];
    _imageView.image = image;
    _imageWidthConstraint.constant = image.size.width;
    _imageHeightConstraint.constant = image.size.height;
    _bottomLine.hidden = isLastCell;
    
    _countLabel.hidden = YES;
    if (messageCount && messageCount.length != 0) {
        _countLabel.text = messageCount;
        _countLabel.hidden = NO;
        CGFloat width = [_countLabel.text sizeAutoFitIOS7WithFont:_countLabel.font].width;
        width = width < 20 ? 22 : (width + 22);
        _countLabelWidthConstraint.constant = width;
        [_countLabel layoutIfNeeded];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
