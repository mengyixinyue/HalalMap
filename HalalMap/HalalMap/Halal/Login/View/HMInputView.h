//
//  HMInputView.h
//  HalalMap
//
//  Created by 刘艳杰 on 15/12/1.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMInputView : UIView

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, assign) BOOL secureTextEntry;//是否密文输入 默认NO

-(id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

-(void)setTitle:(NSString *)title;

-(void)setPlaceholder:(NSString *)placeholder;

@end
