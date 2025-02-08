//
//  HMEditPersonalInfoHeaderCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/22.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMEditPersonalInfoHeaderCell.h"

@implementation HMEditPersonalInfoHeaderCell
{
    __weak IBOutlet UILabel *_titleLabel;
}

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.textColor = HMBlackColor;
    _titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    
    _headerImageView.layer.borderColor = HMBorderColor.CGColor;
    _headerImageView.layer.borderWidth = 0.5f;
    _headerImageView.layer.cornerRadius = _headerImageView.size.width / 2.0f;
    
    _headerImageView.clipsToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
