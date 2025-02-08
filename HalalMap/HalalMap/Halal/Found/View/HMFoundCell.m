//
//  HMFoundCell.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMFoundCell.h"
#import "HMFoundImageView.h"
#import "HMVoteView.h"
#import "HMCommentView.h"

#import "HMFeedModel.h"

#define HMFOUNDCELL_HorizonMargin   15
#define HMFOUNDCELL_HorizonPadding  10
#define HMFOUNDCELL_VerticalMargin  20

@interface HMFoundCell ()
<
HMVoteViewDelegate,
HMCommentViewDelegte
>
@end

@implementation HMFoundCell
{
    UIImageView         * _userImageView;
    UILabel             * _nameLabel;
    UILabel             * _timeLabel;
    UIButton            * _addressBtn;
    HMFoundImageView    *_foundImageView;
    YYLabel             * _contentLabel;
    UIButton            * _shareBtn;
    UIButton            * _reportBtn;
    UIButton            * _returnBtn;
    UIButton            * _voteBtn;
    HMVoteView          * _voteView;
    HMCommentView       * _commentView;
    UIView              * _bottomLineView;
    HMFeedModel         * _feedModel;
}

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialUI];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.contentView.bounds = [UIScreen mainScreen].bounds;

    }
    return self;
}

-(void)initialUI
{
    __weak typeof(self) _self = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.height.equalTo(_self);
    }];
    
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = 22.0f;
        _userImageView.layer.borderColor = HMBorderColor.CGColor;
        _userImageView.clipsToBounds = YES;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.userInteractionEnabled = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_userImageView];
        [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HMFOUNDCELL_HorizonMargin);
            make.top.mas_equalTo(HMFOUNDCELL_VerticalMargin);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (_self.delegate && [_self.delegate respondsToSelector:@selector(foundCell:userModel:)]) {
            [_self.delegate foundCell:_self userModel:_feedModel.feed_publisher];
        }
    }];
    [_userImageView addGestureRecognizer:tap];
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.font = [HMFontHelper fontOfSize:16.0f];
        _nameLabel.textColor = HMBlackColor;
        _nameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
        [_nameLabel sizeToFit];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userImageView.mas_right).with.offset(HMFOUNDCELL_HorizonPadding);
            make.top.mas_equalTo(24);
        }];
    }
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [HMFontHelper fontOfSize:12.0f];
        _timeLabel.textColor = HMGrayColor;
        _timeLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
        [_timeLabel sizeToFit];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userImageView.mas_right).with.offset(HMFOUNDCELL_HorizonPadding);
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
            make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - _userImageView.right - 20));
        }];
    }
    
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithTitle:nil image:[UIImage imageNamed:@"feed_location_icon.png"] titleColor:HMMainColor target:self action:@selector(addressBtnClick:)];
        _addressBtn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
        _addressBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_addressBtn];
        [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-HMFOUNDCELL_HorizonMargin);
            make.bottom.mas_equalTo(_userImageView.mas_bottom);
            make.left.greaterThanOrEqualTo(_timeLabel.mas_right).with.offset(10);
        }];
    }
    
    if (!_foundImageView) {
        _foundImageView = [[HMFoundImageView alloc] init];
        [self.contentView addSubview:_foundImageView];
        [_foundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HMFOUNDCELL_HorizonMargin);
            make.right.mas_equalTo(-HMFOUNDCELL_HorizonMargin);
            make.top.equalTo(_userImageView.mas_bottom).with.offset(12);
        }];
    }

    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.font = [HMFontHelper fontOfSize:16.0f];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HMFOUNDCELL_HorizonMargin);
            make.right.mas_equalTo(-HMFOUNDCELL_HorizonMargin);
            make.top.mas_equalTo(_foundImageView.mas_bottom).with.offset(15);
        }];
    }
    
    //分享
    if (!_shareBtn) {
        UIImage * shareImage = [UIImage imageNamed:@"feed_share.png"];
        _shareBtn = [UIButton buttonWithImage:shareImage target:self action:@selector(shareBtnClick:)];
        [self.contentView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HMFOUNDCELL_HorizonMargin);
            make.top.mas_equalTo(_contentLabel.mas_bottom).with.offset(9);
            make.size.mas_equalTo(shareImage.size);
        }];
    }
    
    if (!_reportBtn) {
        _reportBtn = [UIButton buttonWithTitle:@"举报" bgImage:nil titleColor:COLOR_WITH_RGB(183, 18, 39) target:self action:@selector(reportBtnClick:)];
        _reportBtn.titleLabel.font = [HMFontHelper fontOfSize:16.0f];
        [self.contentView addSubview:_reportBtn];
        [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_shareBtn.mas_right).with.offset(5);
            make.bottom.mas_equalTo(_shareBtn.mas_bottom);
            make.height.mas_equalTo(_shareBtn.mas_height);
            make.width.mas_equalTo(80);
        }];
    }
    
    //点赞
    if (!_voteBtn) {
        UIImage * voteImage = [UIImage imageNamed:@"feed_vote"];
        _voteBtn = [UIButton buttonWithImage:voteImage target:self action:@selector(voteBtnClick:)];
        [_voteBtn setImage:[UIImage imageNamed:@"feed_voted.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_voteBtn];
        [_voteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-HMFOUNDCELL_HorizonMargin);
            make.bottom.mas_equalTo(_shareBtn);
            make.size.mas_equalTo(voteImage.size);
        }];
    }
    
    //回复
    if (!_returnBtn) {
        UIImage * returnImage = [UIImage imageNamed:@"feed_comment"];
        _returnBtn = [UIButton buttonWithImage:returnImage target:self action:@selector(returnBtnClick:)];
        [self.contentView addSubview:_returnBtn];
        [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_voteBtn.mas_left).with.offset(-25);
            make.bottom.equalTo(_voteBtn.mas_bottom);
            make.size.mas_equalTo(returnImage.size);
        }];
    }
    
 
    
    if (!_voteView) {
        _voteView = [[HMVoteView alloc] init];
        _voteView.delegate = self;
        [self.contentView addSubview:_voteView];
        [_voteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HMFOUNDCELL_HorizonMargin);
            make.right.mas_equalTo(-HMFOUNDCELL_HorizonMargin);
            make.top.mas_equalTo(_shareBtn.mas_bottom).with.offset(18);
            make.height.mas_equalTo(_voteView.textLabel.height);
        }];
    }
    
    if (!_commentView) {
        _commentView = [[HMCommentView alloc] init];
        _commentView.delegate = self;
        [self.contentView addSubview:_commentView];
        [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(HMFOUNDCELL_HorizonMargin);
            make.right.mas_equalTo(-HMFOUNDCELL_HorizonMargin);
            make.top.mas_equalTo(_voteView.mas_bottom).with.offset(10);
            make.bottom.mas_equalTo(_self.contentView).with.offset(20);
        }];
    }
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = HMSeperatorColor;
        [self.contentView addSubview:_bottomLineView];
        [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(_self.contentView.mas_bottom);
        }];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_commentView).with.offset(20);
    }];
}

