//
//  HMFeedInputView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/6/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMFeedInputView.h"

static const CGFloat  kFlowInputViewMinHeight = 44;
static const CGFloat  kFlowInputViewMaxHeight = 115;


@interface HMFeedInputView ()
<
UITextViewDelegate
>

@property (nonatomic, strong) UITextView * messageTextView;
@property (nonatomic, strong) UILabel * placeholderLabel;

@end


@implementation HMFeedInputView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self messageTextView];
        [self.messageTextView becomeFirstResponder];
        [self addSubview:self.placeholderLabel];
    }
    return self;
}

-(UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        WS(weakSelf);
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = self.messageTextView.font;
        _placeholderLabel.textColor = COLOR_WITH_RGB(220, 220, 220);
        _placeholderLabel.text = NSLocalizedString(@"输入评论内容", nil);
        [self addSubview:_placeholderLabel];
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(17);
            make.bottom.equalTo(weakSelf).with.offset(-15);
            make.right.equalTo(weakSelf).with.offset(-10);
        }];
    }
    return _placeholderLabel;
}

-(UITextView *)messageTextView
{
    if (!_messageTextView) {
        WS(weakSelf);
        _messageTextView = [[UITextView alloc] init];
        _messageTextView.returnKeyType = UIReturnKeySend;
        [self addSubview:_messageTextView];
        _messageTextView.backgroundColor = [UIColor whiteColor];
        _messageTextView.font = [UIFont systemFontOfSize:14.0f];
        _messageTextView.layer.masksToBounds = YES;
        _messageTextView.layer.cornerRadius = 4.0f;
        _messageTextView.layer.borderColor = HMSeperatorColor.CGColor;
        _messageTextView.layer.borderWidth = 0.5f;
        _messageTextView.delegate = self;
        _messageTextView.scrollIndicatorInsets = UIEdgeInsetsMake(8, 0, 8, -1);
        _messageTextView.contentMode = UIViewContentModeRedraw;
        _messageTextView.scrollEnabled = NO;
        _messageTextView.scrollsToTop = NO;
        _messageTextView.textAlignment = NSTextAlignmentLeft;
        _messageTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
        
        [_messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).with.offset(10);
            make.top.equalTo(weakSelf).with.offset(5);
            make.bottom.equalTo(weakSelf).with.offset(-5);
            make.right.equalTo(weakSelf).with.offset(-10);
        }];
    }
    return _messageTextView;
}



#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    [self refreshMessageTextViewWithTextView:textView];
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    [textView scrollRangeToVisible:textView.selectedRange];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if (_messageTextView.text.length > 0) {
            self.placeholderLabel.hidden = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageWithText:)]) {
                [self.delegate sendMessageWithText:_messageTextView.text];
            }
        }
        else{
            self.placeholderLabel.hidden = NO;
        }
       
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    [self refreshMessageTextViewWithTextView:textView];
    return YES;
}

-(void)refreshMessageTextViewWithTextView:(UITextView *)textView
{
    CGFloat oldHeight = self.height;
    CGFloat newTextViewHeight = [self measureHeightWithTextView:textView];
    
    CGFloat minTextViewHeight = kFlowInputViewMinHeight - 10;
    CGFloat maxTextViewHeight = kFlowInputViewMaxHeight - 10;
    
    if (newTextViewHeight <= minTextViewHeight || ![textView hasText]) {
        newTextViewHeight = minTextViewHeight;
    }
    
    if (newTextViewHeight >= maxTextViewHeight) {
        newTextViewHeight = maxTextViewHeight;
    }
    
    if (textView.height != newTextViewHeight) {
        if(newTextViewHeight >= maxTextViewHeight){
            if(textView.scrollEnabled == NO)  {
                [textView flashScrollIndicators];
                textView.scrollEnabled = YES;
            }
        }else{
            textView.scrollEnabled = NO;
        }
        self.height = newTextViewHeight + 10;
    }
    
    //在这里添加可以解决7.1，7.1.1，7.1.2等7.1后的版本问题
    if(isIOS(7) && PRE_IOS_8){
        textView.scrollEnabled = NO;
        textView.scrollEnabled = YES;
    }
    if (isIOS(7))
    {
        [self resetScrollPositionForIOS7:textView];
    }
    [textView scrollRangeToVisible:textView.selectedRange];
    //7.0.2等7.1前的版本问题还需在后面再添加一次
    if(isIOS(7) && PRE_IOS_8){
        textView.scrollEnabled = NO;
        textView.scrollEnabled = YES;
    }
    if (oldHeight != self.height){
        [self setNeedsUpdateConstraints];
        if (_delegate && [_delegate respondsToSelector:@selector(inputMessageViewChangeHeight:)]) {
            [_delegate inputMessageViewChangeHeight:self.height];
        }
    }
    
    //    [self refreshSendButtonStatus];
}


#pragma mark - 高度
- (CGFloat)measureHeightWithTextView:(UITextView *)textView {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    }
    else
    {
        return textView.contentSize.height;
    }
}

-(void)resetScrollPositionForIOS7:(UITextView *)textView
{
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
    
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY){
        textView.contentOffset = CGPointMake(0, caretY);
    }
}



+(instancetype)showFeedInputViewWithDelegate:(id<HMFeedInputViewDelegate>)delegate
{
    HMFeedInputView * inputView = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    inputView.delegate = delegate;
    inputView.backgroundColor = HMSeperatorColor;
    return inputView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
