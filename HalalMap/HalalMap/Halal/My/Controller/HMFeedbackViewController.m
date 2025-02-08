//
//  HMFeedbackViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/6/21.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMFeedbackViewController.h"

@interface HMFeedbackViewController ()
<
UITextViewDelegate
>

@end

@implementation HMFeedbackViewController
{
    __weak IBOutlet NSLayoutConstraint *_anchorViewHeightConstraint;
    __weak IBOutlet UIScrollView *_scrollView;
    
    
    __weak IBOutlet UIView *_contentView;
    __weak IBOutlet UILabel *_placeholderLabel;
    __weak IBOutlet UITextView *_contentTextView;
    
    
    __weak IBOutlet UIView *_emailBGView;
    
    __weak IBOutlet UITextField *_emailTextField;
    
    __weak IBOutlet UIButton *_commitBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"意见与反馈", nil);
    _contentView.layer.borderColor = HMSeperatorColor.CGColor;
    _contentView.layer.borderWidth = 0.5f;
    _placeholderLabel.font = [HMFontHelper fontOfSize:16.0f];
    _contentTextView.font = [HMFontHelper fontOfSize:16.0f];
    
    _emailTextField.font = [HMFontHelper fontOfSize:16.0f];
    
    _emailBGView.layer.borderColor = HMSeperatorColor.CGColor;
    _emailBGView.layer.borderWidth = 0.5f;
    
    _commitBtn.layer.borderWidth = 0.5f;
    _commitBtn.layer.borderColor = COLOR_WITH_RGB(151, 151, 151).CGColor;
    _commitBtn.titleLabel.font = [HMFontHelper fontOfSize:18.0f];
    _commitBtn.layer.cornerRadius = 4.0f;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
}

- (IBAction)commitBtnClick:(UIButton *)sender
{
    if (_contentTextView.text && _contentTextView.text.length <= 0 ) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请输入反馈的内容", nil)];
        return;
    }
    
    if (_contentTextView.text.length >= 1500) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"反馈内容太长了，不能超过1500字哦", nil)];
        return;
    }
    
    if (_emailTextField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请输入您的邮箱", nil)];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"description" : _contentTextView.text,
                              @"email" : _emailTextField.text
                              };
        [HMNetwork postRequestWithPath:HMRequestFeedback params:params success:^(HMNetResponse *response) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"提交成功", nil)];
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1];
        } failure:^(HMNetResponse *response, NSString *errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }];
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _anchorViewHeightConstraint.constant = _commitBtn.bottom > SCREEN_HEIGHT ? _commitBtn.bottom + 20 : SCREEN_HEIGHT + 1;
    [self updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