-(void)configureCellWithModel:(id)model
{
    if ([model isKindOfClass:[HMFeedModel class]]) {
        _feedModel = (HMFeedModel *)model;
        _nameLabel.text = _feedModel.feed_publisher.nickname;
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:_feedModel.feed_publisher. avatar] placeholderImage:nil];
        _timeLabel.text = @"5分钟前";
        [_timeLabel sizeToFit];

        if (_feedModel.feed_related_poi.poi_name && _feedModel.feed_related_poi.poi_name.length > 0) {
            _addressBtn.hidden = NO;
            [_addressBtn setTitle:_feedModel.feed_related_poi.poi_name forState:UIControlStateNormal];
        }
        else{
            _addressBtn.hidden = YES;
        }
        
        [_foundImageView configureWithImageArray:_feedModel.feed_images];
        
        if ([_feedModel.hasVoted isEqualToString:@"1"]) {
            _voteBtn.selected = YES;
            _voteBtn.userInteractionEnabled = NO;
        }
        else{
            _voteBtn.selected = NO;
            _voteBtn.userInteractionEnabled = YES;
        }
        //描述
        NSString * feedDescription;
        if (!_feedModel.feed_description) {
            feedDescription = @"";
        }
        else{
            feedDescription = _feedModel.feed_description;
        }
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:feedDescription];
        [attributedStr setLineSpacing:7];
        [attributedStr setFont:[HMFontHelper fontOfSize:16.0f]];
        attributedStr.color = HMBlackColor;
        _contentLabel.attributedText =attributedStr;
        
        YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) text:attributedStr];
        _contentLabel.size = layout.textBoundingSize;
        _contentLabel.textLayout = layout;
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_contentLabel.height + 7));
        }];
        
        //点赞
        [_voteView configureWithArray:_feedModel.feed_votes];
        if (_feedModel.feed_votes.count == 0) {
            [_voteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
                make.top.mas_equalTo(_shareBtn.mas_bottom).with.offset(0);
            }];
        }else{
            [_voteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(_voteView.textLabel.height);
                make.top.mas_equalTo(_shareBtn.mas_bottom).with.offset(18);
            }];
        }
        
        //评价
        [_commentView configureWithCommentArray:_feedModel.feed_comments];
        if (_feedModel.feed_comments.count == 0) {
            [_commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
                make.top.mas_equalTo(_voteView.mas_bottom).with.offset(0);
            }];
        }
        else{
            [_commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_voteView.mas_bottom).with.offset(10);
            }];
        }
        
        [self updateConstraints];
        
    }
}

