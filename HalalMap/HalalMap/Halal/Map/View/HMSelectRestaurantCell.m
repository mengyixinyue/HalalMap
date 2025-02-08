//
//  HMSelectRestaurantCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/20.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectRestaurantCell.h"
#import "HMSelectRestaurantModel.h"

@implementation HMSelectRestaurantCell
{
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UIView *_bottomView;
    
}

- (void)awakeFromNib {
    // Initialization code
    _nameLabel.textColor = HMBlackColor;
    _nameLabel.font = [HMFontHelper fontOfSize:16.0f];
    _addressLabel.textColor = HMGrayColor;
    _addressLabel.font = [HMFontHelper fontOfSize:12.0f];
    _bottomView.backgroundColor = HMSeperatorColor;
}

-(void)configureWithModel:(id)model isLast:(BOOL)isLast
{
    if ([model isKindOfClass:[HMSelectRestaurantModel class]]) {
        HMSelectRestaurantModel * restaurantModel = (HMSelectRestaurantModel *)model;
        _nameLabel.text = restaurantModel.poi_name;
        _addressLabel.text = restaurantModel.poi_address;
        _bottomView.hidden = isLast;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
