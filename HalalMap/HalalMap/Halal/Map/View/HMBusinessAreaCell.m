//
//  HMBusinessAreaCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMBusinessAreaCell.h"
#import "HMDistrictModel.h"

@implementation HMBusinessAreaCell
{
    __weak IBOutlet UILabel *_businessAreaLabel;
    __weak IBOutlet UIView *_bottomLineView;
}

- (void)awakeFromNib {
    // Initialization code
    _businessAreaLabel.font = [HMFontHelper fontOfSize:16.0f];
}

- (void)configureWithModel:(id)model
{
    if ([model isKindOfClass: [HMBusinessAreaModel class]]) {
        HMBusinessAreaModel * businessModel = (HMBusinessAreaModel *)model;
        _businessAreaLabel.text = businessModel.businessArea_name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _businessAreaLabel.textColor = HMMainColor;
    }
    else{
        _businessAreaLabel.textColor = HMGrayColor;
    }
}


@end