-(void)addressBtnClick:(UIButton *)btn
{
    NSLog(@"餐厅名字");
    if (self.delegate && [self.delegate respondsToSelector:@selector(poiClickWithFoundCell:)]) {
        [self.delegate poiClickWithFoundCell:self];
    }
}

-(void)shareBtnClick:(UIButton *)btn
{
    NSLog(@"分享");
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareBtnClickWithFoundCell:)]) {
        [self.delegate shareBtnClickWithFoundCell:self];
    }
}

-(void)reportBtnClick:(UIButton *)btn
{
    NSLog(@"举报");
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportBtnClickWithFoundCell:)]) {
        [self.delegate reportBtnClickWithFoundCell:self];
    }
}

-(void)returnBtnClick:(UIButton *)btn
{
    NSLog(@"回复");//自己回复信息
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnBtnClickWithFoundCell:)]) {
        [self.delegate returnBtnClickWithFoundCell:self ];
    }
}

-(void)voteBtnClick:(UIButton *)btn
{
    NSLog(@"赞");
    if (btn.selected) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(voteBtnClickWithFoundCell:)]) {
        [self.delegate voteBtnClickWithFoundCell:self];
    }
}

#pragma mark - HMVoteViewDelegate
-(void)voteViewWithClickVoterWithUser:(HMUserModel *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(foundCell:userModel:)]) {
        [self.delegate foundCell:self userModel:user];
    }
}

#pragma mark -HMCommentViewDelegte
-(void)clickUserWithCommentView:(HMCommentView *)commentView user:(HMUserModel *)userModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(foundCell:userModel:)]) {
        [self.delegate foundCell:self userModel:userModel];
    }
}

-(void)clickCommentWithCommentView:(HMCommentView *)commentView user:(HMUserModel *)userModel commentModel:(HMCommentModel *)commentModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnBtnClickWithFoundCell:userModel:commentModel:)]) {
        [self.delegate returnBtnClickWithFoundCell:self userModel:userModel commentModel:commentModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
