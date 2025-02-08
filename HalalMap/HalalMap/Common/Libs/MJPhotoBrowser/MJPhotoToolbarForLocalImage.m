//
//  MJPhotoToolbarForLocalImage.m
//  Outing
//
//  Created by yj on 14/12/11.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "MJPhotoToolbarForLocalImage.h"

@implementation MJPhotoToolbarForLocalImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_WITH_ARGB(0, 33, 69, 0.4);
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(frame.size.width - 75, (frame.size.height - 25)/2, 56, 25);
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_doneBtn setBackgroundColor:HMMainColor forState:UIControlStateNormal];
        [_doneBtn setBackgroundColor:[HMMainColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_doneBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneBtn];
    }
    return self;
}

- (void)setCompleteNum:(NSInteger)completeNum
{
    [_doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld)",completeNum] forState:UIControlStateNormal];

}


- (void)done:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(MJPhotoToolbarForLocalImageDidClickComplete)]) {
        [self.delegate MJPhotoToolbarForLocalImageDidClickComplete];
    }
}


@end
