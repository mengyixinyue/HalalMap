//
//  HMSortCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/10/22.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMSortCell.h"

@implementation HMSortCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [HMFontHelper fontOfSize:14.0f];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.textLabel.textColor = HMMainColor;
    }
    else{
        self.textLabel.textColor = HMBlackColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.textLabel.textColor = HMMainColor;
    }
    else{
        self.textLabel.textColor = HMBlackColor;
    }

    // Configure the view for the selected state
}

@end
