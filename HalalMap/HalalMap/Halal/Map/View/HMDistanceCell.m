//
//  HMDiseaseNameCell.m
//  newPatient
//
//  Created by  on 15/8/21.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "HMDistanceCell.h"

#import "HMDistrictModel.h"

#define kHMDiseaseFilterCellHorizonMargin   (25)

@implementation HMDistanceCell
{
    UILabel         * _titleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
        self.contentView.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHMDiseaseFilterCellHorizonMargin, 0, self.width - 2 * kHMDiseaseFilterCellHorizonMargin, self.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = HMBlackColor;
        _titleLabel.font = [HMFontHelper fontOfSize:14.0f];
        [self.contentView addSubview:_titleLabel];
    }
}

- (void)configureWithModel:(id)model
{
    if ([model isKindOfClass: [HMDistrictModel class]]) {
        HMDistrictModel * districtModel = (HMDistrictModel *)model;
        _titleLabel.text = districtModel.district_name;
    }
}

+ (CGFloat)height
{
    return 45;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(kHMDiseaseFilterCellHorizonMargin, 0, self.width - 2 * kHMDiseaseFilterCellHorizonMargin, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else{
        self.contentView.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
    }
}


@end
