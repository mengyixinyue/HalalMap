//
//  HMCommentView.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/23.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMCommentView.h"

#define MAXLINE  (3)

@implementation HMCommentView
{
    NSMutableArray * _commentsArray;
}

-(id)init
{
    self = [super init];
    if (self) {
        _commentsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)configureWithCommentArray:(NSArray *)commentArray
{
    [self removeAllSubViews];
    [_commentsArray removeAllObjects];
    [_commentsArray addObjectsFromArray:commentArray];
    CGFloat height = 0;
    NSInteger count = _commentsArray.count > MAXLINE ? MAXLINE : _commentsArray.count;
    for (int i =0; i < count; i ++) {
        HMCommentModel * commentModel = _commentsArray[i];
        YYLabel * label = [[YYLabel alloc] init];
        UIFont * font = [HMFontHelper fontOfSize:16.0f];
        NSMutableAttributedString * attributedStr;
        NSString * str;
        NSArray * userModelArray;
        NSArray * nameRangeArray;
        if (commentModel.parent_comment_user) {
            str = [NSString stringWithFormat:@"%@回复%@：%@", commentModel.parent_comment_user.nickname, commentModel.comment_user.nickname, commentModel.comment];
            userModelArray = [NSArray arrayWithObjects:commentModel.parent_comment_user, commentModel.comment_user, nil];
            
            NSRange range1 = NSMakeRange(0, commentModel.parent_comment_user.nickname.length);
            NSRange range2 = NSMakeRange(range1.length + 2, commentModel.comment_user.nickname.length);
            nameRangeArray = [NSArray arrayWithObjects:[NSNumber valueWithRange:range1],[NSNumber valueWithRange:range2], nil];
        }
        else{
            str = [NSString stringWithFormat:@"%@：%@", commentModel.comment_user.nickname, commentModel.comment];
            userModelArray = [NSArray arrayWithObjects:commentModel.comment_user, nil];
            NSRange range1 = NSMakeRange(0, commentModel.comment_user.nickname.length);
            nameRangeArray = [NSArray arrayWithObjects:[NSNumber valueWithRange:range1], nil];
        }
        attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        __weak typeof(self) _weakSelf = self;

        [userModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [nameRangeArray[idx] rangeValue];
            [attributedStr setTextHighlightRange:range
                                           color:HMMainColor
                                 backgroundColor:[UIColor whiteColor]
                                       tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                           NSLog(@"%@", [text.string substringWithRange:range]);
                                           if (_weakSelf.delegate && [_weakSelf.delegate respondsToSelector:@selector(clickUserWithCommentView:user:)]) {
                                               [_weakSelf.delegate clickUserWithCommentView:_weakSelf user:userModelArray[idx]];
                                           }
                                       }];
            NSRange textRange = [str rangeOfString:commentModel.comment];

            [attributedStr setTextHighlightRange:textRange color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                if (_weakSelf.delegate && [_weakSelf.delegate respondsToSelector:@selector(clickCommentWithCommentView:user:commentModel:)]) {
                    [_weakSelf.delegate clickCommentWithCommentView:_weakSelf user:userModelArray[idx] commentModel:commentModel];
                }
            }];
            

        }];
        
        [attributedStr setLineSpacing:7];
        [attributedStr setFont:font];
        label.attributedText =attributedStr;
        [self addSubview:label];

        YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) text:attributedStr];
        label.size = layout.textBoundingSize;
        label.textLayout = layout;
        label.top = height;
        height += (label.height + 7);
        
    }
    if (_commentsArray.count > 3) {
        YYLabel * label = [[YYLabel alloc] init];
        UIFont * font = [HMFontHelper fontOfSize:16.0f];
        NSMutableAttributedString * attributedStr;
        NSString * str = [NSString stringWithFormat:@"查看全部%lu条评论", (unsigned long)_commentsArray.count];
        attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range;
        range.location = 0;
        range.length = attributedStr.string.length;
        [attributedStr setTextHighlightRange:range
                                       color:HMMainColor
                             backgroundColor:[UIColor whiteColor]
                                   tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                       NSLog(@"%@", [text.string substringWithRange:range]);
                                   }];
        [attributedStr setLineSpacing:7];
        [attributedStr setFont:font];
        label.attributedText =attributedStr;
        [self addSubview:label];
        
        YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) text:attributedStr];
        label.size = layout.textBoundingSize;
        label.textLayout = layout;
        label.top = height;
        height += (label.height + 7);
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

@end
