//
//  YSKeyboardScrollView.h
//  ShiKe
//
//  Created by 李军 on 13-7-15.
//  Copyright (c) 2013年 谷硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKeyboardScrollView : UIScrollView
{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
}

@property (nonatomic) CGFloat extraKeyboardHeight;
- (void)adjustOffsetIfNeeded;

@end
