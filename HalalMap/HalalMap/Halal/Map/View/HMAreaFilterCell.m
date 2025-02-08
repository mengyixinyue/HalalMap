//
//  HDFDiseaseFilterCell.m
//  newPatient
//
//  Created by  on 15/8/21.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "HMAreaFilterCell.h"

#define kHDFDiseaseFilterCellHorizonMargin      (15)
#define HMLeftTableWidth                       (116)

@implementation HMAreaFilterCell
{
    UILabel * _label;
    UIView  * _lineView;
    UIView  * _vertiaclLineView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kHDFDiseaseFilterCellHorizonMargin, 0, self.width -  2 * kHDFDiseaseFilterCellHorizonMargin, self.height)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = HMBlackColor;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [HMFontHelper fontOfSize:14.0f];
        [self.contentView addSubview:_label];
    }
    
//    if (!_lineView) {
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, HMLeftTableWidth, 1)];
//        _lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        _lineView.backgroundColor = HMSeperatorColor;
//        [self.contentView addSubview:_lineView];
//        
//        _vertiaclLineView = [[UIView alloc] initWithFrame:CGRectMake(HMLeftTableWidth - 1, 0, 1, self.height)];
//        _vertiaclLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        _vertiaclLineView.backgroundColor = HMSeperatorColor;
//        [self.contentView addSubview:_vertiaclLineView];
//    }
    self.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
    self.contentView.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
    
}

- (void)configureWithModel:(id)model
{
    _label.text = @"运动一族";
  
    
}

+ (CGFloat)height
{
    return 45;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
//    _lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    _vertiaclLineView.frame = CGRectMake(self.width - 0.5, 0, 0.5, self.height);
    _label.frame = CGRectMake(kHDFDiseaseFilterCellHorizonMargin, 0, self.width -  2 * kHDFDiseaseFilterCellHorizonMargin, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor =[UIColor whiteColor];
    }
    // Configure the view for the selected state
}

@end
