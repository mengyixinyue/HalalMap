//
//  HMVoteView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMVoteView.h"

@interface HMVoteView ()

@end

@implementation HMVoteView
{
    NSMutableArray * _votesArray;
}

-(id)init
{
    self = [super init];
    if (self) {
        _votesArray = [[NSMutableArray alloc] init];
        [self initialUI];
    }
    return self;
}

-(void)initialUI
{
    _textLabel = [YYLabel new];
    _textLabel.numberOfLines = 0;
    [self addSubview:_textLabel];
}

- (UIImage *)imageWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForScaledResource:name ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data scale:2];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}


-(void)configureWithArray:(NSArray *)votesArray
{
    _textLabel.text = nil;
    _textLabel.attributedText = nil;
    [_votesArray removeAllObjects];
    if (votesArray.count != 0) {
        
        [_votesArray addObjectsFromArray:votesArray];
        NSMutableArray * namesArray = [[NSMutableArray alloc] init];
        for (HMVoteModel * model in _votesArray) {
            [namesArray addObject:model.vote_user.nickname];
        }
        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] init];
        UIFont * font = [HMFontHelper fontOfSize:16.0f];
        NSMutableAttributedString * attachment = nil;
        UIImage * image = [UIImage imageNamed:@"feed_vote_list_icon.png"];
        attachment = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [attributedStr appendAttributedString:attachment];
        [attributedStr setFont:font];
        
        NSString * str = [namesArray componentsJoinedByString:@","];
        [attributedStr appendString:[NSString stringWithFormat:@" %@",str]];
        _textLabel.attributedText = attributedStr;
        _textLabel.top = 0;
        __block NSInteger location = attributedStr.length - str.length;
        __weak typeof(self) _weakSelf = self;
        
        [namesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * nameStr = obj;
            NSRange range;
            range.location = location;
            range.length = nameStr.length;
            [attributedStr setTextHighlightRange:range
                                           color:HMMainColor
                                 backgroundColor:[UIColor whiteColor]
                                        userInfo:nil
                                       tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                           NSLog(@"%@", [text.string substringWithRange:range]);
                                           HMVoteModel * voteModel =  _votesArray[idx];
                                           HMUserModel * user = voteModel.vote_user;
                                           if (_weakSelf.delegate && [_weakSelf.delegate respondsToSelector:@selector(voteViewWithClickVoterWithUser:)]) {
                                               [_weakSelf.delegate voteViewWithClickVoterWithUser:user];
                                           }
                                       }
                                 longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                     
                                 }];
            location += (nameStr.length + 1);
        }];
        CGSize size = CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT);
        YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:size text:attributedStr];
        
        _textLabel.size = layout.textBoundingSize;
        _textLabel.textLayout = layout;
    }
}

@end
