//
//  HMLoginView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/9.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMLoginView.h"

@implementation HMLoginView
{
    __weak IBOutlet UIButton *_editPersonalInfo;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = _headImageView.width / 2.0f;
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.borderColor = HMBorderColor.CGColor;
    _headImageView.layer.borderWidth = 0.5f;
    
    _nameLabel.font = [HMFontHelper fontOfSize:18.0f];
    _nameLabel.textColor = HMBlackColor;
    _sayingLabel.font = [HMFontHelper fontOfSize:11.5f];
    _editPersonalInfo.titleLabel.font = [HMFontHelper fontOfSize:12.0f];
    _editPersonalInfo.layer.cornerRadius = 3.0f;
    _editPersonalInfo.layer.borderWidth = 0.5f;
    _editPersonalInfo.layer.borderColor = HMBorderColor.CGColor;
}

@end
