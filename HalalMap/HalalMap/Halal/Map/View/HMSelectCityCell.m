//
//  HMSelectCityCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/16.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectCityCell.h"

@interface HMSelectCityCell ()
{
    __weak IBOutlet UILabel *_label;
    __weak IBOutlet UIView *_bottomLine;
}

@end

@implementation HMSelectCityCell

- (void)awakeFromNib {
    // Initialization code
    _label.font = [HMFontHelper fontOfSize:16.0f];
}

-(void)congfigureWithTitle:(NSString *)title isHideBottomLine:(BOOL)hideBottomLine
{
    _label.text = title;
    _bottomLine.hidden = hideBottomLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
