//
//  HMEditPersonalInfoCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/22.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMEditPersonalInfoCell.h"

@implementation HMEditPersonalInfoCell
{
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_contentLabel;
}

- (void)awakeFromNib {
    // Initialization code
    
    _titleLabel.font = [HMFontHelper fontOfSize:16.0f];
    _titleLabel.textColor = HMBlackColor;
    
    _contentLabel.font = [HMFontHelper fontOfSize:16.0f];
    _contentLabel.textColor = HMGrayColor;
}

-(void)configureWithTitle:(NSString *)title content:(NSString *)content
{
    _titleLabel.text = @"";
    _contentLabel.text = @"";
    _titleLabel.text = title;
    _contentLabel.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
