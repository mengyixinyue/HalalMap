//
//  HMChangeNameViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/22.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMChangeNameViewController.h"

@interface HMChangeNameViewController ()
<
UITextViewDelegate
>

@end

@implementation HMChangeNameViewController
{
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *_placeHolderLabel;
    __weak IBOutlet UILabel *_tipsLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_placeHolder) {
        _placeHolderLabel.text = _placeHolder;
    }
    else{
        _placeHolderLabel.text = self.navigationItem.title;
    }
    
    
    if (_maxStrNum != 0) {
        _tipsLabel.text = [NSString stringWithFormat:@"最多%d个字符", _maxStrNum];
    }
    _textView.textColor = HMBlackColor;
    _textView.font = [HMFontHelper fontOfSize:16.0f];
    
    _placeHolderLabel.textColor = HMGrayColor;
    _placeHolderLabel.font = [HMFontHelper fontOfSize:16.0f];
    
    _tipsLabel.textColor = HMGrayColor;
    _tipsLabel.font = [HMFontHelper fontOfSize:16.0f];

    if (self.oldText && self.oldText.length != 0) {
        _textView.text = self.oldText;
        _placeHolderLabel.hidden = YES;
    }
    
    self.view.backgroundColor = HMSeperatorColor;
    [self addBarButtonItemWithImageName:nil
                                  title:@"提交"
                                 action:@selector(change)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:[UIColor whiteColor]
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    _placeHolderLabel.text = _placeHolder;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _placeHolderLabel.hidden = YES;
    }
    else
    {
        _placeHolderLabel.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

-(void)change
{
    if (_textView.text == nil || _textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"内容不能为空", nil)];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeNameWithNewText:)]) {
        [self.delegate changeNameWithNewText:_textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
