//
//  HMCommentCellTableViewCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/25.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMCommentCell.h"
#import "HMStarView.h"

#import "HMCommentModel.h"

@interface HMCommentCell ()
<
UIGestureRecognizerDelegate
>
@end

@implementation HMCommentCell
{
    __weak IBOutlet UIImageView *_headerImageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_commentLabel;
    __weak IBOutlet UIView *_starBackgroundView;
    __weak IBOutlet NSLayoutConstraint *_starViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_starViewWidthConstraint;
        
    HMStarView * _starView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.autoresizesSubviews = NO;
    _headerImageView.layer.cornerRadius = _headerImageView.width / 2.0f;
    _headerImageView.layer.borderColor = HMBorderColor.CGColor;
    _headerImageView.layer.borderWidth = 0.5f;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer * headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapClick:)];
    [_headerImageView addGestureRecognizer:headerTap];
    
    
    _commentLabel.font = [HMFontHelper fontOfSize:11.0f];
    
    _commentLabel.preferredMaxLayoutWidth = self.contentView.width - 80;
    
}

-(void)configureWithModel:(id)model{
    if ([model isKindOfClass:[HMCommentModel class]]) {
        _commentLabel.preferredMaxLayoutWidth = self.contentView.width - 80;
        if (!_starView) {
            _starView = [HMHelper xibWithClass:[HMStarView class]];
            [_starBackgroundView addSubview:_starView];
            
            CGSize size = CGSizeMake(_starView.width, _starView.height);
            [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(_starBackgroundView);
                make.size.mas_equalTo(size);
            }];
            _starViewWidthConstraint.constant = [_starView width];
            _starViewHeightConstraint.constant = [_starView height];
        }

        HMCommentModel * commentModel = (HMCommentModel *)model;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.comment_user.avatar] placeholderImage:nil];
        _nameLabel.text = commentModel.comment_user.nickname;
        
        [_starView configureWithScore:[commentModel.stars floatValue]];
        _commentLabel.text = commentModel.comment;
        _timeLabel.text = commentModel.created_at;
        [_commentLabel sizeToFit];
    }
}

-(void)headerTapClick:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHeaderImageViewWithCommentCell:)]) {
        [self.delegate clickHeaderImageViewWithCommentCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
