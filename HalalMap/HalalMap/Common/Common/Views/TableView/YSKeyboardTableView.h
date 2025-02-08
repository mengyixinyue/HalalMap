//
//  YSKeyboardTableView.h
//  BSValueUniversal
//
//  Created by 张超毅 on 14-2-21.
//
//

#import <UIKit/UIKit.h>

@interface YSKeyboardTableView : UITableView
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
