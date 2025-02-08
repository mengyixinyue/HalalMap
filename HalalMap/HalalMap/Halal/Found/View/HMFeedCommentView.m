//
//  HMFeedCommentView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/6/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMFeedCommentView.h"
#import "HMFeedInputView.h"

@interface HMFeedCommentView ()
<
HMFeedInputViewDelegate
>

@property (nonatomic, strong) HMFeedInputView * messageInputView;
@property (nonatomic, assign) CGFloat inputMessageViewHeight;
@property (nonatomic, strong) HMFeedModel * theFeedModel;
@property (nonatomic, copy) NSString * parent_guid;
@property (nonatomic, strong) HMUserModel *userModel;
@end

@implementation HMFeedCommentView
{
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNotification];
        [self messageInputView];
        WS(weakSelf);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
           CGPoint touchPoint = [tap locationInView:weakSelf];
            if (touchPoint.y < weakSelf.messageInputView.top) {
                [weakSelf dismissWithAnimation:YES];
            }
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}

+(instancetype)showFeedCommentViewWithDelegate:(id<HMFeedCommentViewDelegate>)delegate feedModel:(HMFeedModel *)feedModel parent_guid:(NSString *)parent_guid userModel:(HMUserModel *)userModel
{
    HMFeedCommentView * commentView = [[HMFeedCommentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    commentView.delegate = delegate;
    commentView.theFeedModel = feedModel;
    if (parent_guid) {
        commentView.parent_guid = [NSString stringWithString:parent_guid];
    }
    if (userModel) {
        commentView.userModel = userModel;
    }
    return commentView;
}

-(void)dismissWithAnimation:(BOOL)animation
{
    [self endEditing:YES];
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.messageInputView.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [self removeNotification];
            [self removeFromSuperview];
        }];
    }
}


-(HMFeedInputView *)messageInputView
{
    if (!_messageInputView) {
        _messageInputView = [HMFeedInputView showFeedInputViewWithDelegate:self];
        self.inputMessageViewHeight = 44;
        [self addSubview:_messageInputView];
        _messageInputView.top = SCREEN_HEIGHT;
    }
    return _messageInputView;
}

#pragma mark - HMFeedInputViewDelegate
- (void)inputMessageViewChangeHeight:(CGFloat)currentHeight
{
    self.messageInputView.top -= currentHeight - self.inputMessageViewHeight;
    self.messageInputView.height += currentHeight - self.inputMessageViewHeight;
    self.inputMessageViewHeight = currentHeight;
}

- (void)sendMessageWithText:(NSString *)text
{
    [SVProgressHUD show];
    
    NSMutableDictionary * paraDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"comment" : text}];
    if (self.parent_guid) {
        [paraDict setValue:self.parent_guid forKey:@"parent_guid"];
    }
    
    [HMNetwork postRequestWithPath:HMRequestComment(_theFeedModel.feed_guid) params:paraDict success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"提交评论成功", nil)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(commentSuccess:userModel:)]) {
            
            [self.delegate commentSuccess:text userModel:self.userModel ? self.userModel : nil];
        }
        [self dismissWithAnimation:YES];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}


#pragma mark - notification
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
//    self.isEditing = YES;
    // 获取键盘的高度
    NSValue                 *aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat                 keyboardHeight = [aValue CGRectValue].size.height;
    UIViewAnimationCurve    curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double                  duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDelegate:self];
    self.messageInputView.top = SCREEN_HEIGHT - self.messageInputView.height - keyboardHeight;
    [UIView commitAnimations];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(flowServiceViewHeightDidChange:)]) {
//        [self.delegate flowServiceViewHeightDidChange:SCREEN_HEIGHT_NONAV - self.top];
//    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIViewAnimationCurve    curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double                  duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDelegate:self];
    self.messageInputView.top = SCREEN_HEIGHT - self.messageInputView.height;
    [UIView commitAnimations];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(flowServiceViewHeightDidChange:)]) {
//        [self.delegate flowServiceViewHeightDidChange:SCREEN_HEIGHT_NONAV - self.top];
//    }
}


@end
